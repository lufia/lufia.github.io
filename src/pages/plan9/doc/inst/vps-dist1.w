---
title: さくらVPSでPlan 9ネットワークを構成してみた
style: ../../../../styles/global.css
pre: ../../include/u.i
post: ../../include/nav.i
---

.revision
2014年5月4日作成
=さくらVPSでPlan 9ネットワークを構成してみた

	さくらVPSを使って、フルシステムのPlan 9を作ってみます。
	最終的に、ファイルサーバ、認証サーバ、CPUサーバの3つ建てて、
	インターネットからdrawtermでアクセスできるところまでの予定です。

	=方針

	ざっくりと構成方針です。

	|*ホスト*	*カーネル*	*ether0*			*ether1*		*fs*
	|fs		pccpuf	133.242.aaa.aaa	192.168.1.3	venti+fossil
	|auth		pcauth	133.242.bbb.bbb	192.168.1.7	fossil
	|cpu		pccpu	133.242.ccc.ccc	192.168.1.23	fossil

	authとcpuは、最終的にfsをルートにマウントするので、
	fossilのみで構成しています。

	133.242.ではじまるアドレスは、
	さくらVPSに割り当てられているアドレスを使います。
	ネットワークの構成(ipgw, ipmaskなど)は
	VPSコントロールパネルのOSインストール時に見られます。
	それ以外の方法で知る方法は知りませんので、
	情報を控えておいたほうがいいでしょう。

	=準備

	まずは3台のVPSが必要なので、NICを認識するところまで作業します。
	VPSに単体Plan 9をインストールする部分は、[さくらVPSにPlan 9をインストール|
	vps.w]を読んでください。

	サーバ3台の構築が終わったら、VPSコントロールパネルから、
	ローカルネットワークの追加が必要です。
	これは本契約でなければ使えません。
	本契約になってしばらくすればサーバ一覧に出てきます。
	サーバを停止した状態で、各サーバのNIC1にローカルネットワークを接続します。
	これでローカルネットワーク経由での通信が可能となります。

	このネットワークは扱いがちょっと面倒です。
	OS再インストールをすると、おそらくISOからブートするより前に、
	ローカルネットワーク構成がリセットされてしまいますので
	忘れずに再接続しなければなりません。

	また、インターネット側はNIC0にだけ割り当て可能です。
	Plan 9は/netに内部ネットワークをバインドしたほうが楽なのですが、
	\*/lib/namespace*の中でether0(NIC0)を*/net*にバインドしているので
	これをether1へ切り替える必要があります。
	切り替えたことにより、fsをルートにマウントするサーバは
	かならずNICを2枚以上使って、NIC0をインターネット側に、
	NIC1をローカルネットワークしなければならなくなります。

	=ファイルサーバ

		NICを認識したpcfカーネルが動作した直後だと仮定しています。

		=タイムゾーン構成

		.console
		!fs% con -l /srv/fscons
		!prompt: uname adm +glenda
		!prompt: ctl+\
		!>>> q
		!fs% cd /adm/timezone
		!fs% cp Japan local

		=ファイルサーバ用カーネルインストール

		.console
		!fs% cd /sys/src/9/pc
		!fs% mk 'CONF=pccpuf'
		!fs% 9fat:
		!fs% mv 9pccpuf /n/9fat
		!fs% mk 'CONF=pccpuf' nuke

		終わったら、*/n/9fat/plan9.ini*を編集。
		bootfileエントリは、ブート時にカーネルを選べるように、
		変更ではなく追加したほうがいいでしょう。

		.ini
		!bootfile=sdC0!9fat!9pccpuf
		!sysname=fs
		!auth=192.168.1.7
		!console=0 b115200 l8 pn s1

		=ネットワーク構成

		ローカルネットワーク(NIC1)を*/net*に割り当てるように変更します。

		.console
		!fs% grep /net /lib/namespace
		!bind -a #l1 /net  (オリジナルは#lだった)
		!bind -a #I /net

		NIC0は*/net.alt*へ割り当てますが、サーバによっては
		どちらも/netに割り当てたい場合があるので、
		サーバ固有構成のほうで設定します。

		.console
		!fs% cat /cfg/fs/namespace
		!bind -a #l0 /net.alt
		!bind -a #I1 /net.alt

		\*cpurc*で各NICへIPアドレスを設定。
		途中の$ipgwは、インストール時に示されたゲートウェイアドレス。

		.console
		!% cat /cfg/fs/cpurc
		!ip/ipconfig ether /net/ether1 add 192.168.1.3 255.255.255.0
		!ip/ipconfig -x.alt -g $ipgw ether /net.alt/ether0 add 133.242.aaa.aaa 255.255.254.0
		!ndb/dns -r
		!ndb/cs -x.alt -f /lib/ndb/external
		!ndb/dns -rx.alt -f /lib/ndb/external
		!aux/timesync -n /net.alt/udp!ntp1.sakura.ad.jp
		!aux/listen -q -d /cfg/$sysname/service tcp
		!sleep 3

		\*/cfg/fs/service*は、*/rc/bin/service*をコピーして
		必要なサービスだけ残しています。9pサービスだけあればいいのですが、
		何もListenしていないと*/rc/bin/cpurc*でいろいろサービスが起動してしまうので、
		今回は割と無難な*tcp9*(discard)だけ立てていますが、
		ほかに、*/rc/bin/cpurc*を変更してしまってもいいと思います。

		\*/lib/ndb/local*, */lib/ndb/external*は適切な値で構成しておきます。
		\*local*のほうはipnetを使ってグループにまとめられますが、
		グローバルIPアドレスはばらばらなので、個別に設定しましょう。
		だいたいこんな感じ。

		.ini
		!sys=fs dom=fs.domain.dom
		!	ether=xxxxxxxx
		!	ip=133.242.aaa.aaa
		!	ipgw=xxx.xxx.xxx.xxx
		!	ipmask=255.255.254.0
		!	dns=133.242.0.3
		!	dns=133.242.0.4

		=サーバ構成

		bootesユーザを追加します。

		.console
		!fs% con -l /srv/fscons
		!prompt: uname bootes bootes
		!prompt: ctl+\
		!>>> q

		ファイルサーバを他のサーバからマウントできるように、
		tcp564をListenするようにfossilを変更。
		\*/rc/bin/service/!tcp564*もあるけれど、こっちは使わない。

		.console
		!fs% fossil/conf /dev/sdC0/fossil >/tmp/flproto
		!fs% echo 'listen tcp!*!564' >>/tmp/flproto
		!fs% fossil/conf -w /dev/sdC0/fossil /flproto
		!fs% rm /tmp/flproto

		必要なユーザやファイルをあらかじめ作っておいて再起動。

		.console
		!prompt: uname adm +bootes
		!prompt: uname adm -glenda
		!prompt: uname sys -glenda
		!prompt: uname adm -sys (これは好み)
		!prompt: fsys main
		!prompt: create /active/sys/log/cron sys sys a666
		!prompt: create /active/adm/secstore adm adm d775

		.console
		!fs% fshalt
		!(停止したらコントロールパネルから再起動)

		理由は分かりませんが、Plan 9でctl+t, ctl+t, rとリブートすると
		VPSの状態が「不明」になって、強制停止も起動もできなくなります。
		こうなると、不明から脱するには再インストールを行って
		むりやり「起動」状態に戻す必要があります。
		(「起動」になればいいので、再インストールを最後まで行う必要はありません)

		=再起動後

		\*9pccpuf*カーネルで起動したら、
		最初にbootesの情報をきかれるので入力します。
		残りのサーバにも同じものを設定する必要があります。

		終わったら、*/sys/log*にエラーが出ていないか、
		必要なサービスだけになっているかを確認して終わり。

		.console
		!fs# netstat | grep Listen
		!fs# netstat /net.alt | grep Listen
