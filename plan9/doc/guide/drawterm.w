@include u.i
%title drawterm

.revision
2009年11月4日更新
=drawterm

	=使い方

	.sh
	!drawterm -a authsrv -c cpusrv

	その他のオプションは[drawterm(8)]。

	=ポート

	drawtermで使うポートは、古いバージョンと
	drawterm2000以降では異なります。
	従来のバージョンでは、tcp567とtcp17013を使っていましたが、
	現在はtcp567とtcp17010を利用します。

	=日本語入力

	Windows版のdrawterm2000は、
	IMEから入力すると文字化けを起こしていましたが、
	2009年9月現在の最新版では、特に問題なく入力可能です。

	Mac版では、Carbon/X11共に使えていません。
	そのため、Plan 9からktransやskkを使うしかありません。

	=ローカルファイルの参照

	drawtermは、ベースとなっているcpuと同じように、
	ローカルファイルを/mnt/termから参照できます。
	ただし、Windows版drawtermの最新版では、
	ファイルのリストが取れません。読み書きはできるので、
	ローカルからファイルサーバにコピーなんてことはできます。

	不思議なことに、前バージョンのdrawterm2000では
	ファイルのリストが取れます。何か問題があったのでしょうか。

	=DrawtermのApp化

	MacでDockに登録するために、[Drawterm.app|
	http://d.hatena.ne.jp/oraccha/20080209/1202565776]を
	参考にしたのですが、なぜかこのままでは動きませんでした。
	具体的に言えば、Carbon/X11共に、パスワードを入力した直後、
	mountとbindがエラーになってしまいます。

	!secstore password:
	!usage: mount [-a|-b] [-cnq] [-k keypattern] /srv/service dir [spec]
	!usage: bind [-b|-a|-c|-bc|-ac] new old
	!usage: bind [-b|-a|-c|-bc|-ac] new old
	!usage: bind [-b|-a|-c|-bc|-ac] new old
	!mount: can't open /srv/net: '/srv/net' file does not exist
	!/lib/namespace.local: rc: .: can't open: '/lib/namespace.local' does not exist

	ターミナルからcore.shを実行させた場合は問題ありませんが、
	Drawterm.appをダブルクリックした場合に限り、このエラーになります。
	環境の問題なのでしょうか。Leopard, Snow Leopard共にだめでした。

	そこで、core.shを以下のように書き換えました。

	.sh
	!#!/bin/sh
	!
	!cd ~ && /Applications/Drawterm.app/Contents/MacOS/drawterm -a auth -c cpu &
	!exit 0

.aside
{
	=参考ページ
	*[Drawterm|http://swtch.com/drawterm/]
	*[Plan 9初心者ガイド - Plan9日記|
	http://d.hatena.ne.jp/oraccha/20090211/1234354600]
}

@include nav.i
