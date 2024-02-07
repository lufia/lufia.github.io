---
title: 認証サーバのインストール
style: ../../../../styles/global.css
pre: ../../../../layouts/plan9/u.i
post: ../../../../layouts/plan9/nav.i
---

.revision
2006年11月12日更新
=認証サーバのインストール

	=認証サーバカーネルのインストール

		.note
		{
			=ilの組み込み

			dumpfsへ接続する場合には、ilの組み込みが必須です。
			詳細は[カーネルにilを組み込む|il.w]をみてください。
			fossilやventiを使う場合には不要です。
		}

	\*/sys/src/9/pc/pcauth*が認証サーバカーネルの設定ファイルになります。
	必要なら*pcauth*に手を入れて、カーネルをコンパイルします。
	コマンドは以下。

	.console
	!% cd /sys/src/9/pc
	!% mk 'CONF=pcauth'

		.note
		{
			=一般ユーザでのコンパイル

			通常、sysグループに属していないユーザでは、
			\*/sys/src/9*に書き込みができないのでコンパイルできません。
			そういう場合、[bind(1)]をうまく使うことによって、
			書き込み先を変更するテクニックがあります。

			.sh
			!#!/bin/rc
			!
			!if(! test -e $home/cpu){
			!	mkdir -p $home/cpu/ ^ (pc port boot)
			!	cp /sys/src/9/pc/pcauth $home/cpu/pc/pcauth
			!}
			!bind -bc $home/cpu/pc /sys/src/9/pc
			!bind -bc $home/cpu/port /sys/src/9/port
			!bind -bc $home/cpu/boot /sys/src/9/boot
			!bind $home/cpu/pcauth /sys/src/9/pc/pcauth
			!
			!echo 'cd /sys/src/9/pc && mk ''CONF=pcauth'''

			このスクリプトは[ADSLでお気軽自宅サーバ|
			http://www.geocities.co.jp/SiliconValley/6131/plan9/easyserver.html]
			を参考にしました。
		}

	コンパイルが終われば、*/n/9fat/*に*9pcauth*をコピーします。
	最後に*/n/9fat/plan9.ini*に以下を追加すると、
	起動時にどちらのカーネルを使うか尋ねられるようになります。
	すでにあるbootfileを書き換えた場合は聞かれません。

	.ini
	!bootfile=sdC0!9fat!9pcauth

	まだ再起動しません。

	=ネットワーク構成の編集

	\*/lib/ndb/local*に、認証サーバまわりの項を追加します。
	詳しくは[ネットワークの設定|../adm/ndb.w]に書きます。

	=サービスの隔離

	通常、サービスは*/rc/bin/^(service service.auth)*をもとに起動しますが、
	せっかく*/cfg/$sysname*というサーバ固有の場所があるのですから
	そちらに移してしまったほうが管理しやすいと思うので移動させます。

	.console
	!# mkdir /cfg/$sysname/ ^ (service service.auth)
	!# cp -gux /rc/bin/service/* /cfg/$sysname/service
	!# cp -gux /rc/bin/service.auth/* /cfg/$sysname/service.auth

	.note
	{
		fsカーネルをルートファイルシステムとしている場合は、
		allowしないと所有者情報などが書き込みできません。
		その場合、次のようにします。

		fsカーネルコンソールから、各ディレクトリを作成。
		fs:というのはファイルサーバのプロンプトになります。

		.console
		!fs: create /cfg/wisp/service sys sys 775 d
		!fs: create /cfg/wisp/service.auth sys sys 775 d
		!fs: allow		# 所有者もコピーするため

		認証サーバでファイルといっしょに所有者情報もコピーする。

		.console
		!cpu% cp -gux /rc/bin/service/* /cfg/wisp/service
		!cpu% cp -gux /rc/bin/service.auth/* /cfg/wisp/service.auth

		ファイルサーバコンソールから、後始末。

		.console
		!fs: disallow
	}

	=cpurcの編集

	次に、*cpurc*を編集します。
	以前は*/rc/bin/cpurc*を直接編集する方法でしたが、
	いつの間にか*/cfg/$sysname/cpurc*を用意する形になりました。
	2007年4月には変わってましたね。

	.sh
	!eval `{ndb/ipquery sys $sysname ip ipgw ipmask}
	!ip/ipconfig -g $ipgw ether /net/ether0 add $ip $ipmask
	!ndb/dns -r
	!aux/timesync -rL
	!
	!auth/keyfs -wp -m /mnt/keys /adm/keys >/dev/null >[2=1]
	!auth/cron >>/sys/log/cron >[2=1] &
	!auth/secstored
	!
	!aux/listen -q -t /cfg/wisp/service.auth -d /cfg/$sysname/service tcp
	!
	!# ilを組み込んだ場合は以下も有効に
	!#aux/listen -q -t /cfg/wisp/service.auth -d /cfg/$sysname/service il
	!
	!sleep 3

	愛知大学の真似をしてndbからデータを引いていますが、
	IPを直接書いてしまってもかまいません。
	sleepは、サービスが立ち上がりきるのを待ってます。

	最後に、念のため*nvram*を壊しておいて、再起動。

	.console
	!% echo blah >/dev/sdC0/nvram

	=nvramの設定

	初回起動時に、認証のための情報をいくつか尋ねられます。
	この情報を変更したい場合は、再度*nvram*を壊して再起動するか、
	認証サーバのコンソールからauth/wrkeyを実行すればいいです。

	!authid: bootes
	!authdom: mana.lufia.org
	!secstore: xxxxx
	!password: zzzzz

	secstoreには、bootesのsecstoreパスワードを入力します。
	imap4sを立てるときに鍵置き場として使いましたが、
	通常は空でいいと思います。

	=ユーザbootesの作成

	.console
	!# auth/changeuser -p bootes  # パスワードはnvramと同じ

	=認証でadmとsysをはじく

	sysとadmをユーザとして認証しないように、
	\*/lib/ndb/auth*に以下を追加します。

	.ini
	!hostid=bootes
	!    uid=!sys uid=!adm uid=*

	=デバッグ

	認証サーバのコンソールからauth/debugを使うと、
	登録されているユーザごとに認証のテストが行えます。
	認証でこけている場合は、*cpurc*等でのコマンド呼び出し順が
	違うのかもしれません。
	名前空間の関係から、順番がかなり重要になっています。
	何度か引っかかりました。

.aside
{
	=関連情報
	*[カーネルにilを組み込む|il.w]
	*[分散システムのインストール|dist.w]

	=参考ページ
	*[Configuring a Standalone CPU Server|
	https://9p.io/wiki/plan9/Configuring_a_Standalone_CPU_Server/index.html]
	*[ADSLでお気軽自宅サーバ|
	http://www.geocities.co.jp/SiliconValley/6131/plan9/easyserver.html]
}
