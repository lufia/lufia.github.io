@include u.i
%title DNSの設定

.revision
2010年9月4日更新
=DNSの設定

	だいたいは[ネットワークの設定|ndb.w]と同じなので省略して。。

	.ini
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
	!dom=lufia.org soa=
	!	refresh=3600 ttl=3600
	!	ns=wisp.lufia.org
	!	mb=lufia@lufia.org
	!	mx=wisp.lufia.org pref=10
	!
	!dom=1.168.192.in-addr.arpa soa=
	!	refresh=3600 ttl=3600
	!	ns=wisp.lufia.org
	!
	!ipnet=home ip=192.168.1.0 ipmask=255.255.255.0
	!	fs=dryad.lufia.org
	!	ipgw=192.168.1.1
	!	dns=wisp.lufia.org
	!	dnsdomain=lufia.org
	!	auth=wisp.lufia.org
	!	authdom=mana.lufia.org
	!	cpu=wisp.lufia.org
	!
	!sys=flammie dom=flammie.lufia.org
	!	ip=192.168.1.1
	!	ether=0021a075d28a
	!
	!sys=dryad dom=dryad.lufia.org
	!	ip=192.168.1.23
	!	proto=il
	!	ether=00609580c28e
	!
	!sys=wisp dom=wisp.lufia.org
	!	ip=192.168.1.7
	!	proto=il
	!	ether=00a0b0a501ff
	!	dns=xxx.xxx.xxx.xxx			# プロバイダのDNS
	!
	!sys=jinn dom=jinn.lufia.org
	!	ip=192.168.1.100
	!	ether=041e6499c70a
	!
	!sys=luna dom=luna.lufia.org
	!	ip=192.168.1.101
	!	ether=002436eafb31
	!
	!sys=fairy dom=fairy.lufia.org
	!	ip=192.168.1.102
	!	ether=0023df18de16
	!
	!ip=192.168.1.7 dom=lufia.org

	基本的にはipnetの設定でdnsを与えていますが、
	DNSサーバだけは、個別のエントリでdnsを設定しています。

	次に、dom=1.168.192.in-addr.arpaのエントリは、
	逆引きを使わないのであれば無くても問題ありません。

	また、各ホストにetherの値を設定していますが、
	これがあると[dhcpd(8)]がIPアドレスを固定して割り当てます。

	設定が終わったら、cpurcのndb/dns呼び出しを以下のように変更。

	.sh
	!ndb/dns -sr

.aside
{
	=関連情報
	*[ndb(6)]
	*[ndb(8)]
	*[ネットワークの設定|ndb.w]
}

@include nav.i
