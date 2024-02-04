---
title: Alefコンパイラのソースを読む(1)
pre: ../include/u.i
post: ../include/nav.i
---

.revision
2009年1月11日作成
=Alefコンパイラのソースを読む(1)

Google sitesを使って、[Alefコンパイラのソースを読み始めました|
http://sites.google.com/site/alefcompiler/]。
以前は[ひらメソッド|http://tiki.is.os-omicron.org/tiki.cgi?c=v&p=%A4%D2%A4%E9%A5%E1%A5%BD%A5%C3%A5%C9]を
実践しようとしていたのですが、飽きます。飽きました。途中で。
Wikiを使っていればまた違った感想になるのかもしれませんが、
コツコツがんばるのは向いていませんでした。

なので、今回は面白そうな関数だけトップダウンで読む。
ざっと眺めてめんどくさそうなら飛ばす、という方針で進めようと思っています。
全部を読まなくても、そのうちデータ構造が理解できるでしょう。きっと。

Google sitesを使っていて感じるのは、
どこまで読んだのか記録に残るのがいいですね。
逆に悪いところは、ソースを読み書きするためのものではないので、
メモを残しづらいです。
あと、関数・グローバル変数・型・ディレクトリ用の
ページテンプレートが欲しくなります。
GNU GLOBALは、手間はなさそうですが
どこまで読んだかが分からなくなりそうなので使いません。

今日は[compile関数|
http://sites.google.com/site/alefcompiler/alef/port/mainc/compile]の、
/bin/cppを実行するところまで読みました。次はlinehistかな。
コンパイラを読むなんて初めてなので、かなり遠回りすると思われますが、
ゆるく更新していきますので上記サイトのほうもよろしくお願いします。

.aside
{
	=自分用メモ
	*[ソースコードを読むための技術|
	http://i.loveruby.net/ja/misc/readingcode.html]
}
