---
title: html5 generator
style: ../../../styles/global.css
pre: ../include/u.i
post: ../include/nav.i
---

=wf

	=SYNOPSIS
	!wf [-dp] [-l lang] [-x x1 x2] [file]

	=DESCRIPTION

	wikiのような記述から、HTMLを生成します。
	使用できる文字は以下の通り。

	:= item
	-hN
	:+ item
	-ol
	:** item
	-ul
	:: item
	-dt
	:- item
	-dd
	:>> item
	-blockquote
	:! string
	-pre
	:\ item
	-p
	:|| item item ...
	-table

	上記以外であればpになります。
	また、itemでは、以下の文字が使えます。

	:** item **
	-strong
	:[[ url ]]
	:[[ item || url ]]
	-a
	:<< url >>
	:<< item || url >>
	-img

	これらをただの文字として扱う場合は、****のように2つ続けて書きます。

	urlについては、acmeで使いやすくするために、
	変なプリフィックスルールがあります。
	オプションで

	!wf -x w html

	とすると、urlの末尾が.wであれば.htmlに書き換えて出力します。
	これは複数あってもかまわないので、

	!wf -x w html -x pic png

	のようにできます。

	=テーブル

	テーブルは、タブで区切ったセルをtdとして生成します。
	タブは1つ以上であってもまとめて扱うので、
	表が見やすいように整形してもかまいません。
	また、thを使いたい場合は、セル全体を**(strong)でくくってください。
	例えば以下の場合、1行目はすべてthセルになります。

	!|*name*		*value*
	!|maxht		20
	!|width		70

	=ヘッダ
	ヘッダは、%で開始します。
	これはファイルの先頭にのみ可能です。

	!% name string

	nameは、title, tag, script, style, feed, urlが組み込まれており、
	title, styleなど、必要な要素を生成します。
	上記以外の名前は<<meta name="$name" content="$string">>と
	なります。

	同じ名前が複数回あらわれた場合、
	それらは連結して1つの要素となります。

	このうち、urlは特殊な扱いになっていて、
	これだけではHTMLを生成することはありませんが、
	\[[ url ]]タイプのリンクについて、
	正規表現置換を行いURLを設定します。
	たとえばurlを使い、簡易な表記でPlan 9マニュアルに
	リンクを張る場合は以下のように書きます。

	!%url s|^([a-z0-9]+)\(([1-9])\)$|/magic/man2html/\2/\1|
	!*[man(1)]
	!*[regexp(2)]
	!*[fsconfig(4)|http://www.domain.dom]

	この3つ目のリンクは、正規表現置換を行いません。
	また、xオプションのルールで変換したものに対して適用します。

	urlが複数現れた場合、書かれた順に評価していき、
	マッチするものがあればそこで終了します。

	=ブロック化
	同じ行頭文字が続いた場合は、
	以前の行とまとめて1つのブロック(block)となります。
	途中で区切りたい場合は、空行を置いてください。

	ブロックも、同じレベルに属するブロックをまとめようとします。
	セクションの項も参照。

	また、明示的にブロックを作成する場合は、
	以下の方法があります。

	!{
	!	blocks
	!}

	これは、blocksをdivで囲みます。
	\{}の中ではインデントが1つ増えますが、
	新しいセクションが開始されるわけではありません。
	セクションも含む場合は2つ以上インデントしてください。

	=IDとクラス
	ブロックの前に、置くことができます。
	続くブロックを生成するときに、必要な属性を追加します。

	:. name
	-class
	:# name
	-id

	classは、複数並べることが可能です。

	!.name1
	!.name2
	!aaa
	!bbb

	その場合、class="name1 name2"のようになります。

	=クラスの要素化
	特別なルールとして、class="nav"をもつブロックは、
	親セクションのnav要素として書き出します。
	要素化されたクラス属性は取り除かれます。

	navの他に、header, footer, asideもあります。
	特別なクラスが同時に設定された場合、
	優先順位は高い順にnav, header, footer, asideです。

	=セクション
	インデントすれば、その部分をsectionで囲みます。
	もちろんhNは、sectionに追従して、h1, h2 ...と増加します。

	!block
	!	blocks2

	=EXAMPLE

	!%title Plan 9
	!%url s|^([a-z0-9]+)\(([1-9])\)$|http://plan9.bell-labs.com/magic/man2html/\2/\1|
	!%url s|^(contrib/[^ 	]+)$|http://plan9.bell-labs.com/sources/\1|
	!%title html5 generator
	!
	!=wf
	!
	!	=SYNOPSIS
	!	!wf [-dp] [-l lang] [-x x1 x2] [file]
	!
	!	=DESCRIPTION
	!
	!	wikiのような記述から、HTMLを生成します。
	!	使用できる文字は以下の通り。
	!
	!	:= item
	!	-hN
	!	:+ item
	!	-ol
	!	:** item
	!	-ul

	=BUGS
	クラスやIDは、セクションや=(Hn)には適用できません。
	明示的に{}を書いてください。
