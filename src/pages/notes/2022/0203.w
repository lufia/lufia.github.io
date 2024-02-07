---
title: Linuxデスクトップのメンテナンス
style: ../../../styles/global.css
pre: ../../../layouts/notes/u.i
post: ../../../layouts/notes/nav.i
---

.revision
2022年2月3日作成
=Linuxデスクトップのメンテナンス

	Linuxデスクトップで日々のメンテナンスを行う。

	=各種アップデート

	!$ sudo pacman -Syu
	!$ flatpak update
	!$ fwupdmgr update

	=フォントキャッシュの更新

	!$ fc-cache -fv

	=古いログの削除

	.console
	!$ journalctl --disk-usage
	!
	!$ sudo journalctl --vacuum-size=200M
	!$ sudo journalctl --vacuum-time=30d

	ログ自体は*/var/log/journal*にある。

	=古いパッケージキャッシュの削除

	利用していないキャッシュの削除。

	!$ sudo pacman -Sc

	孤児パッケージの削除。

	!$ sudo pacman -Rns $(pacman -Qdtq)

	孤立したパッケージで必要なものを明示的にする、または依存にする。

	!$ sudo pacman -D --asexplicit <pkg>
	!$ sudo pacman -D --asdeps <pkg>

	Flatpakを利用している場合は不要になったランタイムも削除。

	!$ flatpak uninstall --unused

	=Borg backup

	古いバックアップを破棄する方法は以下の記事に書いた。

	*[12インチMacBookにArch Linuxをインストールした|
	https://blog.lufia.org/entry/2021/04/05/170000]
