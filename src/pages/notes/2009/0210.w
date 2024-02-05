---
title: ドメイン移管とSPF
style: ../../../styles/global.css
pre: ../include/u.i
post: ../include/nav.i
---

.revision
2023年8月12日更新
=ドメイン移管とSPF

	=ドメイン移管
	lufia.orgでは、今まで固定IPで[MyDNS|http://www.mydns.jp/]を
	使ってきましたが、
	IPアドレスを通知するシステムに不満が出てきてしまいました。
	MyDNSはHTTP BASIC認証やPOP3認証などでIPアドレスを更新するのですが、
	どちらも生のパスワードをネットワークに送ってしまうのですね。
	そうそう狙われるとは思いませんし思いたくもありませんが、
	「事実上できない」と「できるけどやらない」の差は大きいと思っています。
	可能であれば「事実上できない」がいいなあ、と。

	なので、MyDNSの代わりとなるサービスを探したのですが、
	*SSL/TLS対応
	*独自ドメイン対応
	*手間なし(定期的にログインしないと消えるのは、めんどくさいし忘れそう)
	*MXやTXTレコードなども必要
	という条件にあてはまるものが見当たりません。

	=そろそろ探すのめんどくさい
	どれだけ探しても進展しないときって、めんどくさくなりますよね。
	ということで、[さくらインターネット|
	http://www.sakura.ad.jp/]のDNSを借りることにしました。
	ついでなのでドメインの管理も移してしまいます。
	今預けてるところよりもすこし安いですし。
	今回借りたサービスはこちら。
	一部サービスを借りていれば、無料で10個分ネームサーバを使えるそうです。
	フレッツ接続サービスは、専用線接続サービスと異なります。

	*[ネームサーバ|http://www.sakura.ad.jp/services/other/nameserver/]
	*[ドメイン取得|http://www.sakura.ad.jp/services/other/domain/]

	申請してから実際に移管されるまでに、
	MelbourneIT.com.auからのメールを受け取れなかったりと
	紆余曲折ありました。。
	SPAMメールのせいで、ずいぶん気をつかうものになりましたね。メール。

	=DNSの設定
	実際の設定内容です。このあたりはwhois検索で全部見れますね。

	|*ホスト*	*レコード*		*値*
	|@		NS			ns1.dns.ne.jp.
	|@		NS			ns2.dns.ne.jp.
	|@		A			xx.xx.xx.xx
	|@		MX			0 wisp.lufia.org.
	|@		TXT			"v=spf1 ip4:xx.xx.xx.xx -all"
	|wisp	A			xx.xx.xx.xx

	TXTレコードについてはSPF/Sender IDで。

	=ドメイン設定を変更
	ネームサーバ1を*ns1.dns.ne.jp*に、
	ネームサーバ2を*ns2.dns.ne.jp*に変更します。

	設定後、新しい内容が反映されるまでに最悪1週間ほどかかるらしいです。

	=SPF/Sender ID
	誤解も含めて一言で言えば、迷惑メール対策の1種で、
	なりすましを防止するものです。
	いろいろバリエーションがあるようですが、
	SPF(Sender Policy Framework)だけ知っていればいいかなあ。
	他はなんだかめんどくさそうですし。

	ホスト名をSPFとして使うには、a:host.domain.domとするようです。

	=DKIM/DMARC
	DKIM/DMARCの記事も書きました。

	*[Google WorkspaceのGmailでDMARC|../2021/1208.w]

.aside
{
	=SPFについて
	*[11月1日からドコモで実施されるSender IDとは？ SPFとは？|
	http://aerith.mydns.jp/regrets/2007/10/sender_id-spf.html]
	*[メール送信者認証技術 SPF/Sender ID についてお勉強|
	http://www.drk7.jp/MT/archives/001327.html]

	=SPAMメール対策について
	*[メール交換機でのスパム排除|http://hatuka.nezumi.nu/techdoc/Spam-Filtering-for-MX.ja/html/index.html]
	*[MTA のアクセス制御|http://ya.maya.st/mail/accessctl.html]
}
