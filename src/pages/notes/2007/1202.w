---
title: AtomとXSLTと名前空間
style: ../../../styles/global.css
pre: ../../../layouts/notes/u.i
post: ../../../layouts/notes/nav.i
---

.revision
2007年12月2日作成
=AtomとXSLTと名前空間

AtomをXSLTでHTMLに変換しようとして詰まった。
以下のように書くとだめ。ルートノードにしかマッチしない。

.xml
!<xsl:stylesheet version="1.0"
!	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
!	xmlns="http://www.w3.org/1999/xhtml">
!<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no"
!	doctype-public="-//W3C//DTD XHTML 1.1//EN"
!	doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"
!	indent="yes"/>
!<xsl:template match="/">
!	<xsl:apply-templates/>
!</xsl:template>
!
!<xsl:template match="feed">
!	<div class="notes">
!	<xsl:apply-templates select="entry"/>
!	</div>
!</xsl:template>
!...

こっちが正解。

.xml
!<xsl:stylesheet version="1.0"
!	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
!	xmlns:atom="http://www.w3.org/2005/Atom"
!	xmlns="http://www.w3.org/1999/xhtml">
!<xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="no"
!	doctype-public="-//W3C//DTD XHTML 1.1//EN"
!	doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"
!	indent="yes"/>
!<xsl:template match="/">
!	<xsl:apply-templates/>
!</xsl:template>
!
!<xsl:template match="atom:feed">
!	<div class="notes">
!	<xsl:apply-templates select="atom:entry"/>
!	</div>
!</xsl:template>
!...

よくよく考えれば当然なんだけどね。
