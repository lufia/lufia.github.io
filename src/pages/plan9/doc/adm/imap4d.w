@include u.i
%title IMAP4サービス

.revision
2008年9月21日更新
=IMAP4サービス

	listenのサービスにtcp143を追加します。
	もともと用意されているので、自分で書く必要はありません。

	.console
	!% cat /cfg/$sysname/service/tcp143
	!#!/bin/rc
	!exec /bin/ip/imap4d >[2]/sys/log/imap4d

	ip/imap4dは何もオプションをつけない場合、[CRAM-MD5|
	http://vision.kuee.kyoto-u.ac.jp/~nob/doc/cram-md5/cram-md5.html]で認証を行います。
	iPhoneやMacのMail.appはこれに対応していますが、
	Windowsメール(Liveメール、Outlook含む)は未対応のため、
	Windowsで動作テストをするときにはBecky!などを使います。

	.note
	または、imap4dに-pオプションを与えて
	通常のパスワード認証にすればWindowsメールでもテストできますが、
	これで実運用するには危険なので暗号化が必須です。
	暗号化の方法は詳細は[メール環境の暗号化|securemail.w]に書きました。

	=IMAP4パスワードの設定
	POP3, IMAP4は、通常のPlan 9パスワードとは別のものにできます。
	設定方法は、auth/changeuserからの
	same as the plan 9 passwordという質問にnと答えれば
	続けてパスワードを尋ねられますので、そこで設定します。

	.console
	!# auth/changeuser -p user
	!Password: (変更しなければ空でいい)
	!Confirm password: (変更しなければ空でいい)
	!assign Inferno/POP secret? (y/n) y
	!make it the same as the plan 9 password? (y/n) n
	!Secret(0 to 256 characters): IMAP4パスワード
	!Confirm: IMAP4パスワード
	!略

	また、いま有効になっているIMAP4パスワードを調べるには、
	認証サーバのbootesから、*/mnt/keys/$user/secret*を読めばいいです。

.aside
{
	=関連情報
	*[listenについて|listen.w]
	*[メール環境の暗号化|securemail.w]

	=参考ページ
	*[Plan 9 System Management|http://c.p9c.info/plan9/root.html]
}

@include nav.i
