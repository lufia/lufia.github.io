---
title: 無線LANのセキュリティ2
style: ../../../styles/global.css
pre: ../include/u.i
post: ../include/nav.i
---

.revision
2011年7月12日作成
=無線LANのセキュリティ2

Pyritにより、[WPA2-PSKの攻撃が現実的になってきた|
http://blog.hidekiy.com/2011/07/crypto-pyritlan.html]ようです。
詳しくは上記リンクを読んでもらいつつ、
さてPlan 9で強力なパスワードを作るには、ということで
openssl rand -base64と(おそらく)似たプログラムを書きました。
ふつうに/dev/randomから読んでbase64エンコードしているだけですね。

.c
!#include <u.h>
!#include <libc.h>
!
!#pragma varargck type "B" uchar*
!
!enum {
!	N = 3,
!	BITS = 6,
!	RBUFSIZE = N*8/BITS,
!};
!
!#define MASK(c, n)	((c)&((1<<(n))-1))
!
!char map[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
!	"abcdefghijklmnopqrstuvwxyz"
!	"0123456789+/";
!
!void
!usage(void)
!{
!	fprint(2, "usage: %s [-n nbytes] [s]\n", argv0);
!	exits("usage");
!}
!
!int
!Bfmt(Fmt *fmt)
!{
!	uchar *s;
!	char *buf, *p;
!	int i, t, nbuf;
!	int n, nbits;
!
!	nbuf = (fmt->prec/N+1) * RBUFSIZE;
!	buf = malloc(nbuf+1);
!	if(buf == nil)
!		sysfatal("malloc: %r");
!	p = buf;
!
!	nbits = 0;
!	n = 0;
!	s = va_arg(fmt->args, uchar*);
!	for(i = 0; i < fmt->prec; i++){
!		n = n<<8 | s[i];
!		nbits += 8;
!		while(nbits >= BITS){
!			t = MASK(n >> (nbits-BITS), BITS);
!			nbits -= BITS;
!			n = MASK(n, nbits);
!			assert(t >= 0 && t < nelem(map));
!			*p++ = map[t];
!		}
!	}
!	if(nbits > 0){
!		n <<= BITS-nbits;
!		assert(n >= 0 && n < nelem(map));
!		*p++ = map[n];
!	}
!
!	t = fmt->prec%N;
!	if(t > 0)
!		for(i = 0; i < N-(fmt->prec%N); i++)
!			*p++ = '=';
!	*p = '\0';
!	i = fmtprint(fmt, "%s", buf);
!	free(buf);
!	return i;
!}
!
!void
!main(int argc, char *argv[])
!{
!	int fd, nbuf;
!	uchar *buf;
!
!	nbuf = 100;
!	ARGBEGIN {
!	case 'n':
!		nbuf = atoi(EARGF(usage()));
!		break;
!	default:
!		usage();
!	} ARGEND
!
!	assert(N*8 == RBUFSIZE*BITS);
!	fmtinstall('B', Bfmt);
!	if(argc > 0)		/* for debug */
!		print("%.*B\n", strlen(argv[0]), argv[0]);
!	else{
!		buf = malloc(nbuf);
!		if(buf == nil)
!			sysfatal("malloc: %r");
!
!		fd = open("/dev/random", OREAD);
!		if(fd < 0)
!			sysfatal("open: %r");
!		if(readn(fd, buf, nbuf) != nbuf)
!			sysfatal("read: %r");
!		close(fd);
!		print("%.*B\n", nbuf, buf);
!		free(buf);
!	}
!	exits(nil);
!}

.aside
{
	=関連情報
	*[無線LANのセキュリティ|../2009/1019.w]
}
