@include u.i
%title ネットワークの設定

.revision
2009年9月5日更新
=ネットワークの設定

	Plan 9のネットワーク設定ファイルは、*/lib/ndb/local*です。
	これはUnixで言うところの、*hosts*と*named.conf*を
	まとめたようなもので、そこそこ厄介です。

	以下は、現在使っている設定から
	DNSまわりの記述を除いたものです。
	ipnetに共通項を書いておいて、他のエントリから
	参照するようにしています。

	.ini
	!
	!#
	!#  files comprising the database, use as many as you like, see ndb(6)
	!#
	!database=
	!	file=/lib/ndb/local
	!	file=/lib/ndb/common
	!
	!auth=sources.cs.bell-labs.com authdom=outside.plan9.bell-labs.com
	!
	!#
	!#  because the public demands the name localsource
	!#
	!ip=127.0.0.1 sys=localhost dom=localhost
	!
	!ipnet=home ip=192.168.1.0 ipmask=255.255.255.0
	!	fs=dryad.lufia.org
	!	ipgw=192.168.1.1
	!	dns=xxx.xxx.xxx.xxx		# プロバイダのDNS
	!	dnsdomain=lufia.org
	!	auth=wisp.lufia.org
	!	authdom=mana.lufia.org
	!	cpu=wisp.lufia.org
	!
	!sys=flammie dom=flammie.lufia.org
	!	ip=192.168.1.1
	!
	!sys=dryad dom=dryad.lufia.org
	!	ip=192.168.1.23
	!	proto=il
	!
	!sys=wisp dom=wisp.lufia.org
	!	ip=192.168.1.7
	!	proto=il
	!	ether=0006a54200a1
	!
	!ip=192.168.1.7 dom=lufia.org

	上記では、sysの値とdomの値を揃えていますが、
	異なっていてもかまいません。

	ipgwの値をflammie.lufia.orgとしても動きそうなものですが、
	そうすると値が化けてしまって、うまく参照できませんでした。
	なので直接IPアドレスを書いています。

	etherの値は該当カードのMACアドレスで、
	\*/net/ether0/addr*を読むと調べられます。
	たぶん無くても動きます。

	最後のエントリはwisp.lufia.orgの別名になります。
	cnameとどちらにするか迷った結果、こうした記憶がありますが、
	いろいろなところが定かではありません。
	目的はhttp://lufia.org/として参照できるように。

.aside
{
	=関連情報
	*[ndb(6)]
	*[認証サーバのインストール|../inst/auth.w]
	*[カーネルにilを組み込む|../inst/il.w]
	*[DNSの設定|dns.w]
}

@include nav.i
