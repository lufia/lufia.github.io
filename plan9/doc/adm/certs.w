@include u.i
%title 正当な証明書を扱う

.revision
2014年5月2日更新
=正当な証明書を扱う

	=前置き

	正当と書いていいのか悩ましいですが、
	いわゆる自己署名でない証明書のことです。
	認証局に署名リクエストを出すとき、CSRが必要になりますが、
	Plan 9には、CSRを作るためのコマンドが無さそうです。
	\`auth/rsa2x509`では自己署名になってしまうので使えません。
	Plan 9の秘密鍵をUnixで理解できる形に変換して、
	Unix(openssl)でCSRを作る方法も調べましたが、
	全く情報がありませんでした。

	最終的に、Unixで作った鍵をPlan 9で読み込む方法を採用しました。

	=鍵の作成

	Unixで作業をします。
	パスフレーズ付きの鍵では、どうやらPlan 9は読めない様子。
	なので、安易だけれどパスフレーズを解除した状態で渡します。

	.console
	!unix$ openssl genrsa -aes128 2048 >private.key
	!unix$ openssl genrsa -aes256 4096 >private.key
	!Enter pass phrase:
	!Verifying - Enter pass phrase:
	!unix$ openssl rsa -in private.key -out u.key

	安全な方法で鍵をPlan 9側へコピーします。
	ここでは`drawterm`を使いましたが実際なんでもいいです。

	.console
	!unix$ drawterm -a a.lufia.org -c c.lufia.org -u bootes
	!# ramfs -p
	!# cp /mnt/term/Users/lufia/u.key /tmp/u.key

	\`drawterm`を使って*bootes*ユーザで`auth/secstore`すると、
	\`drawterm`側ではなくcpuサーバのコンソール側(!)で
	パスワードを待ち受けるようになって困るので、
	以下はコンソールから作業します。

	.console
	!# cd /tmp
	!# auth/pemdecode ‘RSA PRIVATE KEY’ u.key |
	!> auth/asn12rsa -t ‘service=tls role=client owner=*’ >key
	!# auth/secstore -g factotum
	!# cat key >>factotum
	!# auth/secstore -p factotum
	!# rm factotum key u.key

	マニュアルによると、`asn12rsa`した後の出力にある*!p=*と*!q=*の値が
	素数ペアになっているようですね。

	これで、Unixのパスフレーズ無し鍵はいらなくなったので消しましょう。

	.console
	!unix$ rm u.key

	パスフレーズ有り版の鍵は証明書作成(更新も？)で使うので、
	大切に保管しておきましょう。

	=CSR作成と申請

	Plan 9上に秘密鍵と公開鍵が残せたので、あとはUnixでCSRを作成します。

	.console
	!unix$ openssl req -new -key private.key >a.csr
	!Enter pass phrase for key:

	この後、いくつか質問されますが、大切なところは、
	Common Nameを証明書申請するドメイン名にすること。
	他の項目は認証局のサイトにある説明をよく読んで入力しましょう。
	RapidSSLでは、拡張情報・チャレンジパスワードを入力してはいけません。

	CSRを作り終わったら認証局へ申請します。
	RapidSSLの場合は、フォームに*a.csr*の内容をコピペして、
	サーバの種類を選ぶ場所で「その他」を選んでおくといいでしょう。

	その後「SSLサーバ証明書発行完了のお知らせ」というメールが届いたら、
	メール本文の中ほどにある「SSLサーバ証明書(X.509形式)」の
	\*BEGIN CERTIFICATE*から*END CERTIFICATE*まで(含む)をPlan 9へ送ります。
	秘密鍵と異なり、公開情報なので送る方法はなんでもかまいません。
	ファイル末尾に改行がない場合、Plan 9は読んでくれないので
	改行までをコピーするように注意してください。

	最後に、所定の場所へ配置して終わり。

	.console
	!# con -l /srv/fscons
	!prompt: fsys main create /active/sys/lib/tls/cert.pem sys sys 664
	!# cp cert /sys/lib/tls/cert.pem

.aside
{
	=参考ページ
	*[RSA 秘密鍵/公開鍵ファイルのフォーマット|http://bearmini.hatenablog.com/entry/2014/02/05/143510]
	*[legoを使った証明書更新|lego.w]
}

@include nav.i
