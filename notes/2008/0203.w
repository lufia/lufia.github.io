@include u.i
%title AtomとXSLTと名前空間(2)

=AtomとXSLTと名前空間(2)
.revision
2008年1月15日作成

	=環境を選びますが
	\[orange/note|/notes/]では、JavaScript+XSLTを使い、
	\[atom.xml|/notes/atom.xml]から[index.html|/notes/index.html]を
	自動生成しています。
	これを作るときにめいっぱい悩んだのでメモ。

	.note
	以前の話。	Safariでは動かないので、いまは使っていません。

	=atom:contentに含まれるHTMLノードを取り出す
	まだよく理解できていないのですが、
	xmlnsでxhtmlを指定しないといけないみたいです。
	fami-note:[atom:contentをXSLTを使って表示する時|
	http://d.hatena.ne.jp/faminote/20070206/1170714329]

	!<xsl:stylesheet version="1.0"
	!	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	!	xmlns:atom="http://www.w3.org/2005/Atom"
	!	xmlns:xhtml="http://www.w3.org/1999/xhtml"
	!	xmlns="http://www.w3.org/1999/xhtml">
	!<xsl:output method="xml" encoding="UTF-8"
	!	omit-xml-declaration="no"
	!
	!...
	!
	!<xsl:template match="atom:content">
	!	<xsl:copy-of select="xhtml:html/xhtml:body"/>
	!</xsl:template>

	省略した場合はうまく動かないです。なぜ?
	名前空間は同じに見えるんですが。。

	!<!-- うまく動かないバージョン -->
	!<xsl:stylesheet version="1.0"
	!	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	!	xmlns:atom="http://www.w3.org/2005/Atom"
	!	xmlns="http://www.w3.org/1999/xhtml">
	!<xsl:output method="xml" encoding="UTF-8"
	!	omit-xml-declaration="no"
	!
	!...
	!
	!<xsl:template match="atom:content">
	!	<xsl:copy-of select="html/body"/>
	!</xsl:template>

	=最新10件だけ展開する
	これもいまいち理解できてない気がします。特にxsl:number。
	level = single || multiple || anyの違いとか。

	xsl:value-ofではタグが無視されてしまうので、xsl:copy-ofを使う。
	ソートする必要があるなら、xsl:sortが使えるみたい。

	!<xsl:template match="atom:content">
	!	<xsl:variable name="n">
	!		<xsl:number level="any"/>
	!	</xsl:variable>
	!
	!	<xsl:if test="$n &lt; 10">
	!		<xsl:copy-of select="xhtml:html/xhtml:body"/>
	!	</xsl:if>
	!</xsl:template>

	=CSSでマルチカラム
	参考URLだけ。
	IE5, IE6は早く滅びてしまうといいです。

	*[CSSレイアウトの定石 WinIE6バグ回避法|http://mb.blog7.fc2.com/blog-entry-83.html]
	*[CSSによる段組(マルチカラム)レイアウト講座|http://www.geocities.jp/multi_column/]

@include nav.i
