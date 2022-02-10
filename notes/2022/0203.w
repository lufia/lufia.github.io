@include u.i
%title Linuxデスクトップのメンテナンス

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

	/var/log/journal

	=古いパッケージキャッシュの削除

	利用していないキャッシュの削除。

	!$ sudo pacman -Sc

	孤児パッケージの削除。

	!$ sudo pacman -Rs $(pacman -Qdt)

	Flatpakを利用している場合は不要になったランタイムも削除。

	!$ flatpak uninstall --unused

@include nav.i
