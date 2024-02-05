---
title: fsバックアップメモ
style: ../../../styles/global.css
pre: ../include/u.i
post: ../include/nav.i
---

.revision
2010年7月5日作成
=fsバックアップメモ

ふと気になったので調べてみました。
今までよく無事だったなあ。。
単語としては、以下のとおり。

:Cache-WORM
-キャッシュとWORMのセットになったディスク
:Cache
-Cache-WORMディスクのCache部分
:WORM
-Cache-WORMディスクのWORM部分

	=Cacheが壊れたとき

	たぶん、filsysを再設定して、recover mainで復旧。
	とりあえずディスクタイプを先にまとめ。

	!dev->type:
	!	'(' => Devcat
	!	'[' => Devmlev
	!	'{' => Devmirr
	!	'c' => Devcw
	!	'w' => Devwren
	!	'f' => Devfworm
	!	'p' => Devpart
	!	'x' => Devswab
	!	'n' => Devnone		# 特別なデバイス

	=例題

	以下のデバイス式の場合。

	!cw0f{w1w2}

	およそ次のようなデータ構造になる。

	!d->type = Devcw
	!d->cw.c = {
	!	type = Devwren
	!}
	!d->cw.w = {
	!	type = Devfworm
	!	fw.fw = {
	!		type = Devmirr
	!		cat = w1{type = Devwren} :: w2{type = Devwren}
	!	}
	!}
	!d->cw.ro = {		# filsys * oで使う; /2010/0705とかを格納する
	!	type = Devro
	!	ro->parent = d
	!}

	これをふまえて、recoverの処理を追ってみた。

		=arginit

		.c
		!fs->flags |= FRECOVER

		後の処理で使うためのフラグ立て。
		recoverコマンドはconfigモードを抜けてはじめて処理される。

		=sysinit

		.c
		!fs->dev = iconfig(fs->config)
		!if(fs->flags&FRECOVER)
		!	devrecover(fs->dev)

		=devrecover(dev)

		.c
		!cwrecover(dev)

		どんどん深くなる。。
		ここで、cwrecoverに渡されるdevは、
		Cache-WORMディスクだけになっている。

		=cwrecover(dev)

		WORMのSuperblockを取ってきたりいろいろ。これが肝っぽい。
		WORMのSuperblockを渡り歩いて、
		最新ならそれのアドレスをbaddrにセットしておく。
		これは、最初のSuperblockは固定アドレスにあるが、
		以降は可変のため。

		で、最新のSuperblock(言い換えると最終dump)が定まると、
		続けて各種ブロックアドレスをCacheに設定。

		.c
		!p = getbuf(wdev, baddr, Bread)
		!s = (Superb*)p->iobuf
		!cb = cacheinit(dev)		# 初期化するだけ
		!h = (Cache*)cb->iobuf
		!h->sbaddr = baddr
		!h->cwraddr = s->cwraddr

		一部省略したけど、これで終わりっぽい。
		ざっと調べると、Cacheは本当にただのキャッシュで、
		ディスク容量が足りなくなれば、古いキャッシュを一部捨てて、
		新しいキャッシュ用に空きを作るらしい。
		recover直後はまったくキャッシュされていない状態になるのかな。

	=WORMが壊れたとき

	まだ途中までしか追ってないけど、こっちが壊れたら終わりっぽい。
	なので、最低限ミラーリングしておかないとまずい気がする。
	ミラーしているディスクのうち1台でも残っているなら、
	copydevかcopywormを使えば良さそうな気がするなあ。

	うーん、仮定ばかりだね。あとで調べる。

	もしかして、ディスクを交換したら
	自動でコピーしてくれるのかなと思ったら。

		={w1w2}を初期化する流れ
		!port/main.c:122: main(void)
		!port/config.c:903: arginit(void)
		!dev/fworm.c:43: fworminit(Device *d)
		!port/sub.c:1389: devinit(Device *d)
		!dev/mworm.c:201: mirrinit(Device *d) 

		=ブロックを読む時
		!dev/mworm.c:233: mirrread(Device *d, Off b, void *c)
		!	forで配列分ループして、devread() == 0(正常？)なら抜けてる
		!port/sub.c:1096: devread(Device *d, Off b, void *c)
		!dev/wren.c:107: wrenread(Device *d, Off b, void *c)
		!	これらは最終的にはscsiioに帰結してる

	ということは、各ミラーの整合性は自分で取れってことかな。

	=Cacheを新しくするとき

	たぶんキャッシュが壊れたときと同じでrecoverすればいい。

	=WORMを新しくするとき

	あとで

	=サーバそのものが全壊したとき

	どうしようね。

	:CD/DVD
	-700M/4G
	:Blu-ray
	-25G
	:USB HDD
	-500Gから
	:ネットワーク
	-?

	プログラムを書いたりhtml書いたりしているだけなので
	まだそんなに容量使ってないけど、
	さすがに光ディスクは現実的ではないと思う。
	とはいえ、どれにしても、allowしないとだめなんだよなあ。。

.aside
{
	=参照ページ
	*[ファイルシステム|http://plan9.aichi-u.ac.jp/fs/]
}
