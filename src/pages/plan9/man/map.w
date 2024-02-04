---
title: games/map
pre: ../include/u.i
post: ../include/nav.i
---

=games/map
	=SYNOPSIS
	!games/map [-v] [file ...]
	!games/mapedit [-o output] [-s subject] [file ...]

	=DESCRIPTION
	mapは、簡単な文法のプログラムを読み込み、
	それをpic(1)の書式に書き換え、標準出力へ書き出します。

	mapeditは、グラフィックスとマウスを使って、
	map用のプログラムを生成します。
	通常、ファイル引数を与えなければ
	真っ白なマップから書き始めることになりますが、
	1つ以上与えれば、その途中から続けられます。

	=OPTIONS
		=map
		:v
		-行や列の番号と、補助線を表示します。

		=mapedit
		:o
		-生成したmapプログラムを書き出すファイル名
		-省略した場合は標準出力に
		:s
		-マップの名前を、生成後のプログラムに含めます

	=LANGUAGE
		map言語は、簡単なコマンドを上から順に実行します。
		言語と言ってはいますが、制御文などはありません。
		座標は左上がx=1, y=1となります。

		=floor命令
		!floor x y [subject]

		マップの大きさをxとyで指示します。
		floor命令が無い場合、mapの-vオプションが使えません。

		=line命令
		!line x y place

		指定の座標に線を引きます。
		placeは、top, bot, left, right, bottomのどれかです。

		=mark命令
		!mark x y string

		座標の中心に文字を書きます。

		=move命令
		!move x y direction

		座標に矢印を描きます。
		矢印の向きはdirectionでup, down, left, rightのうち1つです。

		=fill命令
		!fill x y

	=INSTALL
	あとで

	=EXAMPLE
	!floor 7 5 "Past 1F-2"
	!
	!# item
	!mark 7 2 "A"
	!
	!# step
	!mark 4 5 "1"
	!mark 2 2 "2"
	!
	!line 1 2 top
	!line 3 1 left
	!line 5 1 right
	!line 7 3 bot
	!line 6 4 right
	!line 1 4 right
	!line 1 4 top

	=BUGS
	mapeditは、map言語のmove命令に対応していません。
	また、mark命令のstringをダブルクォートで括らなければ
	エラーになります。
