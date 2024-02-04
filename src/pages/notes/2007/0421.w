---
title: ファイルサーバカーネルをハックする
pre: ../include/u.i
post: ../include/nav.i
---

.revision
2007年4月21日作成
=ファイルサーバカーネルをハックする

このカードにはSATAポートが4つあるのですが、これに3つ以上HDDをつなげても、
カーネルからは2台までしか認識されません。
まあ、そりゃあそうですよね。NCtlrdrv = 2なんですから。

結局、[SATA-RAIDカード|http://www.kuroutoshikou.com/products/serialata/sataraid5-lppcifset.html]を2枚挿して、
どうにか認識させたところ、ドライブ反応は3つになりました。

が。

認識されたドライブ名が、全部ata h4 ...とか出やがるじゃないですか。
まあ、ソースをみれば/sys/src/fs/pc/sdata.c:atagetdriveが、
オンボードIDE1,2,その他、という3つの分類しかしてないからだと
分かるのですが、最初は戸惑いました。
どうにもできないのでsdata.c:ataprobeを書き換えて
実際のドライブ番号を出力するように調整してコンパイル。
どうやらh4,h6,h8と認識されてます。

ここで*filsys main ch4f{h6h8}*と設定してブートすると、
今度はsdata.c:ataxferが

!ataxfer: sdunits[4].dev=$addr1 is wrong controller (want $addr2)

とか言ってパニックです。
そろそろめんどくさくなってきたので、適当にハックして今に至る。

パッチは/n/sources/patch/fs-ataに投げました。
