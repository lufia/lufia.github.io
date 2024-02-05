---
title: さくらVPSでPlan 9ネットワークを構成してみた
style: ../../../../styles/global.css
pre: ../../include/u.i
post: ../../include/nav.i
---

.revision
2014年5月5日作成
=さくらVPSでPlan 9ネットワークを構成してみた

	=認証サーバの構成

		=カーネルのインストール

		まずはpcauthカーネルのインストール。
		ですが、標準のpcauthはetherigbeを含んでいないので、
		自分で足してからコンパイルが必要です。
		pcfカーネルあたりを真似て、etherigbeの行をpcauthへ足しましょう。

		.console
		!auth% cd /sys/src/9/pc
		!auth% mk 'CONF=pcauth'
		!auth% 9fat:
		!auth% mv 9pcauth /n/9fat/

		いつものように*plan9.ini*へ追加します。

		.ini
		!bootargs=tcp ether /net/ether1 add 192.168.1.7 255.255.255.0
		!sysname=auth
		!fs=192.168.1.3
		!auth=192.168.1.7
		!console=0 b115200 b8 pn s1

		=サービス準備

		次に*/cfg/auth/cpurc*です。
		認証サーバなのでauth/keyfs等を動作させます。

		.sh
		!ip/ipconfig -x.alt -g $ipgw /net.alt/ether0 add 133.242.bbb.bbb 255.255.254.0
		!aux/timesync -f
		!
		!ndb/dns -r
		!auth/keyfs -wp -m /mnt/keys /adm/keys >/dev/null >[2=1]
		!auth/cron >>/sys/log/cron >[2=1] &amp;
		!auth/secstored
		!aux/listen -q -t /cfg/$sysname/service.auth -d /cfg/$sysname/service tcp
		!
		!ndb/cs -x.alt -f /lib/ndb/external
		!ndb/dns -rx.alt -f /lib/ndb/external
		!aux/listen -q -t /cfg/$sysname/service.alt.auth /net.alt/tcp
		!sleep 3

		\*service.auth*と*service.alt.auth*に*tcp567*をコピーしておきます。

		namespaceはファイルサーバと同じ。authファイルの更新も。

		.console
		!auth% cat /cfg/auth/namespace
		!bind -a #l0 /net.alt
		!bind -a #I1 /net.alt
		!auth% cat /lib/ndb/auth
		!hostid=bootes
		!	uid=!sys uid=!adm uid=*

		終わったらコントロールパネルから再起動。

		=IPプロトコルスタックについて(余談)

		Plan 9はIPプロトコルスタックを分ける事ができます。
		プロトコルスタックはカーネルデバイス#I0から#I15まで存在します。
		今回構成しているサーバは*/net*と*/net.alt*を分けて使っています。
		これは内部からのみアクセスするサービス(*/net*)と
		外部からのアクセス(*/net.alt*)を分ける事が目的です。
		さくらVPSはルータやファイアウォールがありませんので、このようにしています。

		このプロトコルスタックを使い分ける時は、
		通常tcp!host!portとするところを、/net.alt/tcp!host!portとします。
		アドレスが/からはじまらない場合は/net/が使われます。
		アドレスのルールは[announce(2)]に記述されています。

		最後に*plan9.ini*のbootargsエントリとip/ipconfigは、
		若干-xオプションの挙動が異なります。
		ip/ipconfigは、以下どちらも同じように*/net.alt*を使います。

		.sh
		!ip/ipconfig -x .alt
		!ip/ipconfig -x /net.alt

		これは[setnetmtpt(2)]の動作で、/からはじまらない名前は
		/netという文字列を名前の先頭に加えるからです。
		しかしbootargsエントリは、

		.ini
		!bootargs=tcp -x .alt ...
		!bootargs=tcp -x /net.alt ...

		なぜかカーネルの中で、無条件に/netを先頭へ追加していました。
		なので上の例は動作しますが、下の例では*/net/net.alt*が無いのでこけます。

		=再起動とユーザ登録

		VPSコントロールパネルから再起動させて、*9pcauth*カーネルで起動させます。
		ファイルサーバと同じ内容でbootesのパスワードなどを設定して、
		認証サーバ上にもユーザを作成して終わり。

		.console
		!auth# auth/changeuser -p bootes

		secstoreも使うなら、secstoreユーザの登録も忘れずに。

		.console
		!auth# auth/secuser -v bootes

	=CPUサーバの構成

		だいたい他のサーバと同じですが、CPUサーバの場合は
		内部だけで閉じたいサービスが無いので、
		両方のNICを/netにまとめて使うようにします。

		=カーネルのインストール

		コンフィグが違う以外はだいたい同じ。

		.console
		!cpu% mk 'CONF=pccpu'
		!cpu% mv 9pccpu /n/9fat/

		\*plan9.ini*に以下を追加。

		.ini
		!bootfile=sdC0!9fat!9pccpu
		!bootargs=tcp -g $ipgw ether /net/ether1 add 192.168.1.23 255.255.255.0
		!sysname=cpu
		!fs=192.168.1.3
		!auth=192.168.1.7

		\*namespace*は*/net*しか使わないのでシンプルです。

		.console
		!cpu% cat /cfg/cpu/namespace
		!bind -a #l /net

		\*cpurc*も同じように*/net*しか使いません。

		.console
		!cpu% cat /cfg/cpu/cpurc
		!ip/ipconfig ether /net/ether0 add 133.242.ccc.ccc 255.255.254.0
		!aux/timesync -f
		!ndb/dns -r
		!aux/listen -q -d /cfg/$sysname/service tcp
		!sleep 3

		cpuサービスを実行させるために、*tcp17010*を*/cfg/$sysname/service*へコピー。

		.console
		!cpu% cp /rc/bin/service/tcp17010 /cfg/$sysname/service/

		=再起動

		コントロールパネルから再起動して、bootesを登録したら終わりです。
		これでdrawtermからアクセスすれば動作するはず。
