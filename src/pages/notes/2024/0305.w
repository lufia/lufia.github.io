---
title: Arch Linuxのアップデートでlibblockdevが競合する
style: ../../../styles/global.css
pre: ../../../layouts/notes/u.i
post: ../../../layouts/notes/nav.i
---

.revision
2024年3月5日作成
=Arch Linuxのアップデートでlibblockdevが競合する

Arch Linuxの更新をしようとしたところ、以下のようなエラーで停止しました。

.console
!$ sudo pacman -Syu
!error: unresolvable package conflicts detected
!error: failed to prepare transaction (conflicting dependencies)

どうやら、*udisks2-2.10.1-3*には依存パッケージとして*libblockdev*と*libblockdev-utils*が
入っているけれども、いつ頃からか、これらのパッケージが競合するようになったようでした。

競合しているなら、どちらかを外さなければいけません。
そこで、どちらを残すのが正しいのか調べるため*udisks2*の差分をみると、

.diff
!--- /home/lufia/usidks2-2.10.1-3	2024-02-23 00:11:57.000000000 +0900
!+++ /home/lufia/udisks2-2.10.1-4	2024-03-02 05:02:17.000000000 +0900
!@@ -2,10 +2,10 @@
! # using fakeroot version 1.33
! pkgname = udisks2
! pkgbase = udisks2
!-pkgver = 2.10.1-3
!+pkgver = 2.10.1-4
! pkgdesc = Daemon, tools and libraries to access and manipulate disks, storage devices and technologies
! url = https://www.freedesktop.org/wiki/Software/udisks/
!-builddate = 1708614717
!+builddate = 1709323337
! packager = David Runge <dvzrv@archlinux.org>
! size = 15273052
! arch = x86_64
!@@ -25,6 +25,7 @@
! depend = glibc
! depend = libatasmart
! depend = libblockdev
!+depend = libbd_utils.so=3-64
! depend = libblockdev.so=3-64
! depend = libblockdev-crypto
! depend = libblockdev-fs
!@@ -33,8 +34,6 @@
! depend = libblockdev-nvme
! depend = libblockdev-part
! depend = libblockdev-swap
!-depend = libblockdev-utils
!-depend = libbd_utils.so=3-64
! depend = libgudev
! depend = libgudev-1.0.so=0-64
! depend = polkit
!@@ -73,7 +72,6 @@
! makedepend = libblockdev-nvme
! makedepend = libblockdev-part
! makedepend = libblockdev-swap
!-makedepend = libblockdev-utils
! makedepend = libgudev
! makedepend = lvm2
! makedepend = polkit

のように、*libblockdev-utils*の方が依存パッケージから消えていたので、
アップデートの前に強制削除してから更新を実施しました。

.console
!$ sudo pacman -Rdd libblockdev-utils
!$ sudo pacman -Syu

他にも、公式フォーラムによると、更新するとき*libblockdev-utils*を無視する方法もあるようですね。

.console
!$ sudo pacman -Syu --ignore libblockdev-utils

*[Cannot replace libblockdev-utils with libblockdev / Arch Linux Forums|
https://bbs.archlinux.org/viewtopic.php?id=293397]
