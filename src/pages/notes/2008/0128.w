---
title: Alef言語
style: ../../../styles/global.css
pre: ../../../layouts/notes/u.i
post: ../../../layouts/notes/nav.i
---

.revision
2008年1月28日作成
=Alef言語

	最初は自分で移植してたけど、/n/sources/contrib/lucio以下に
	ソースがあったので、ありがたく使わせてもらうことにします。

	=展開
	.console
	!% cd /n/sources/contrib/lucio
	!% gunzip -c alef.tgz | @{cd /sys/src && tar x}
	!% cd sys/include
	!% tar c alef | @{cd /sys/include && tar x}

	=コンパイル
	.console
	!% cd /sys/src/alef/8
	!% mk install		# 8alコマンドが作られる
	!% cd ../lib
	!% mk install		# libA.a等のライブラリ作成

	=プログラム作成
	.c
	!#include <alef.h>
	!
	!void
	!main(void)
	!{
	!	int fd, n;
	!	byte buf[1024];
	!
	!	fd = open("a.l", 0);
	!	while((n=read(fd, buf, sizeof buf)) > 0)
	!		write(1, buf, n);
	!}

	=テスト
	.console
	!% 8al a.l
	!% 8l a.8
	!% 8.out

	=まとめ
	動いた。当たり前かもしれないけど、ちょっと感動してます。
	ざっとソースを眺めた限りでは、lint等いくつか見当たらないけど、
	今日はもうお腹いっぱいなので、そこは後日調べていこうかななんて。
