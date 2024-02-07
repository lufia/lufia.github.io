---
title: GitHubのリッチなタスクリスト
style: ../../../styles/global.css
pre: ../../../layouts/notes/u.i
post: ../../../layouts/notes/nav.i
---

.revision
2023年2月6日作成
=GitHubのリッチなタスクリスト

これまでも以下のように書けばタスクリストを作成できていた。

.markdown
!- [x] task1
!- [ ] task2

もう少しリッチなタスクリストが追加されていた。
これはMarkdownのコードとしてタスクを表現する。

.markdown
!```[tasklist]
!# Section
!- [x] task1
!- [ ] task2
!```

この書き方では、表示がリッチになっており、タスクの追加などをUI上からできる。

*[About Tasklists|https://docs.github.com/en/issues/tracking-your-work-with-issues/about-tasklists]
