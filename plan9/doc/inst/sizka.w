@include u.i
%title Sizka BASICへのインストール

.revision
2006年9月23日更新
=Sizka BASICへのインストール

	若干の非力さは否めませんが、小型で無音の[Sizka BASIC|
	http://www.pinon-pc.co.jp/pc/products/barebone/sizka-basic/index.html]にPlan 9をインストールしてみるページです。

	結論からいえば、rioが立ち上がらないので、
	端末として使うのはお勧めしません。
	認証サーバにしてdrawtermするのがいいです。

	=準備

	まず[BIOS 1.5|
	http://www.pinon-pc.co.jp/download/pc/index.htm]へ
	アップデートしておきます。

	FDDもCDドライブも無いので、2.5 HDD変換アダプタなどを使って
	別のPCからインストールし、それをSizkaへ組み込む作業が必要です。
	以前、USB FDDやUSB CDドライブで試してみたことがありますが、
	うまくロードできませんでした。

	=別PCでインストール

	ふつうに進めていけば完了します。
	fossilとfossil+ventiは、ファイルサーバとして使うなら
	fossil+ventiのほうがいい気がします。

	fossil+ventiの場合、インストール直後に
	以下のようなエラーが発生して、比較的困りやすいのですが。

	!can't read my ip address
	!venti: Err 2 ...

	これは、[ベル研のWiki|https://9p.io/wiki/plan9/Network_configuration/index.html]によると、
	IP割り当て前に*/net/ipifc/0*が127.1として存在するからなので、
	\*termrc*などから、ifの行をコメントアウトすればいいです。
	ip/ipconfigとndb/dnsの2箇所。

	.sh
	!if(!test -e /net/ipifc/0/ctl)		# これを消す
	!	ip/ipconfig

	=HDDをSizkaに移してブート

	通常はglendaでログインするところですが、
	SizkaはVGAが対応していないのか、画面が真っ暗のまま固まります。
	そこで、まずnoneでログインしVGAまわりを無効化、
	その後glendaでログインとなります。

	noneでログインした後は、以下のように*plan9.ini*からVGA周りを無効化。

	.console
	!% 9fat:
	!% ramfs
	!% ed /n/9fat/plan9.ini

	だいたい、次の3行をコメントにしておけば大丈夫です。

	.console
	!#mouseport=ps2
	!#monitor=xga
	!#vgasize=640x480x8

	で、ファイルシステムの停止。

	.console
	!% fshalt

	初回のみ、fshaltの後にしばらくHDDへアクセスがあります。
	それが落ち着いたらリブート。

	これで、glendaでログインしても固まらなくなりますが、
	samもacmeも使えませんので、非常に不便です。。。
	認証サーバ化してdrawtermから扱うことをおすすめします。

	=トラブルシューティング

		=ventiがErr 2 ...というエラーを吐いている

		時間をローカルに合わせると治まるかもしれません。
		\*termrc*または*cpurc*のどこかに記述してみてください。

		.sh
		!aux/timesync -rL

=Sizka BASICの認証サーバ化ヒント

	認証サーバのコンフィグレーションは、
	他のカーネルと比べてドライバ周りがすっきりしているので、
	そのままではSizkaのネットワークカードが認識されません。
	\*/sys/src/9/pc/pcauth*に以下の行を追加します。

	!link
	!	...
	!	ether8139 pci
	!	...

.aside
{
	=関連情報
	*[時計合わせ|../adm/timezone.w]
	*[ネットワークの設定|../adm/ndb.w]
	*[認証サーバのインストール|auth.w]

	=参考ページ
	*[Installation instructions|
	https://9p.io/wiki/plan9/Installation_instructions/index.html]
}

@include nav.i
