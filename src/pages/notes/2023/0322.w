---
title: gdmに表示されるユーザーリストから特定のユーザーを削除したい
style: ../../../styles/global.css
pre: ../../../layouts/notes/u.i
post: ../../../layouts/notes/nav.i
---

.revision
2023年3月22日作成
=gdmに表示されるユーザーリストから特定のユーザーを削除したい

gdmでログインするとき、過去にログインしたユーザーなら一覧から選択できるようになっている。

ところで、一般のユーザーでログインできなくなった等の事情で*root*でログインした場合は、
このリストに*root*が残ってしまって見栄えがよくないので消したくなった。

このリストは*/var/lib/AccountService/users/*で管理されているらしいので、
ディレクトリ以下にあるユーザー名と同名のファイルを削除して再起動すればいい。

同様に、アイコンは*/var/lib/AccountService/icons*にある。
