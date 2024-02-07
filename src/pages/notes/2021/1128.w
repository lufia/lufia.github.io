---
title: 最近のタスク管理
style: ../../../styles/global.css
pre: ../../../layouts/notes/u.i
post: ../../../layouts/notes/nav.i
---

.revision
2021年11月28日作成
=最近のタスク管理

	やりたいことが多くなったのでプライベート活動のタスク管理をはじめた。

	以前は専用のタスク管理ツールを使っていたが、
	ソースコードを扱う場合など最終的にGitHubを使うことが多く、
	管理が二度手間になって面倒になったので、GitHubにまとめるようにした。

	GitHubのモバイルWeb版でもプロジェクトにアクセスできるので外出中でも困らない。

	=GitHub Projectsを使っている

	GitHub Projectsはユーザー、リポジトリ、組織のどこにでも作成できる。
	プライベート活動のタスクをまとめて扱いたいので、
	ユーザーの直下にプロジェクトを作成して、頻繁に利用するリポジトリをリンクした。
	リンクすると、GitHub Projectsの機能により、新規追加したイシューを自動的に
	プロジェクトへ登録したりなど、ある程度の自動化ができるようになる。

	頻繁に使わないリポジトリにはリンクしていないが、
	リンクしていなくても*Only show results from linked repositories*のチェックを
	外せば登録できるので、頻度が少なければ問題にはならないと思う。

	以下のように、よくある列(Column)を作っている。

	*Inbox
	*Next Action
	*Projects
	*@Agendas
	*@Errands
	*Waiting for ...
	*Someday
	*Done

	カレンダーはGoogle Calendarを使うので列としては用意していない。

	具体的には、新しくタスクを追加する場合は*Inbox*にノート(Note)を作成する。
	ここに手間がかかると登録しなくなって破綻するので、後から思い出せるなら雑でもいい。
	実はノートにはMarkdownが書けるし、イシューなどのURLを書くと内容を展開してくれるので、
	例えば「靴を洗う」のような簡単なものならノートのまま扱うこともある。

	タスクに関するメモなどを残したくなったら、*Convert to issue*でノートを変換する。
	イシューへ変換する際には、どのリポジトリに作成するか選ぶことになるが、
	公開したくないものは当然ある。そういったイシューのために、
	タスク管理用のプライベートなリポジトリを用意している。

	=複雑なタスクの扱い

	完了までに複数の手順が必要な大きいタスクは、イシューの中に

	!- [x] todo1
	!- [ ] todo2
	!- [ ] todo3

	のようにチェックリストを用意する。
	これでもまだサブタスクが大きい場合は、それぞれのサブタスクをイシューに変換する。
	チェックリストの上をマウスでホバーすると、*Convert to issue*ボタンが表示されるので、
	実行すればチェックリストのイシューを作成して置き替えできる。
	例えば上の*todo2*を*Convert to issue*した場合、*todo2*というイシューが作られて、
	チェックリストは`- [[ ]] #20`のようなイシュー番号に変換される。

	=便利なこと

	旅行準備チェックリストなどを*.github/ISSUE_TEMPLATE*で作っておくと便利だった。
