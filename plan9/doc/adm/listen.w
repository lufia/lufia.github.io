@include u.i
%title listenについて

=listenについて
.revision
2009年9月28日更新

	=listenとは

	Unixでいうところの、inetdのようなものです。
	ポートにアクセスがあった場合、
	標準入出力をネットワークに切り替えて、
	対応するプログラムをネットワークサービスとして実行します。

	通常、/rc/bin/service, /rc/bin/service.authの2つあり、
	どちらかにサービスプログラムを分類します。
	この2つの違いは、service.authはホストオーナー(bootes)として
	サービスを実行しますが、serviceではnoneとして実行します。
	これらは、listenの-tオプションと-dオプションで切り替えられます。

	呼び出すプログラムの名前は、tcp25のように、
	プロトコル+ポート番号になり、それ以外は無視されます。

	=標準で準備されているサービス

		ftp, telnetなど有名どころは置いておいて。
		分からなかったものを調べてみました。

		:tcp7(echo)
		-送信されたデータを単に送り返すサービス
		:tcp9(discard)
		-受信したデータを単に捨てるサービス
		:tcp19(chargen)
		-入力に関わらず単にデータを送り返すサービス
		:tcp113(ident)
		-接続したサーバのユーザー情報を返すサービス
		:tcp565(whoami)
		-i am $x sysname $x you are $x port $x

		=不明なもの

		*tcp17005
		*tcp17006

		これらは/bin/ocpuというコマンドを実行していますが、
		ocpuが見つかりません。なので、何が動いているか不明。

	=単一のサービス実行

	listenはまとめてサービスを管理しますが、
	一つだけ動かしたい場合のためにaux/listen1というものが使えます。

.aside
{
	=参考ページ
	*[listen(8)]
	*[サバカン 技術情報|http://www.sabakan.info/techinfo/echoping1.html]
	*[TCP/113 AUTH/IDENT に関して|
		http://unixluser.org/techmemo/ident/]
	*[ファイルサーバの管理|fs.w]
}

@include nav.i
