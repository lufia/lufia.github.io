---
title: iPhoneまとめ
pre: ../../include/u.i
post: ../../include/nav.i
---

.revision
2008年12月26日更新
=iPhoneまとめ

	iPhone用に設定したものまとめ。

	=SMTP

	なにはともあれSMTPサービスです。
	Softbankは、OP25Bを設定しているようで、
	外部のtcp!**!25に接続できません。
	そのため、tcp!**!587にSMTP Authentication対応の
	サービスも立ち上げないといけないです。

	.note
	iPhone OS 2.1の頃はtcp!**!587を開いていない場合、
	設定終了後の接続確認でエラーとなり、設定が保存できませんでした。

	*[メールサーバの設定|smtpd.w]

	また、グレーリスト法を使っている場合は、
	3Gネットワーク利用時のIPが固定ではないので以下も必要です。
	IPは[iPhoneのIPとUAを調べる|
	http://kwappa.txt-nifty.com/blog/2008/07/iphoneipua_c1bd.html]
	から。

	.console
	!% echo '126.240.0.0/12 *.panda-world.ne.jp' >>/mail/grey/whitelist

	=IMAP4

	iPhoneは、POP3とIMAP4に対応しています。
	モバイル環境ではIMAP4のほうが便利なので、そちらを構築します。

	*[IMAP4サービス|imap4d.w]

	特に最新のファームウェア2.1からは、
	絵文字が入っているメールを受け取ると本文全部が文字化けするようなので、
	Plan 9からも読めるようにしておかないと、大変困ったことになります。
	詳細は、[ファームウェア 2.1|http://iphone.wikiwiki.jp/?%A5%D5%A5%A1%A1%BC%A5%E0%A5%A6%A5%A7%A5%A2%28OS%29#l1f512bd]。

	=メール環境の暗号化

	無くても困りませんが、暗号化したほうがよりよいので対応。

	*[メール環境の暗号化|securemail.w]

.aside
{
	=参考ページ
}
