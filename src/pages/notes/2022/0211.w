---
title: Linuxのパッケージ管理システム
pre: ../include/u.i
post: ../include/nav.i
---

.revision
2022年2月11日作成
=Linuxのパッケージ管理システム

	各ディストリビューションで採用されている*RPM*や*deb*などの他にも、
	ディストリビューションに依存しない管理システムもある。

	=Flatpak

	主にデスクトップアプリケーションやテーマの配布で使われる。
	コマンドなども配布はできるが、

	.console
	!$ flatpak run com.example.app

	のように長いコマンドを入力する必要があるので、あまり適切ではない。

	アプリケーションの配布は主に[Flathub|https://flathub.org/]で行われる。

	=Snappy

	デスクトップアプリケーションやコマンドなど色々なプログラムを配布できる。
	利用するためには`snapd`と呼ばれるデーモンが動作している必要がある。

	アプリケーションの配布は[Snapcraft|https://snapcraft.io/]で行われる。

	=AppImage

	上の2つと異なり、これは単にパッケージのフォーマットを意味するらしい。
	\[LinuxでAppImage形式のアプリを使う方法と注意点のまとめ|
	https://www.virment.com/how-to-use-appimage-linux/]によると、
	AppImage形式のファイルに権限を与えて実行するだけで使えるようだけど、
	配布されているものを見たことがないので、手元で試してはいない。
