---
title: incall queue full
pre: ../include/u.i
post: ../include/nav.i
---

.revision
2011年6月10日作成
=incall queue full

コンソールに警告が出ていた。

!Fsnewcall: incall queue full (10) on port 80

このメッセージはカーネルのip/devip.c:Fsnewcallに書かれています。
で、どういうときに出てくるのかというと、
listen待ちリスト(Conv.incall)に入っているリクエストが
Maxincallを超えたときに出るものみたい。
