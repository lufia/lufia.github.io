---
title: VMware ESXiにPlan 9を移行したときのトラブルまとめ
style: ../../../styles/global.css
pre: ../include/u.i
post: ../include/nav.i
---

.revision
2012年10月6日作成
=VMware ESXiにPlan 9を移行したときのトラブルまとめ

	=cpuサーバからfsをマウントできない

	.console
	!% 9fs il!fs.ip.ad.dr!9fs

	こうすると、マウントできず切断されます。
	たぶんカーネルにILを組み込んだけどndb/csに手を入れるのを忘れていたせいだと思う。

	.note
	この場合、fsコンソールのflagコマンドでilビットをを立てて、
	出力される接続元と接続先をみるとポートが9になっているのでよくわかる。

	この場合、マウントするには以下のようにポートを数値にすればいいです。

	.console
	!% 9fs il!fs.ip.ad.dr!17008

	=mkextでバックアップを展開すると、not foundが出力される

	単純に、マウントするとき-cを付けていないだけでした。
	もちろん展開もできていないのでやりなおし。

	=ブート時に、version...time...で長時間固まる

	正確には、version...でしばらく止まって、
	time...でも止まっていました。トータル20分くらい。
	結局これ、[IPv6対応したil.c|
	../../plan9/src/il.c]のバグで、正しくilrejectできていなくて、
	タイムアウトまで待ち続けていただけっぽいです。

	=ipconfigでgbeを使うと、replica時に落ちる

	gbeというのは、ドライバのことではなくて、ipconfigの引数で

	.console
	!% ip/ipconfig -g xxx gbe /net/ether0 ...

	とした場合のことです。このとき、replica/pullすると
	hungup io connectionとエラーを吐いてシステムごと落ちます。
	調べる気もないので原因不明。gbeではなくetherなら動きました。

	=fs64に含まれるIntel E1000ドライバが遅い

	もともと含まれていたigbe.cはVMwareのVendorID等を持っていなかったので
	Plan 9カーネルをまねて足したのですが、全然パフォーマンスが出ませんでした。
	具体的には、同じホストにある仮想マシン間でpingを投げる(cpu to fs)と、
	平均30000us程度かかっていました。ふつうは遅くても200us程度なのに。

	.note
	不思議なのは、Plan 9カーネルにもigbe.cがあって、
	同じESXiホストに乗っているのに、こっちは200us程度なんですよね。
	様子をみる限りでは、fs側のパケット受信反応が悪い気がする。
	VendorID足したときにミスったかなあ。。。

	結局、[AMD VlanceドライバをPlan 9カーネルからfsへ移植|
	../../plan9/src/ether79c970.c]しました。
	こっちは普通に200us程度の速度出ているみたい。
