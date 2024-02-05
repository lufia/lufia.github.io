---
title: ハードウェア
style: ../../../../styles/global.css
pre: ../../include/u.i
post: ../../include/nav.i
---

.revision
2009年9月6日更新
=ハードウェア

	これまでに遭遇したハードウェアがらみの問題を記録しています。

	=ファイルサーバ

		=HDD

		ATAやSATAディスクでRAIDを構成すると、
		よくわからないエラーに悩まされます。
		例えばfilsys main ch0f{h2h3}のように構成すると、
		不定期に以下のエラーが発生し、データが壊れます。

		!mirrwrite $dev error at block $addr

		!cannot open /adm/users

		!cwio: write induced dump error - r cache

		IDEコントローラを換えても、コントローラ1つにつきHDD1台としても、
		何をやっても変わらなかったので、使わないほうが無難だと思います。

		=KVM

		Princetonの[PKV-PPA2|
		http://www.princeton.co.jp/product/kvm/pkv/pkvppa2.html]は、
		ファイルサーバコンソール状態で切り換えたときに、
		キーボードを認識しなくなる現象が起こりました。
		configモードや他のCPUサーバコンソール等は問題なく使えるのに。。。

		仕方がないのでSANWAの[SW-KVM4LP|
		http://www.sanwa.co.jp/product/syohin.asp?code=SW-KVM4LP]
		に交換したところ、無事に認識されています。
		PKV-PPA2はエミュレーションがうまく働いてない？

.aside
{
	=参考ページ
	*[Supported PC Hardware|
	https://9p.io/wiki/plan9/Supported_PC_hardware/index.html]
}
