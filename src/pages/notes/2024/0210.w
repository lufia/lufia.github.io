---
title: difftasticを使ってみた
style: ../../../styles/global.css
pre: ../../../layouts/notes/u.i
post: ../../../layouts/notes/nav.i
---

.revision
2024年2月10日作成
=difftasticを使ってみた

:crates.io
-[difftastic|https://crates.io/crates/difftastic]
:GitHub
-[Wilfred/difftastic|https://github.com/Wilfred/difftastic]

GitHub UIのように、左右に差分を並べて表示してくれる[difftastic|
https://difftastic.wilfred.me.uk/]というツールを知りました。
GitHub Release上では2022年4月にv0.26.1がリリースされているので、
ツール自体はだいぶ前から開発されていたようですね。

普段Arch Linuxを使っているのですが、*difftastic*はArchパッケージにあるので、
単に`pacman`でインストールするのが簡単です。

.console
!$ sudo pacman -S difftastic

Gitの[外部diffツールとして使う|
https://difftastic.wilfred.me.uk/git.html]場合は、環境変数などに設定します。

.console
!$ export GIT_EXTERNAL_DIFF=difft
!
!$ git diff
!$ git show --ext-diff

以前[git-split-diffsを使ってみた|../2021/0519.w]ときは、
比較するファイルに日本語文字が含まれていると出力が壊れてしまいましたが、
そういう問題は今のところ見当りません。

\<0210.png>

.aside
{
	=関連記事
	*[git-split-diffsを使ってみた|../2021/0519.w]
}
