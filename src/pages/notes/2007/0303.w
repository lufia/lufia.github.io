---
title: lcコマンドが消えた？
style: ../../../styles/global.css
pre: ../../../layouts/notes/u.i
post: ../../../layouts/notes/nav.i
---

.revision
2007年3月3日作成
=lcコマンドが消えた？

ちょうど今、Plan 9にログインして
別サイトの更新しようかなあと思っていたところ。
lc(1)コマンドが消えてました。
ns(1)をみると、*/rc/bin*は*/bin*にバインドされてる。
じゃあ、、と*/rc/bin/lc*を探すと、確かに見当たらない。

今の構成はまずfs64があって、そのファイルを/にマウントする形で
authサーバが動いてます。なのでまずfs64コンソールをみると、なんだか
Tfile/Tdir=xxxx; Expected=xxxみたいなエラーが画面いっぱいに出てまして。

fs64をconfig: allowで立ち上げなおしてみると、cwcmd touchsbで
WORMのスーパーブロックが読めないとか出てました。
じゃあこれディスクが壊れたのかなあ、と。
確かに単体の認証サーバからfs64をマウントしてみると、
\*/n/fs/rc/bin/lc*は普通にそこにあったしなあ。。
WORMディスクの交換ってどうすればいいんだろう。。。
