---
title: debパッケージのマルチアーキテクチャ
style: ../../../styles/global.css
pre: ../include/u.i
post: ../include/nav.i
---

.revision
2023年4月2日作成
=debパッケージのマルチアーキテクチャ

	=使い方

	debパッケージはマルチアーキテクチャをサポートしている。
	デフォルトではホストネイティブなアーキテクチャしか有効になっていないので、
	以下のコマンドで必要なアーキテクチャを有効にする。

	.console
	!$ sudo dpkg --add-architecture arm64

	有効になったか調べる場合も*dpkg*コマンドで行う。

	.console
	!$ dpkg-architecture --list
	!$ dpkg --print-foreign-architectures
	!arm64

	上記ではarm64サポートを追加しているので、
	以降、arm64パッケージをインストールできるようになる。
	パッケージ名の末尾に、*:*で区切ってアーキテクチャ名を指定する。

	.console
	!$ sudo apt-get install git:arm64
	!
	!# またはdpkgを使う場合
	!$ sudo dpkg -i git_arm64.deb

	有効にしたアーキテクチャが不要になった場合は以下のコマンドで無効化する。

	.console
	!$ sudo dpkg --remove-architecture arm64

	*[Debian管理者ハンドブック/dpkg を用いたパッケージの操作|
	https://debian-handbook.info/browse/ja-JP/stable/sect.manipulating-packages-with-dpkg.html]

	=Armアーキテクチャの名前

		OSやコンパイラなど、状況によって色々な名前がある。

		=ハードウェア仕様に由来するもの

		:armel
		-末尾の*el*はEnhanced ABI as little-endianのこと
		-32bitアーキテクチャ
		-CPUの世代はARMv4
		:armeb
		-末尾の*b*はbig-endianのこと
		-あとは*armel*と同じ
		:armhf
		-末尾の*hf*はHardware Floatingのこと
		-32bitアーキテクチャ
		-CPUの世代はARMv7

		古いDebianのパッケージでは、この命名を採用している。

		=CPUの世代に由来するもの

		*armv7l
		-末尾の*l*はlittle-endianのこと
		-32bitアーキテクチャ
		*armv8l
		-末尾の*l*はlittle-endianのこと
		-64bitアーキテクチャ

		Raspberry Pi関連のパッケージではこの命名を採用している。

		=アーキテクチャに由来するもの

		*arm
		-32bitアーキテクチャ
		-A32命令セット
		*arm64
		-64bitアーキテクチャ
		-A64命令セット
		-ARMv8-A以降のCPUで利用可能

		Plan 9、Linux、Go言語ではこの命名を採用している。
		Debianも64bitのArmパッケージでは*arm64*を使っている。

		=実行モード(命令セット)に由来するもの

		*aarch32
		-32bitアーキテクチャ
		-A32命令セット
		*aarch64
		-64bitアーキテクチャ
		-A64命令セット
		-ARMv8以降のCPUで利用可能

		GCCやRHEL系パッケージではこの命名を採用している。

		=ARM? Arm?

		公式のTermsでは、社名は*Arm*表記だった。
		CPUはv7までがARM表記で、v8以降はArmだろうか。

.aside
{
	*[armv7とarm64とarmhfの違い|https://teratail.com/questions/190228]
	*[armhf|https://wiki.onakasuita.org/pukiwiki/?armhf]
	*[EABIとOABI|https://sites.google.com/a/oidon.net/www/linux/arm-eabi-oabi]
	*[サポートするハードウェア|
	https://www.debian.org/releases/stable/arm64/ch02s01.ja.html]
}
