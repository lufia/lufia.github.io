---
title: lib9p tips
pre: ../../include/u.i
post: ../../include/nav.i
---

.revision
2004年11月7日更新
=lib9p tips

	=トラブルシューティング

		=walk in non-directory
		((mode&DMDIR) != 0)なのに、cdできない場合。
		忘れがちですが、attachでは以下2つのqidをセットすること。

		.c
		*r->>fid->>qid
		*r->>ofcall.qid

		=printでsuicide
		9pライブラリを使うとき、%D, %Fはライブラリから
		すでに使われているので、それ以外で選ばなければいけない。
		スタックトレースを取ったときに、
		utflenで落ちる場合はそれかもしれない。
		例えば以下のような。

		.console
		!acid: stk()
		!utflen(s=0xfefefefe)+0xf /sys/src/libc/port/utflen.c:13
		!fmtstrcpy(f=0x4f194,s=0xfefefefe)+0xa9 /sys/src/libc/fmt/dofmt.c:251
		!_strfmt(f=0x4f194)+0x1d /sys/src/libc/fmt/dofmt.c:261
		!_fmtdispatch(isrunes=0x0,f=0x4f194,fmt=0x30590)+0x94 /sys/src/libc/fmt/fmt.c:196
		!dofmt(fmt=0x3058e,f=0x4f194)+0x75 /sys/src/libc/fmt/dofmt.c:62
		!vseprint(e=0x4f308,buf=0x4f268,args=0x4f1f8,fmt=0x3057e)+0x5d /sys/src/libc/fmt/vseprint.c:20
		!seprint(fmt=0x3057e,buf=0x4f268,e=0x4f308)+0x2b /sys/src/libc/fmt/seprint.c:13
		!fdirconv(d=0x4f4fc,buf=0x4f268,e=0x4f308)+0xaa /sys/src/libc/9sys/fcallfmt.c:181
		!dirfmt(fmt=0x4f480)+0x32 /sys/src/libc/9sys/fcallfmt.c:173
		!_fmtdispatch(isrunes=0x0,f=0x4f480,fmt=0x32d3b)+0x94 /sys/src/libc/fmt/fmt.c:196
		!dofmt(fmt=0x32d39,f=0x4f480)+0x75 /sys/src/libc/fmt/dofmt.c:62
		!vfprint(fd=0x2,args=0x4f4dc,fmt=0x32d30)+0x59 /sys/src/libc/fmt/vfprint.c:30
		!fprint(fmt=0x32d30,fd=0x2)+0x23 /sys/src/libc/fmt/fprint.c:13
		!nsproc()+0x5f7 /sys/src/cmd/msnfs/proto.c:338
		!launcher386(arg=0x0,f=0x262b)+0x10 /sys/src/libthread/386.c:10

.aside
{
	=関連情報
	*[9p(2)]
}
