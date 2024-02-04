@include u.i
%title XPathすごいね

.revision
2008年2月14日作成
=XPathすごいね

	データを扱うものなのに検索ができないのはおかしいと思って
	調べてみると、XSLTそのものではなく、
	そこから派生したXPathを使うようです。

	=XPathなしで最新10件抽出
	これは[AtomとXSLTと名前空間(2)|0203.w]
	と同じですね。1点バグがあったので修正したものを再掲。

	.xml
	!<xsl:template match="atom:feed">
	!	<div id="main">
	!	<xsl:apply-templates select="atom:entry/atom:content"/>
	!	</div>
	!</xsl:template>
	!
	!<xsl:template match="atom:content">
	!	<xsl:variable name="n">
	!		<xsl:number level="any"/>
	!	</xsl:variable>
	!
	!	<xsl:if test="$n &lt;= 10">
	!		<xsl:copy-of select="xhtml:html/xhtml:body"/>
	!	</xsl:if>
	!</xsl:template>

	=XPathを使って、最新10件抽出
	XPathは、"atom:entry[[ ... ]]"のところですね。

	.xml
	!<xsl:template match="atom:feed">
	!	<div id="main">
	!	<xsl:apply-templates
	!	select="atom:entry[position() &lt;= 10]/atom:entry"/>
	!	</div>
	!</xsl:template>
	!
	!<xsl:template match="atom:content">
	!	<xsl:copy-of select="xhtml:html/xhtml:body"/>
	!</xsl:template>

	必要ない変数($n)を書かなくてよくなっていたり、やってることが
	(XPathを使わない版に比べて)直接的に書けたりなどなど、
	すごく便利です。entry[[:10]]くらいまで省略して書けたらいいなあ。。

	=参考リンクと面白そうなものメモ
	*[XMLパス言語|
	http://www.doraneko.org/xml/xpath10/19991116/Overview.html]
	*[JavaScript-XPath|
	http://d.hatena.ne.jp/amachang/20071112/1194856493]

@include nav.i
