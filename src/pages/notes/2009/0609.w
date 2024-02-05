---
title: Xbox LIVEに繋がらない
style: ../../../styles/global.css
pre: ../include/u.i
post: ../include/nav.i
---

.revision
2009年6月9日作成
=Xbox LIVEに繋がらない

	LIVEへ繋げようと思ったら、いつの間にか、
	MTUが小さすぎるというエラーで繋がらなくなっていて少し困る。
	サポートには[MTUが1364以上|
	http://support.microsoft.com/kb/908882/ja]とあるので、
	以下の設定で間違いはないはずなのですが。

	!interface Dialer 0
	!	ip mtu 1454

	結局、ポートが開いてないだけでしたけどね。
	以下の設定を加えました。一部抜粋。

	!ip inspect name cfw udp
	!
	!interface Dialer 0
	!	ip inspect cfw out

	NAPTの設定しなくても、ダウンロードだけなら動くようです。
	\[対戦はP2P接続|http://qooptraxus.spaces.live.com/blog/cns!9C6791DF1A608A5A!976.entry]のようなので、対戦しようとするとまた別ですね。

	ルータを[Cisco 851W|http://www.cisco.com/web/JP/product/hs/routers/c800/c851/index.html]
	に換えたときに、ポートを開くのを忘れてたのですね。
	Planexの[BRC-14VG|
	http://www.planex.co.jp/product/broadlanner/brc-14vg.shtml]は、
	UPnPに対応してたので勝手に開いていたのでしょう。
	よく分かりませんが。たぶん。

	ついでに[ワイヤレスLANアダプタ|http://www.xbox.com/ja-JP/hardware/x/xbox360wirelessnetadapter/]買いました。
	規格的に、証明書が無ければ厳密なセキュリティを維持できない程度なので、
	信用おけませんが、単純にケーブルが無くなるのは便利だなと思います。

.aside
{
	=参考
	*[Xbox LIVEを利用するために開くポート|
	http://support.microsoft.com/kb/908874/ja]
	*[Xbox360でXbox Liveに繋がらなくなった|http://alectrope.ddo.jp/mt/archives/2006/11/22/xbox360_xbox_live_mtu_icmp]
}
