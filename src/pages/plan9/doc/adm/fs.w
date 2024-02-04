---
title: ファイルサーバの管理
pre: ../../include/u.i
post: ../../include/nav.i
---

=ファイルサーバの管理
.revision
2010年11月12日更新

	調べながら書いてます。
	未整理のものは[日記のほう|/notes/fs.w]にもありますよ。

	=filesコマンド

	!N out of M files used
	!  A:     B
	!O out of M files used

	:N
	-開いているファイル数
	:M
	-conf.nfile
	:A
	-コネクションのチャネルナンバー
	-whoのものと同じ
	:B
	-Aが開いているファイル数
	:O
	-Bの合計

	=checkコマンド

	:nfiles
	-総ファイル数
	:fsize
	-sb->>fsize
	:nused
	-有効ブロック総数
	:ndup
	-重複したブロック数(amark)..有効ブロック
	:nfree
	-フリーリスト中の総ブロック数
	:tfree
	-たぶん、排他ロックなファイルを開いている数
	:nfdup
	-重複したブロック数(fmark)..フリーリスト
	:nmiss
	-fsize-fstart-nused-nfree
	:nbad
	-fstart..fsizeに収まらないブロックアドレス数
	:nqbad
	-0..sizqbitsに収まらないqid.pathの数
	:maxq
	-最大のqid.path

	=statw

	!cwstats main
	!	filesys main
	!	nio   =      1      1      2
	!		maddr  =        3
	!		msize  =   267049
	!		caddr  =    26708
	!		csize  = 17892283
	!		sbaddr =   423710
	!		craddr =   423938   423938
	!		roaddr =   423941   423941
	!		fsize  =   423943   423943  0+ 1%
	!		slast  =            423409
	!		snext  =            423942
	!		wmax   =   423941           0+ 1%
	!		wsize  = 30524356           1+ 0%
	!		17804952 none
	!		    60 dirty
	!		     0 dump
	!		 86888 read
	!		   383 write
	!		     0 dump1
	!		cache  1% full

	=statd

	!	0.0 work =      1      1      1 xfrs
	!	    rate =   7334   9050   8725 tBps
	!	1.14 work =      0      0      0 xfrs
	!	    rate =      0      0     88 tBps
	!	1.15 work =      0      0      0 xfrs
	!	    rate =      0      0     48 tBps

	=コンソールのログを取る方法

	9fansより。

	>You have to set up console logging yourself on a cpu server, like this:

	.sh
	!aux/clog /mnt/consoles/fileserver /sys/log/fileserver &

	>where "fileserver" is the name of your file server.
	> This assumes you've already got [consolefs(4)] configured,
	> running and mounted, and that
	> you've got the file server's serial console configured
	> and wired up to a serial port on the cpu server doing the logging.
	> Add this to your file server's plan9.ini:

	.ini
	!console=0 baud=9600

	>It's a bit of work to set up, but very handy.
	> Not only do you get a console log,
	> but you can access the console from any of your Plan 9 machines with:

	.sh
	!C fileserver

		=ファイルサーバ側の設定
		ファイルサーバの*plan9.ini*に、consoleの設定を追加します。
		このconsoleは0または1を設定でき、ポート0またはポート1から
		データを流す、という意味になります。
		baudはデフォルトで9600なので省略してもいいです。

		.ini
		!console=0

		ログの受け皿も用意しておきます。

		.console
		!fs: create /sys/log/fileserver sys sys 666 a

		=ログを受け取る側の設定
		まず、*/lib/ndb/consoledb*を編集します。

		.ini
		!# see consolefs(4)
		!group=sys
		!	uid=bootes
		!console=fileserver dev=/dev/eia0 openondemand=1
		!	gid=sys

		次に*/cfg/$sysname/namespace*。
		シリアルポートを*/dev*にbindします。
		このファイルはシェルスクリプトのように見えますが、
		限られたコマンドしか受け付けません。
		詳細は[namespace(6)]。

		.sh
		!bind -a #t /dev

		最後に、/cfg/$sysname/cpustartあたりに以下を追加。

		.sh
		!aux/consolefs
		!aux/clog /mnt/consoles/fileserver /sys/log/fileserver &

		=トラブルシューティング
			=/dev/eia0等が無い
			カーネルデバイス#tから見えますので、
			\*/cfg/$sysname/namespace*あたりからbindします。

			=/cfg/$sysname/namespaceが実行されない
			\*/cfg/$sysname/namespace*にbindを書いているのに
			\*/dev/eia0*が見つからない場合。
			環境変数sysnameが設定されていないかもしれません。

			受信側のplan9.iniに、sysnameを追加します。
			.ini
			!sysname=wisp

			または、consolefsを実行する直前にbindするとか。

			.note
			{
				おそらく、namespaceの後にcpurcとなるので、
				\*/lib/namespace*の最後にある$sysnameを使った行は
				\*plan9.ini*で設定しない限り実行されないのでしょう。。
				手で設定したものとndb/csの結果が
				違ったらどうするのだろうというのは置いておいて。

				と思ってたら、起動順について[9fansで話題に上がりました|
				http://9fans.net/archive/2010/09/346]。

				+init
				+newns
				+/lib/namespace
				+/cfg/$sysname/namespace(あれば)
				+/rc/bin/cpurc

				ここで、$sysnameは設定されていないので読みません。
				では何のためにあるのかというと、ブート後、
				名前空間を変更する場合に使うらしいです。
				auth/noneとか、listen(8)の*/rc/bin/service*とか。
				service.authのほうは、呼び出し元と同じ名前空間みたい。
			}

			=データを受信しない
			デバッグなどのため、ふつうのユーザで動かしている場合は、
			bootesで試してみてください。
			bootes以外ではなぜかうまくいかなかった記憶がやんわりと。

.aside
{
	=関連情報
	*[fs(8)]
	*[listenについて|listen.w]
}
