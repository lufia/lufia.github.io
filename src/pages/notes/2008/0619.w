---
title: 停電
style: ../../../styles/global.css
pre: ../../../layouts/notes/u.i
post: ../../../layouts/notes/nav.i
---

.revision
2008年6月19日作成
=停電

6/18の、おそらく6:00〜6:10に停電があったようで、
サーバ群がもれなく沈黙していました。
いやあ、、さすがに困る、こういう突発的なもの。
しかたないんですけどね。

さてさて、fs64、auth+cpuサーバ、
スリープモードvistaの3台が被害にあったのですが、
fs64は、運よく5:00をまわってくれていたので、fs64のconfigモードから
最終dump時の環境に戻して復旧終了。1分もかかりませんでした。すごいね。

.console
!config: recover main
!config: end

auth+cpuサーバは、fs64の上に乗っているだけなので、
fs64が復旧すれば問題ないです。
めんどくさいのは9fatとnvramくらいかな。どちらも今回は無傷でした。

vistaは、電源を入れた時にセーフモードを選ぶメニューが表示されたので、
やっぱりまずいのかなあ、と思いましたが、[Windows Vista情報局|
http://windowsvista.nomaki.jp/vistacustomize/vistashutdown.html]
によると、なんだか大丈夫みたいです。

>スリープはスタンバイ、休止状態を併せ持った機能となります。
>スリープ状態では、データの保存はメモリ、HDDの両方へ保存します。
>通常復帰する際はメモリからデータを復帰するため高速に復帰が可能です。
>万が一電源が切れた場合はHDDから復帰します。
