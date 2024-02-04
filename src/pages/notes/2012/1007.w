---
title: ESXiでfsカーネルのブート
pre: ../include/u.i
post: ../include/nav.i
---

.revision
2012年10月7日作成
=ESXiでfsカーネルのブート

	6/12頃、ESXi 5.0にfs64カーネルを置いて動かしたところ、
	起動時に、たぶんカーネルの実行がはじまったあたりで、
	割り込みかなにかを受けてパニックしました。
	回避はしたけど解決できていないので、いちおうまとめ。

	具体的なメッセージはこんなの。

	!cpu0: 2590MHz P6
	!apm ax=f000 cx=f000 dx=40 di=ffff ebx=5470 esi=-1
	!bios (usb) loading disabled
	!no ethernet interfaces recognised
	!bus dev type vid  did intlognised
	!bus dev type vid  did intl memory
	!found 9fsfs64
	!.388008.........................+1208352.................+189444-705804
	!entry: 0x80100020
	!FLAGS=10086 TRAP=e ECODE=0 PC=80128b8c
	!  AX f000ff53  BX 801913b4  CX 801959a4  DX 801913b4
	!  SI 8012b96b  DI 001ac964  BP 00000049
	!  CS 0010 DS 0008  ES 0000  FS 0008  GS 0008
	!  CR0 80010011 CR2 f000ff53 CR3 00183000
	!panic: exception/interrupt 14
	!FLAGS=10086 TRAP=e ECODE=0 PC=8001e777
	!  AX 8001e769  BX 00000c80  CX 808185fc  DX 00000006
	!  SI 00000000  DI 8004f3e8  BP 0000000a
	!  CS 0010 DS 0008  ES 0000  FS 0008  GS 0008
	!  CR0 80010011 CR2 80818614 CR3 00183000
	!panic: exception/interrupt 14
	!....

	=interrupt 14とは

	調べると、page faultでした。結構いやな感じ。

	上記のログ"entry: 0x80100020"に続くのは、
	おそらく"Plan 9 63-bit fileserver"で、
	この文字列はmain()の中、一部の初期化が終わったところにあります。
	で、exception/interrupt 14というメッセージは、
	ローダの割り込みハンドラに書かれています。

	=最新のローダで動かす

	最新(6/14頃)のCD imageからインストールしてみると普通に動きました。
	そのまま、カーネルだけfs64に差し替えてみたらエラー。
	なのでローダのメッセージが出ているけれど、原因はカーネルっぽい。

	=ESXiとの相性問題なのか調べる

	少なくとも物理マシンで動いていた、2010年頃(もっと前かも)に作成した
	fs64のブートフロッピーからブートしたら動きました。
	そのままカーネルだけを新しくコンパイルしたものに差し替えたら起動しません。

	=ビルド環境を変えてみる

	fsカーネルは/386/lib/libc.a等をリンクしているようなので
	適当に、/n/dump/2011/0701/386を/386にバインドして
	コンパイルしたものの、やっぱり変わらずエラー。

	コンパイラとリンカを2011/07/01のものに変えたらなんだか動いた。

	.console
	!% 9fs dump
	!% bind /n/dump/2011/0701/386/8c /bin/8c
	!% bind /n/dump/2011/0701/386/8l /bin/8l

	コンパイラのバグが修正されて、修正の結果、
	それまでバグがあったおかげでたまたまうまく動いていた部分が
	今回から落ちるようになったのなら、放置すると後で困りそうだなあ。

	=おまけ

	いちおう読んだfsカーネルのブート周りのフロー。

	!port/main.c:main
	!	port/sub.c:formatinit()	# printの書式などを初期化
	!	port/main.c:machinit()	# mってなんだ？
	!	pc/pc.c:vecinit()
	!		# たぶん、9loadに読み込まれたplan9.iniをパースする
	!		# confname[n], confval[n]に入る
	!		# =が複数ある場合は、最初の=までがconfname
	!	port/main.c:confinit()
	!		# conf構造体を初期化
	!		pc/pc.c:meminit()
	!			pc/pc.c:mconfinit()
	!				# mmap, mapaddrを初期化しているっぽい
	!			pc/mmu.c:mmuinit()
	!				# gdt, kptを初期化？
	!				# このあたりになるとよくわからない
	!				pc/mmu.c:taskswitch()
	!					# tssを初期化
	!			trapinit()
	!				# 割り込み設定
	!				# intr0, 1みたいな関数は、pc/l.sにあるアセンブリコード
	!				# そこから潜って、pc/trap.c:trapに落ち着く
	!
	!				SEGCG: call gate
	!				SEGIG: interrupt gate
	!				SEGTG: task gate
	!
	!				# 0..255までにtask gateとして、intrbadを設定
	!				sethvec() for 17..23, 40..255
	!
	!				# 0から16までは特別なintr0, intr1みたいなトラップ
	!				# うち、14(page fault), 16(math coprocessor)はinterrupt gate
	!				sethvec() for 0..16
	!
	!				# デバイス割り込みはinterrupt gate; これも特別なトラップ
	!				sethvec() for 24..39
	!
	!				なんかいろいろ
	!				fpinit()
	!		fs64/9fsfs64.c:localconfinit()
	!			# confをいろいろ設定
	!			# 時間とか
	!	pc/pc.c:lockinit()
	!		# 何もしない
	!	port/devcons.c:printinit()
	!		# printq, readqを初期化
	!		pc/pc.c:consinit()
	!			# consgetc, consputc, consputs, intrputsの設定
	!			# コンフィグがconsole=cgaでなければbaudとかも設定
	!			pc/kbd.c:kbdinit()
	!	port/proc.c:procinit()
	!		# procallocを初期化
	!		wakeup()
	!	pc/8253.c:clockinit()
	!		# 他もだが、特にここは本気でわからない
	!		setvec()
	!		cpuid()
	!		cycles()
	!		aamloop()
	!
	!	print("Plan 9 64 bit file server...")
	!
	!	printsizes()
	!	alarminit()
	!
	!	# このあたりでserveq, raheadqを初期化
	!
	!	mbinit()
	!	sntpinit()
	!	fs64/9fsfs64.c:otherinit()
	!
	!	# 終わりに、files, wpaths, uid, gidspaceを初期化
	!
	!	authinit()
	!	iobufinit()
	!	arginit()
	!	userinit()
	!
	!	wakeup()
	!	launchinit()
	!	schedinit()
