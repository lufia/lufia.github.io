---
title: カーネルにilを組み込む
style: ../../../../styles/global.css
pre: ../../../../layouts/plan9/u.i
post: ../../../../layouts/plan9/nav.i
---

.revision
2011年7月1日更新
=カーネルにilを組み込む

	カーネルからilが外されてしまったので、dumpfsを利用する場合には、
	自分でilを組み込まなければ動きません。
	具体的には、まず、*il.c*を*/sys/src/9/ip/il.c*にコピーします。

	.note
	{
		\[IPv6対応のIL|../../src/il.c]を書いてみました。
		ざっと使い方を書くと、

		.sh
		!aux/listen1 il!*!9001 /bin/exportfs -r $home

		別のウィンドウで

		.sh
		!9fs il!::1!9001 /n/remote
	}

	.console
	!% 9fs sources
	!% cp /n/sources/extra/il.c /sys/src/9/ip/il.c

	次に、*/sys/src/9/ip/ip.h*のLogtcp付近を以下のように変更します。

	.c
	!Logtcp=		1<<2,
	!Logfs=		1<<3,
	!Logil=		1<<4,	// 追加
	!Logicmp=	1<<5,
	!Logudp=		1<<6,
	!Logcompress=	1<<7,
	!Logilmsg=	1<<8,	// 追加
	!Loggre=		1<<9,

	.note
	{
		これに加えて、*ip/netlog.c*にも追加。無くても動きますが。

		.c
		!static Netlogflag flags[] =
		!{
		!	{ "ppp",	Logppp, },
		!	{ "ip",		Logip, },
		!	{ "fs",		Logfs, },
		!	{ "il",			Logil, },		// 追加
		!	{ "tcp",	Logtcp, },
		!	{ "icmp",	Logicmp, },
		!	{ "udp",	Logudp, },
		!	{ "compress",	Logcompress, },
		!	{ "ilmsg",		Logil|Logilmsg, },	// 追加
		!	{ "gre",	Loggre, },
		!	{ "tcpwin",	Logtcp|Logtcpwin, },
		!	{ "tcprxmt",	Logtcp|Logtcprxmt, },
		!	{ "udpmsg",	Logudp|Logudpmsg, },
		!	{ "ipmsg",	Logip|Logipmsg, },
		!	{ "esp",	Logesp, },
		!	{ nil,		0, },
		!};
	}

	2010年の途中まではここまでで動きましたが、
	2011年5月に確認してみると、いくつかコンパイルエラーが出ました。
	そこで、若干むりやりですが、boot以下の*boot.h*と*bootip.c*に追加します。

		=boot/boot.h

		.c
		!extern void	configil(Method*);
		!extern int	connectil(void);

		=boot/bootip.c

		.c
		!void
		!configil(Method*)
		!{
		!	configip(bargc, bargv, 1);
		!	setauthaddr("il", 566);
		!}
		!
		!int
		!connectil(void)
		!{
		!	int fd;
		!	char buf[64];
		!
		!	snprint(buf, sizeof buf, "il!%I!17008", fsip);
		!	fd = dial(buf, 0, 0, 0);
		!	if(fd < 0)
		!		werrstr("dial %s: %r", buf);
		!	return fd;
		!}

	最後に、confファイルに、ilのエントリが必要になります。
	いま使っているpcauthの場合はこんな感じ。

	!dev
	!	root
	!	cons
	!	arch
	!	pnp		pci
	!	env
	!	pipe
	!	proc
	!	mnt
	!	srv
	!	dup
	!	rtc
	!	ssl
	!	tls
	!	cap
	!	kprof
	!	fs
	!
	!	ether		netif
	!	ip		arp chandial ip ipv6 ipaux iproute netlog nullmedium pktmedium ptclbsum386 inferno
	!
	!	draw		screen vga vgax
	!	mouse		mouse
	!	vga
	!
	!	sd
	!	floppy		dma
	!
	!	uart
	!
	!link
	!	apm		apmjump
	!	ether8139	pci
	!	ether8169	pci ethermii
	!	ethermedium
	!	netdevmedium
	!	loopbackmedium
	!
	!misc
	!	realmode
	!	archmp		mp apic
	!	mtrr
	!	sdata		pci sdscsi
	!
	!	uarti8250
	!	uartpci
	!
	!	vgamach64xx	+cur
	!	vgas3 		+cur vgasavage
	!
	!ip
	!	il
	!	tcp
	!	udp
	!	ipifc
	!	icmp
	!	icmp6
	!	gre
	!	ipmux
	!	esp
	!
	!port
	!	int cpuserver = 1;
	!
	!boot cpu boot #S/sdC0/
	!	tcp
	!	il
	!	local
	!
	!bootdir
	!	bootpcauth.out boot
	!	/386/bin/ip/ipconfig
	!	/386/bin/auth/factotum
	!	/386/bin/fossil/fossil
	!	/386/bin/venti/venti
	!#	/386/bin/disk/kfs

	以前とくらべて、

	!misc
	!	arch		mp apic
	!	mtrr

	これらがなければリンク時にエラーがでますね。

.aside
{
	=関連情報
	*[ファイルサーバのインストール|fs.w]
	*[ILプロトコル|../guide/il.w]
	*[il.cを読む|../../../notes/2011/0618.w]

	=参考ページ
	*[9fans: Kernel and IL|http://9fans.net/archive/2007/10/34]
	*[Re: 9fans: Kernel and IL|http://9fans.net/archive/2007/10/35]
	*[IL: 失われたプロトコル|http://www.slideshare.net/oraccha/il-4020522]
}
