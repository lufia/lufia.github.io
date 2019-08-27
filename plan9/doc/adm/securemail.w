@include u.i
%title メール環境の暗号化

=メール環境の暗号化
.revision
2009年10月20日更新

	=サーバ証明書の作成

	秘密鍵をsecstoreに、公開鍵を/sys/lib/tls/cert.pemに作成します。
	auth/rsa2x509の引数は自分の環境にあわせて書き換えます。

	!# ramfs
	!# cd /tmp
	!# auth/rsagen -t 'service=tls owner=*' >key
	!# auth/rsa2x509 'C=JP ST=Kanagawa L=Sagamihara O=lufia.org OU=9 CN=lufia' key | auth/pemencode CERTIFICATE >cert

	証明書を自動的にfactotumへ取り込めるように、bootesのsecstoreを作成。
	secstoreへの登録方法は[secstoreの使い方|../guide/secstore.w]を。
	bootesのsecstoreへ1つ以上キーが登録されているなら、
	それと今回作成したキーを結合しないといけませんが、省略しています。

	!# auth/secuser -v bootes
	!(password)
	!(confirm)
	!# cat key >>factotum
	!# auth/secstore -p factotum
	!# rm key factotum

	bootesは自分でロードしない限りsecstoreを読みにいかないので、
	明示的にsecstoreを読み込むようcpurcを編集。
	具体的には、auth/secstoredの下にauth/secstoreを追加。

	!# cat /cfg/$sysname/cpurc
	!...
	!auth/secstored
	!auth/secstore -n -G factotum | read -m >/mnt/factotum/ctl
	!...

	また、[初回起動時|authinst.w]にsecstoreのパスワードを
	設定していない場合は、auth/wrkeyを使って再設定してください。

	=証明書の配置

	IMAP4, SMTPで使うため、適当な場所に証明書を移動します。
	cert.pemの権限は444のほうが安全ですが、管理的にめんどくさいので664。

	ユーザ、グループをsysにするために、あらかじめファイルサーバから
	cert.pemを作っておきます。

	!fs: create /sys/lib/tls/cert.pem sys sys 664
	!fs: newuser sys +bootes

	!# cat cert >/sys/lib/tls/cert.pem
	!# rm cert
	!# unmount /tmp

	!fs: newuser sys -bootes

	=IMAP4 over SSL/TLS
	上記で作成した証明書を使って、IMAP4の通信を暗号化します。
	IMAPSのポートはtcpの993です。
	以下ではserviceを/cfgへ移行した状態で書いています。
	詳細は[認証サーバの構築|authinst.w]のサービスの隔離を参照。

	!fs: create /cfg/$sysname/service/tcp993 sys sys 775
	!fs: newuser sys +bootes

	.note
	fsカーネルでは$sysnameをそのまま使うことはできないので、
	実際のホスト名に置き換えてください。

	!# cd /cfg/$sysname/service
	!# cat >>tcp993
	!#!/bin/rc
	!
	!exec tlssrv -c/sys/lib/tls/cert.pem -limap4d -r`{cat $3/remote} /bin/ip/imap4d -r`{cat $3/remote}>[2]/sys/log/imap4d
	!^D

	それから、無くても動いてるようにみえるけど、これも。
	なんだろうこれ。ルータが動いているなら、ポートの開放も忘れずに。
	プロンプトが%の行は、一般ユーザで実行しても問題ありません。

	!% upas/fs -f /imaps/wisp		# imapsを設定するサーバへ接続
	!upas/fs: opening /imaps/wisp: wisp/imaps:server certificate xxxxxxxxxxxxxxxxxxxxxxxxxxxxx not

	xxxxxxxxxが取得できたら、それをそのまま次に使います。

	!# echo 'x509 sha1=xxxxxxxxxxxxxxxxxxxxxxxxxxxxx' >/sys/lib/tls/mail

	!fs: newuser sys -bootes

	動作確認が終われば、いらなくなったIMAP4サービスを削除します。
	そのまま残していても困らないだろうとは思いますが、
	有名なメールクライアントはIMAP4Sに対応しているので、
	わざわざ残しておくことはないだろうという気がします。

	!fs: remove /cfg/wisp/service/tcp143

	=SMTP over SSL/TLS
	SMTPの場合、暗号化の方法は2種類あります。

	:ssmtp
	-TCPポート465
	-通信開始から暗号化されている
	:smtp+STARTTLS
	-TCPポート25
	-STARTTLSコマンドによって暗号通信が開始される

	設定は、ssmtpはtlssrvによりupas/smtpdプロセスを開始します。
	STARTTLS版は、upas/smtpdコマンドに-cオプションを使って証明書を与えます。
	後者は暗号化通信が可能というだけで、
	クライアントからSTARTTLSコマンドが発行されない限り暗号化されません。

	今回はtcp587に-cオプションから証明書を与えました。

	!# cat /cfg/wisp/service/tcp587
	!#!/bin/rc
	!#smtp serv net incalldir user
	!
	!user=`{cat /dev/user}
	!exec upas/smtpd -ac/sys/lib/tls/cert.pem -g -n $3

	これにより、暗号化通信が開始されると
	/sys/log/smtpdにログが記録されるようになります。

	!started TLS with [...]

	ついでなので、tcp25にも-c certを追加して終了。
	あまり意味は無いかもしれません。
	しかしfactotum+secstoreってすごいなあ。
	秘密鍵がファイルシステムから隠れてしまった。

	=トラブルシューティング

		=tls reports failed
		bootesの鍵が読み込めていない場合、/sys/log/imap4dに
		ログが記録されます。

		!tls reports failed: tls: local factotum_rsa_open: no key matches proto=rsa service=tls role=client

		auth/secstore -G factotumをcpurcに加えてください。

.aside
{
	=関連情報
	*[メールサーバの設定|smtpd.w]
	*[iPhoneまとめ|iphone.w]

	=参考ページ
	*[Mail configuration|http://www.plan9.bell-labs.com/wiki/plan9/Mail_configuration/index.html]
	*[証明書|http://plan9.aichi-u.ac.jp/pegasus/man-2.1/cert.html]

	=参考書
	:[新版暗号技術入門--秘密の国のアリス|http://www.hyuki.com/cr/]
	-暗号全般についての入門書です。[旧版|
	http://www.hyuki.com/cr/cr1st.html]を読みました。
}

@include nav.i
