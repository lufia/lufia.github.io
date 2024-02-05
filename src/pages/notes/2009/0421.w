---
title: Alefコンパイラの中で出てくる型
style: ../../../styles/global.css
pre: ../include/u.i
post: ../include/nav.i
---

.revision
2009年4月21日作成
=Alefコンパイラの中で出てくる型

	いろんなところに出てくる以下の型についてのメモ。

	*[Node|http://sites.google.com/site/alefcompiler/alef/port/parlh/node]
	*[Type|http://sites.google.com/site/alefcompiler/alef/port/parlh/type]
	*[Sym|http://sites.google.com/site/alefcompiler/alef/port/parlh/sym]

	=定数の名前規則
	:[TXXX系|http://sites.google.com/site/alefcompiler/alef/port/parlh/txxx]
	-TINT, TADTなど、Tで開始するすべて大文字の定数は型(Type)が扱います。
	:[OXXX系|http://sites.google.com/site/alefcompiler/alef/port/parlh/oadd]
	-OADD, OINDなど、Oで開始するすべて大文字の定数はノード(Node)が扱います。
	:[Txxx系|http://sites.google.com/site/alefcompiler/alef/port/parl-y]
	-Tint, Tstorageなど、Tで開始し残りは小文字の定数は、文法的な意味型です。
	-これをもとにyaccが解析します。

	=Node
	Nodeは構文木です。
	Alef言語のプログラムを、主にtype, left, rightというメンバー変数で扱います。
	たとえば、1+1という式の場合、およそ下記のイメージ。

	.c
	!Node = {
	!	.type = OADD
	!	.left = {
	!		.type = OCONST
	!		.ival = 1
	!	}
	!	.right = {
	!		.type = OCONST
	!		.ival = 1
	!	}

	式だけではなく、ifやforなどの文、adtの宣言などもすべてNodeで表します。

	=Type
	Typeはプログラムに現れる型。
	基本型の場合は単体で完結した型となります(nextがnil)。
	派生型の場合は、まずポインタ(type=TIND)、配列(type=TARRAY)などで表現し、
	nextにおいてその具体的な型を指します。adtなども同様。

	int**の場合。

	.c
	!Type = {
	!	.type = TIND
	!	.next = {
	!		.type = TINT
	!		.next = nil
	!	}
	!}

	=Sym
	プログラムで現れるすべてのシンボルです。
	たとえば、変数名、関数名、型名、ifやforなどの予約語。gotoラベルなど。
	それぞれの違いは、lexvalメンバー変数で区別します。
	変数の場合はTid, 型名はTtypename, ほか予約語ならTintやTif。

	すべてシンボルテーブルに格納され、同じ名前は1つしか存在しません。
	ブロック内変数の扱いは次回。
	Sym.instanceと[Tinfo|
	http://sites.google.com/site/alefcompiler/alef/port/parlh/tinfo]を
	うまく扱うことで実現しています。

	.c
	!{
	!	int i, j;
	!
	!	{
	!		int i;		/* ここでiはブロック外のiとは別の変数 */
	!	}
	!}
