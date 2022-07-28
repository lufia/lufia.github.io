@include u.i
%title nftablesの導入

.revision
2022年7月29日作成
=nftablesの導入

公共のWi-Fiに繋ぐこともあるかもしれないので`nftables`を導入してみた。

.console
!$ sudo pacman -S nftables
!$ sudo systemctl enable --now nftables.service

インストールすると*/etc/nftables.conf*が用意されていて、
このファイルには受信したデータをdropするルールが定義されているので、
デスクトップLinuxとして使う限りは、困るまではこのまま使えばよいと思う。

*[nftables - ArchWiki|https://wiki.archlinux.jp/index.php/Nftables]

@include nav.i
