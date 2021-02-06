@include u.i
%title ルフィアノート再構築と/env

.revision
2009年11月17日作成
=ルフィアノート再構築と/env

	久しぶりに、[ルフィアノート|/estpolis/]を更新しました。
	今までの作りでは、明らかな問題が2つと気になる点が1つ、
	あとやってみたいことが2つあったので、
	エストポリス新作発表によるモチベーション向上にあわせてリニューアル。

	=問題点
		=JavaScript+XSLT
		今まではJavaScript+XSLTで作っていたのですが、
		それだとOperaやSafariでは動きませんでした。
		どうやらSafariは、JavaScriptからXSLTパーサを呼び出すことが
		できないようなのですね。Operaはなんだったかな、忘れました。

		そんなわけで、これに依存しきっていたので、
		機能的な意味で使えないページになってしまっていました。
		また、[AJAXSLTも使ってみました|0706.w]が、
		あれは使いこなせそうにありません。

		=文字コード未指定
		XML宣言で文字コード指定していたので、
		metaタグはいらないだろうと思って書いていませんでしたが、
		たまに、IE6に限らずIE7でさえ真っ白になってしまうことがありました。
		文字コードを正しく選べば表示されますが、
		化けるのではなく真っ白なので、ふつう気づきません。

	=気になる点
		=関連ファイル管理が複雑
		これは内部的な問題ですが、元データファイル、
		データからXMLへの変換プログラム各種、ヘッダとフッタの共通部分、
		ふつうのHTMLファイル、ごちゃごちゃしたmkfile、
		それに加えてCSS、JavaScript、XSLT等、
		手間を減らすために作った環境が、かえってめんどくさくて
		更新する意欲を減らしていたように思います。
		新しいページを追加するには楽でいいのですが、
		全体的に手を入れようとすると気持ちが萎える状態。
		そこで、複雑なシステムは使われないの格言に従って、
		もっとシンプルな方法にしようと思いました。

		これは、シンプルすぎると管理が大変になるので、
		どこを自動化するか難しいところです。
		ほんとうはデータベース使うといいのでしょうけど、
		そうすると、マップに附属するメモのような、
		データ以外の文章をどのように扱うか悩みます。

	=やってみたいこと
		=HTML5
		記述がシンプルになるので、HTML5は気に入っています。
		XHTML2を待っていた方々からすれば不評かもしれませんが、
		\[HTMLは表示のための言語|
		http://mojix.org/2008/09/05/html_is_not_content]
		だと割り切れば、そんなに悪いものでもないのではないかなあ。

		=個々のアイテムごとにURL割り当て
		今まではJavaScript+XSLTで処理していたので気にしませんでしたが、
		それが使えなくなってしまったので、個々のアイテムごとに
		URLを持たせたいなあ、と。

		!http://lufia.org/estpolis/item.html

		このようにまとめるのではなく、以下のように。

		!http://lufia.org/estpolis/item/index.html
		!http://lufia.org/estpolis/item/potion.html

	=作ってみた結果

	共通部分の取り込みだけ自動化して、
	あとはベタに書くようにしてみました。
	データに修正が入ったとき、ちょっと大変かなあと思いますが、
	ほとんど作っていたので、修正はあまりないだろうからいいかな。

	唯一困ったことといえば、Plan 9の環境変数は文字数制限があるようで、
	大量のファイルをmkで扱おうとするとエラーになってしまいました。

	.note
	ちょうど[9fansでも話題にあがりました|
	http://groups.google.com/group/comp.os.plan9/browse_thread/thread/cdf5eb70b20c9354/693130a1eabf43e9]ね。

	.makefile
	!PAGE=`{ls */*.w}
	!TARG=${PAGE:%.w=%.html}
	!
	!all:V: $TARG
	!
	!...

	このルールでmkすると。

	.console
	!% mk
	!/env/TARG: read or write too large
	!/env/TARG: read or write too large
	!/env/TARG: read or write too large
	!...

	しかたがないので分割することに。
	PAGEには全部のファイル名が含まれますが、
	TARGは.wで終わるものを.htmlに変換したファイル名のみになっています。

	.makefile
	!PAGE=`{lspart $LSFLAGS $DB}
	!TARG=${PAGE:%.w=%.html}
	!
	!world:V:
	!	mk $MKFLAGS all 'DB=tale'
	!	for(p in `{seq 0 2})
	!		mk $MKFLAGS all 'DB=stuff' 'LSFLAGS=-D3 -P'$p
	!
	!all:V: $TARG
	!
	!...

	mkfileで使っているlspartは以下のように。

	.sh
	!#!/bin/rc
	!# support tool for mk
	!
	!rfork e
	!
	!lsflag='d,l,m,n,p,q,r,s,t,u,F,Q,T'
	!flagfmt=$lsflag',D div,P part'
	!args='[file ...]'
	!if(! ifs=() eval `{aux/getflags $*}){
	!	aux/usage
	!	exit usage
	!}
	!
	!ifs=, {x=`{echo $lsflag}}
	!for(f in $x){
	!	key=flag$f
	!	a=$$key
	!	if(! ~ $#a 0)
	!		opt=($opt $f)
	!}
	!if(! ~ $#opt 0)
	!	opt=-$"opt
	!if(~ $#flagD 0)
	!	flagD=1
	!if(~ $#flagP 0)
	!	flagP=0
	!
	!n=`{ls $opt $* | wc -l}
	!d=`{	echo '
	!	n = '$n/$flagD'
	!	m = int(n)
	!	if((n-m) > 0.0) print m+1 else print n
	!	' | hoc
	!}
	!n=`{echo $flagP '*' $d + 1 | hoc}
	!t=`{echo $n + $d - 1 | hoc}
	!ls $opt $* | sed -n $n,$t^p

@include nav.i
