---
title: legoを使った証明書更新
style: ../../../../styles/global.css
pre: ../../include/u.i
post: ../../include/nav.i
---

.revision
2019年6月24日更新
=legoを使った証明書更新

	[lego|https://go-acme.github.io/lego/]はGoで書かれたLet's encryptクライアントです。
	バイナリさえ用意すればPlan 9で動作します。

	=legoコマンドをインストール

	前提として*/sys/lib/tls/ca.pem*が必要です。
	準備できていない場合は、9legacyなどからインストールしましょう。

	次に、legoコマンドをインストールします。
	Plan 9にGo開発環境を構築済みの場合は、次のコマンドで行えます。

	.console
	!$ go get github.com/xenolf/lego/cmd/lego

	または、GOOSをplan9にセットするとPlan 9で動作するコマンドがビルドできます。

	.console
	!$ git clone https://github.com/xenolf/lego
	!$ cd lego/cmd/lego
	!$ GOOS=plan9 GOARCH=386 go build

	=新規発行の場合

	初めてLet's encryptで証明書を発行する場合は、lego runコマンドを使います。

	.console
	!% lego -a -m info@example.com -d example.com -k rsa2048 run

	Plan 9で使う証明書を発行するために必須のオプションは上記の通りです。
	legoには他にもオプションがあり、--path <<dir>>とすると証明書や鍵ファイルを
	<<dir>>以下で管理します。また、ip/httpd/httpdが既に動作している場合、
	\--webroot /usr/webのようにするとhttpdを経由してドメインの確認を行います。

	.console
	!% lego -a -m info@example.com -d example.com -k rsa2048 --webroot /usr/web run
	!% rm /usr/web/.well-known/acme-challenge
	!% rm /usr/web/.well-known

	=更新の場合

	新規発行の時に使ったコマンドから、runをrenewに変更するだけです。
	\--pathオプションを使って管理ディレクトリを変更していた場合は、
	同じディレクトリを与えてあげる必要があります。

	=httpdに反映

	Let's encryptで発行した証明書とペアの鍵ファイルを、
	factotumで扱えるように変換します。

	.console
	!% cd .lego/certificates
	!% auth/pemdecode 'RSA PRIVATE KEY' example.com.key |
	!> auth/asn12rsa -t 'service=tls role=client owner=*' >key

	終わったら、bootesのfactotumに設定しましょう。

	.console
	!% auth/secstore -g factotum
	!% cp key factotum (古い秘密鍵を新しい鍵で置き換え)
	!% auth/secstore -p factotum
	!% rm factotum

	最後に、対応するサーバ証明書を更新します。

	.console
	!% sed '/^$/,$d' example.com.crt >/sys/lib/tls/cert.pem
	!% sed '1,/^$/d' example.com.crt >/sys/lib/tls/chain.pem
	!% ip/httpd/httpd -c /sys/lib/tls/cert.pem -C /sys/lib/tls/chain.pem

.aside
{
	=参考ページ
	*[正当な証明書を扱う|certs.w]
}
