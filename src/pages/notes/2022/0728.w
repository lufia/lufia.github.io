---
title: nftablesの導入
style: ../../../styles/global.css
pre: ../include/u.i
post: ../include/nav.i
---

.revision
2022年8月12日更新
=nftablesの導入

公共のWi-Fiに繋ぐこともあるかもしれないので`nftables`を導入してみた。

.console
!$ sudo pacman -S nftables
!$ sudo systemctl enable --now nftables.service

インストールすると*/etc/nftables.conf*が用意されていて、
このファイルには受信したデータをdropするルールが定義されているので、
デスクトップLinuxとして使う限りは、困るまではこのまま使えばよいと思う。

*[nftables - ArchWiki|https://wiki.archlinux.jp/index.php/Nftables]

Dockerを使う場合、*docker0*のパケットがdropされて困る。
最も容易な解決方法は*nftables*のルールを消してdropしないように変更する。

.console
!$ sudo nft flush ruleset

だけどもあまりに雑なので、以下どちらかの方法で対応するのがいいと思う。

:[nftables - ArchWiki|https://wiki.archlinux.org/title/nftables]のWorking with Docker
-こちらの方が新しい手法の雰囲気がある
:[nftablesでdockerを使ってみました|https://ny-a.github.io/blog2/2020-02/nftables-with-docker/]
-*iptables-nft*を使う方法
