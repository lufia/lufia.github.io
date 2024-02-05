---
title: ファイルサーバSCSI化(2)
style: ../../../styles/global.css
pre: ../include/u.i
post: ../include/nav.i
---

.revision
2007年6月3日作成
=ファイルサーバSCSI化(2)

	販売店から連絡があって、Rev 1.4は生産停止で在庫も無い状態だそうです。
	で、Rev 3.1は、ピン配置が変わってまして。
	また、電力も変わってるので、FDD電源でサポートしてください、
	とのことです。

	=AEC7726Qのピン配置図
	!ピン左	ピン右	Rev 1.4	Rev 3.1
	!1	2	1	1
	!3	4	2	2
	!5	6	4	4
	!7	8	8	8
	!9	10	RES	LED
	!11	12	RES	なし
	!13	14	LED	なし

	ふうん、、RESが無くなっただけなのか。
	きちんと認識されました。
	FDD電源挿し忘れてたかなあ。。

	これで、ファイルサーバはこんな感じ。
	w0は本物のSCSIディスクです。ちょっと様子見。
	!config w0
	!service dryad
	!ip xxx.xxx.xxx.xxx
	!ipgw xxx.xxx.xxx.xxx
	!ipsntp xxx.xxx.xxx.xxx
	!ipmask xxx.xxx.xxx.xxx
	!filsys main cw0f{w14w15}
	!filsys dump o
