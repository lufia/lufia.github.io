---
title: AJAXSLTを使ってみた
style: ../../../styles/global.css
pre: ../../../layouts/notes/u.i
post: ../../../layouts/notes/nav.i
---

.revision
2009年7月6日作成
=AJAXSLTを使ってみた

	\[AJAXSLT|http://goog-ajaxslt.sourceforge.net/]は、
	全部JavaScriptで書かれたXSLTライブラリです。
	JavaScriptからXSLTプロセッサを呼べないSafariやOperaにも
	対応しているとあったので、使ってみたのですが。。。

	XMLの名前空間をよく理解していないのもあるので、
	そう感じただけなのかもしれませんが、
	AJAXSLTの動作に理不尽なものを感じたのでもう使わないです。
	たぶん、根本的な原因はIEにあるのでしょうけど。

	以下やってみたこと。淡々といきます。

	=文字列からxmlParseを使ってデータを作る場合
	データはAtomを使うことにするので、
	名前空間とルートノードは次のようになる。

	.js
	!atom = '<feed xmlns="http://www.w3.org/2005/Atom">' +
	!	'</feed>'

	次に、XSLTの中で、Atom名前空間をatomとする。

	.js
	!xslt = '<xsl:stylesheet version="1.0"' +
	!	'	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"'
	!	'	xmlns:atom="http://www.w3.org/2005/Atom"'

	この条件で、Atomのfeed要素にマッチさせるには、
	IEやFirefoxのXSLTプロセッサでは以下のように書く。

	.xml
	!<xsl:template match="atom:feed">

	ここの名前空間は省略できない。XSLTで使うXPathは、
	名前空間を省略した場合にはデフォルトではなく、
	名前空間無しとして扱われるため。

	AJAXSLTでは、上記の書き方ではマッチしない。
	次の書き方になる。

	.xml
	!<xsl:template match="feed">

	=外部ファイルから読み込む場合
	上記のデータをそのまま使い、atom.xmlを作成する。
	サーバから返すcontent-typeはapplication/xml。

	.xml
	!<feed xmlns="http://www.w3.org/2005/Atom">
	!</feed>

	次にindex.xslt。これもapplication/xml。
	もちろんmatchで使うXPathには、名前空間を書いてはいけない。

	.xml
	!<xsl:stylesheet version="1.0"
	!	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	!	xmlns:atom="http://www.w3.org/2005/Atom"

	これらのデータを、jQuery.getを使って読み込み、
	xsltProcessに渡すと、Safari4では期待通り動作するが、
	IE8ではxsltProcessの結果が空文字列となり、うまくいかない。
	jQuery.getの第4引数を使うと、読み込むフォーマットを
	文字列やXML、JSON等から選べるので、
	取得形式を文字列(text)に変更。
	その文字列からxmlParse、xsltProcessを使っても結果は変わらず。
	特にエラーが出ているわけでもないので原因不明。

.aside
{
	=参考ページ
	*[Hints for XSLT Troubles|http://www.asahi-net.or.jp/~ps8a-okzk/xml/memo/hint_xslt.html]
}
