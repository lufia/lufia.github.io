---
title: lufia.orgのサーバ
style: ../../styles/global.css
pre: include/u.i
post: include/nav.i
---

=lufia.orgのサーバ

	=Google Compute Engine
	今はこれ。

	=さくらVPS
	2020年夏ごろまで使っていました。

	=fileserver(fs64)
	:CPU
	-Celeron E3300 BX80571E3300
	:memory
	-W3U1333Q1G
	:motherboard
	-[GA-G41MT-ES2L|http://www.gigabyte.co.jp/Products/Motherboard/Products_Overview.aspx?ProductID=3263]
	:powersupply
	-[EPG500AWT|http://www.links.co.jp/items/ener-power/epg500awt.html]
	:SCSI controller
	-[DC-390U3W|
	http://www.tekram.com/product2/product_detail.asp?pid=43]
	:disk
	-Atlas 15k2 146GB
	-IDE 256GB+[AEC7726Q|
	http://www.unitycorp.co.jp/si/acard/bridge/bridge.html#aec7726q] x2
	:config
	-filsys main cw0f{w1.<<14-15>>.0}
	-filsys dump o

	=old fileserver(fs64)
	:CPU
	-Geode NX 1750
	:memory
	-PC2100 512MB
	:main board
	-M7VIG Pro
	:SCSI controller
	-[DC-390U3W|
	http://www.tekram.com/product2/product_detail.asp?pid=43]
	:disk
	-Atlas 15k2 146GB
	-IDE 256GB+[AEC7726Q|
	http://www.unitycorp.co.jp/si/acard/bridge/bridge.html#aec7726q] x2
	:config
	-filsys main cw0f{w14w15}
	-filsys dump o

	=cpu+auth server
	:CPU
	-Intel Atom
	:memory
	-2GB
	:main board
	-[GA-GC330UD|
	http://www.mustardseed.co.jp/gigabyte/spec_gagc330ud.html]
	:NIC
	-rtl8139

	じつはこれ、NICを追加しなくても、
	カーネルにether8169を入れてあげれば
	オンボードのNIC(Realtek 8102e)を認識します。

	=old cpu+auth server
	:PC
	-[Sizka BASIC|
	http://www.pinon-pc.co.jp/products/sizka/classic/index.html]
	:memory
	-256MB
