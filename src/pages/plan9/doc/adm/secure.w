---
title: TLS1.2に対応させる
pre: ../../include/u.i
post: ../../include/nav.i
---

.revision
2015年11月8日更新
=TLS1.2に対応させる

	現在はECDHE対応していないため無理ですが、TLS 1.2対応なら可能です。

	=前提

	*TLS 1.2以上に対応すること
	*特定の暗号方式に対応すること
	*サーバ証明書がSHA256以上の署名を持っていること
	*サーバ証明書が2048bit以上のRSA鍵または256bit以上のECC鍵を持っていること

	=TLS 1.2と許可された暗号方式に対応

		=ソースコード更新

		9legacyのパッチを当てる。

		*libsec-tlshand-nossl3
		*libsec-x509-sha256rsa
		*tls-devtls12

		TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256に対応する形となる。

		=ビルド

		*カーネル(devtls)
		*libsec
		*libsecを使ったコマンド類

		カーネルは対応が終われば、hashalgsにsha256が追加される。
		encalgsはデフォルトのまま。

		.console
		!# cat '#a'/tls/hashalgs
		!clear md5 sha1 sha256
		!# cat '#a'/tls/encalgs
		!clear rc4_128 3des_ede_cbc aes_128_cbc aes_256_cbc

		.note
		\*libsec.h*をincludeしているコマンド、
		cpu, hget, import, tlsclient等いっぱいあるなあ...
		とりあえずはhget, httpd, smtpd, tlssrv, tlsclientが対応していればいいか。

		.console
		!# cd /sys/src/libsec
		!# mk (/$objtype/lib/libsec.aが更新される)
    
		.console
		!# cd /sys/src/cmd
		!# mk hget.install
    
		.console
		!# cd /sys/src/cmd/ip/httpd
		!# mk install

	=証明書の更新

	SHA256以上の署名を持った2048bitのRSA鍵持ち証明書を作る。

	=動作確認

	*[SSL Server Test|https://www.ssllabs.com/ssltest/]

.aside
{
	=参考ページ
	*[Apple iOS9 (ATS)への対応|http://www.slideshare.net/tech_jstream/iosats]
}
