---
title: Alef compilerを移動
style: ../../../styles/global.css
pre: ../../../layouts/notes/u.i
post: ../../../layouts/notes/nav.i
---

.revision
2010年5月16日作成
=Alef compilerを移動

Alef compilerを読むサイトを、Google sitesからMobileMeに移動しました。
そのときのメモなどを少し。

まず、Google sitesからファイルをコピーします。
その手順は[Google Sitesのバックアップメモ|
http://blog.bitmeister.jp/?p=1256]を参考に。

コピーが終われば、次に、文字コードの指定を書き加えます。
charsetというファイル名で以下のプログラムを保存。

.sh
!#!/bin/sh
!
!for f
!do
!	sed '1s|<title>|<meta http-equiv="content-type" content="text/html; charset=UTF-8">&|' $f >/tmp/charset.$$ &&
!	mv /tmp/charset.$$ $f
!done

あとは、次のように使います。

.console
!$ cd alefcompiler
!$ du -a | awk '/¥.html$/ { print $2 }' | xargs sh charset

.note
この作業中に、Unixっていちいちめんどくさいなあ、と思いました。
なぜxargsを使わないといけないんだろう。

最後に、alefcompilerをまとめてiDiskへコピー。
iDisk/Web/Sites以下に置けば、http://web.me.com/user/以下から
見れるようになります。

ちなみに、いまは64bit命令生成まわりをやってるので、
このサイトはたぶんもう積極的に更新することはないと思います。

.aside
{
	=参照ページ
	[zsh/filesで引数の最大バイト数を回避する|
	http://d.hatena.ne.jp/lurker/20061128/1164722109]
}
