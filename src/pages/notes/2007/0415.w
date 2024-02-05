---
title: ファイルサーバの再構築
style: ../../../styles/global.css
pre: ../include/u.i
post: ../include/nav.i
---

.revision
2007年4月15日作成
=ファイルサーバの再構築

現時点では、マザーボードのIDEコントローラは、スレーブの存在を忘れたほうがいいのかも。

なにはともあれ構成。

:マザーボード
-[M7VIG PRO|
http://www.biostar-usa.com/mbdetails.asp?model=m7vig+pro]
:IDE1マスタ
-Maxtor 40GB
:IDE2マスタ
-WD 250GB
:IDE2スレーブ
-Maxtor 250GB

というのも、fs64のconfigで*filsys main ch0f{h2h3}*と設定していたのですが、
不定期に次のエラーが頻発してまして。
ファイルサーバを再起動するとtagが違うとかのエラーでpanicするおまけつき。
最初にdumpするまではふつうに動くのに。

dump直後などに
!mirrwrite $dev error at block $addr

ブート時に(この場合、手動でusersコマンドを発行すると読める)
!cannot open /adm/users

不定期に
!cwio: write induced dump error - r cache

さすがに使い物にならないので。
HDDを0バイトで埋めてみたりデバッグ文を埋め込んだりしたところ、
dump中にcacheへアクセスがいくと/adm/usersが読めないようでした。
そこで、別のIDEコントローラにすればいいのかなあと考え、[玄人志向のSATARAID5-LPPCI|http://www.kuroutoshikou.com/products/serialata/sataraid5-lppcifset.html]を買って(ついでにIDE to SATA変換アダプタも)つなげてみました。
パッケージにはJBODとあるのにメニューには無かったので驚きましたが、
代わりにConcatenationがあったのでそれを使って構成。
ファイルサーバのコンフィグは、*filsys main ch4f{h0h2}*

まず気づいたのが立ち上がり時のfwormへのアクセスですが。
今までと違い、dumpが終わるまでプロンプトが表示されなくなってました。
今のところエラーも出ないので少し期待。。

+dump開始
+*cannot access /adm/users*
+プロンプト表示
+dump終わり
