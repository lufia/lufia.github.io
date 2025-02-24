---
title: Goのbootstrapバージョン
style: ../../../styles/global.css
pre: ../../../layouts/notes/u.i
post: ../../../layouts/notes/nav.i
---

.revision
2024年3月23日作成
=Goのbootstrapバージョン

Go 1.5(2015年8月!)から、Goコンパイラ自体もGoで実装されるようになった。
このとき、最初にGoをビルドするためのコンパイラをどこから持ってくるかだけども、
Go 1.4のGoコンパイラで新しいバージョンの*go_bootstrap*をビルドして、
あとは*go_bootstrap*を使ってビルドしていく方法になった。

Go 1.4のツールチェーンが置かれるディレクトリは*go1.4*と決められているが、
変更するときは`GOROOT_BOOTSTRAP`環境変数で指定できる。
基本的に1.4以上であれば、新しいものを使う限りは問題ない。

Go 1.20で、*go_bootstrap*をビルドするためのバージョンがGo 1.17まで上がった。
それ以降は2つ前のバージョンが使われるようになったらしい。

*[Install Go compiler binaries for bootstrap|
https://go.dev/doc/install/source#go14]
*[build: adopt Go 1.20 as bootstrap toolchain for Go 1.22|
https://github.com/golang/go/issues/54265]
