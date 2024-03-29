---
title: XMLをXSLT変換してHTML化する
style: ../../../styles/global.css
pre: ../../../layouts/notes/u.i
post: ../../../layouts/notes/nav.i
---

.revision
2006年12月11日作成
=XMLをXSLT変換してHTML化する

XSLTを使って、XMLをHTMLに変換しようとしてます。が。

	=IEの制限
	xml-stylesheet typeをtext/xslとしないと動かない

	=Mozilla系の制限
	サーバが返すMIMEをapplication/xmlに類似するものに設定し、
	xsl:outputを正しく設定しないと動かない

なので、サーバのMIMEはapplication/xmlにしておいて、
xml-stylesheet typeをtext/xslにすればとりあえず両方動く。
ここまでは分かったけど、なんでこんなところで苦労しないといけないんだろう。
