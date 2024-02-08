---
title: git-split-diffsを使ってみた
style: ../../../styles/global.css
pre: ../../../layouts/notes/u.i
post: ../../../layouts/notes/nav.i
---

.revision
2021年5月19日作成
=git-split-diffsを使ってみた

:npm
-[git-split-diffs|https://www.npmjs.com/package/git-split-diffs]
:GitHub
-[banga/git-split-diffs|https://github.com/banga/git-split-diffs]

だいたい上記ドキュメントを読めば使える。全体的に良いんだけど、
日本語文字が入った行の末尾に謎の空白が入ったりなどがあって、
まだ常用は厳しいかなという雰囲気だった。

インストールは`npm`ですぐ終わる。

.console
!% npm i -g git-split-diffs

使うときは

.console
!% git diff | git-split-diffs --color

なんだけど、毎回このコマンド叩くのは面倒なので、configに入れておくと良い。

!% git config --global core.pager 'git-split-diffs --color'

見た目はテーマで設定ができる。個人的には*github-light*が好み。

!% git config --global split-diffs.theme-name github-light
