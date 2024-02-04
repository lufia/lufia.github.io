---
title: GitHub Projects(classic)を移行した
pre: ../include/u.i
post: ../include/nav.i
---

.revision
2022年7月29日作成
=GitHub Projects(classic)を移行した

新しいProjectsが正式リリースされたので、
これまで利用していたGitHub Projects(classic)を新しいProjectsに移行した。

やることはとても単純で、公式に用意されている移行ツールを使うだけなのだけども、
2022年7月時点ではまだ移行ツールはPreviewリリースなので、まずは有効にする必要がある。

+プレビュー版の*Project migration*を有効にする
+プロジェクトごとに*Migrate*を実行していく

これだけで完了する。

*[Migrating from projects(classic) - GitHub Docs|
https://docs.github.com/issues/planning-and-tracking-with-projects/creating-projects/migrating-from-projects-classic]

ところで、移行後に気づいたものでは、

*カードの並びは維持されない
*NoteにMarkdownやissueへのリンクなどを書いても認識されない

といった違いはある。
