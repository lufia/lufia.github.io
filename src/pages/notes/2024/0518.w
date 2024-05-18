---
title: /etc/machine-infoは不要になっていた
style: ../../../styles/global.css
pre: ../../../layouts/notes/u.i
post: ../../../layouts/notes/nav.i
---

.revision
2024年5月18日作成
=/etc/machine-infoは不要になっていた

Arch Linuxでパッケージを更新したとき、以下のメッセージが出力されていた。

>Read $KERNEL_INSTALL_LAYOUT from /etc/machine-info.
>Please move it to the layout= setting of /etc/kernel/install.conf.

以前は*/etc/machine-info*から

*`KERNEL_INSTALL_MACHINE_ID`
*`KERNEL_INSTALL_LAYOUT`

などのパラメータを読んでいたらしいが、
[bootctl complaining about $KERNEL_INSTALL_LAYOUT|
https://www.reddit.com/r/archlinux/comments/uxfu78/bootctl_complaining_about_kernel_install_layout/]によると
今はカーネルパラメータなど別の方法に変わったらしい。

*[KERNEL_INSTALL_MACHINE_ID in /etc/machine-info should be revisited|
https://github.com/systemd/systemd/issues/22376]

どのパッケージも管理していないことを確認した。

.console
!$ pacman -Qo /etc/machine-info
!error: No package owns /etc/machine-info

手元の*/etc/machine-info*をみたが、デフォルト値なので安全に削除できる。

.ini
!KERNEL_INSTALL_LAYOUT=bls
