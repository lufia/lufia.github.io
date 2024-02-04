---
title: 2chファイルサーバ
pre: ../include/u.i
post: ../include/nav.i
---

=monafs
	=SYNOPSIS
	!monafs [-dv] [-m mtpt] [-s srv]

	=OPTIONS
	:d
	-デバッグ文を有効にします。
	:m mtpt
	-mtptをマウントポイントとして使用します。
	-指定がなければ/n/2chを使います。
	:s srv
	-/srv以下にサービスファイルを作成します。
	:v
	-進行状況をstderrに書き出します。
	-デバッグ文とはまた違う出力になります。

	=INSTALL
	\[libkanji|http://lufia.org/plan9/src/libkanji.tgz]が必要です。
	あらかじめインストールしておいてください。
	または、monafsに付属する以下の関数をいじれば、libtcsでも大丈夫です。
	*util.c:sjistostring
	*util.c:Ufmt

	libtcs (半角カナ対応版)
	[http://c.p9c.info/plan9/]

	また、書き込み機能が必要な場合には、
	\[webfs(4)]をreferer送信に対応させることが必須です。
	同封のwebfs.diffを当てたものを作成しておいてください。

	.note
	これは古いです。おそらくパッチも当たらないでしょうし、
	当てたとしても2chの仕様も変わってしまったため、
	書き込みはできないと思われます。

	準備ができたら、
	!% mk
	!% mk install

	これで、$home/bin/$objtype以下にインストールされます。
	マウントポイントに/n/2chを使うので、
	なければそれも作っておいてください。

	!# 実際に作成する場合
	!% mkdir /n/2ch
	!% chgrp -u sys /n/2ch
	!
	!# 動的に生成する場合(こちらがおすすめ)
	!% mntgen

	=FILES
	マウント後のファイル構造は以下のようになっています。

	!category/ (1からn)
	!	subject
	!	board/ (例えばunix)
	!		ctl
	!		post
	!		subject
	!		thread/ (1029374722)
	!			ctl
	!			post
	!			subject
	!			article/ (1から1000)
	!				from
	!				mail
	!				date (YYYY/MM/DD HH:MM:SS)
	!				id
	!				be
	!				message

	これらは必ず作成されます。
	内容が無い場合は、空ファイルになっています。

	全てのsubjectと、from、articleの内容は、
	実体参照(例えば&lt;&gt;)や文字符号(&#1234;)が、
	通常の文字(例えば<<>>)へと変換されています。
	またmailの内容は、%HH形式の16進コードを
	それが対応する文字へと変換します。

	dateはタイムゾーンの設定によって変わってきますが、
	その値はどれも同じ時間を表します。
	例えばタイムゾーンをJSTに設定すれば、
	2ちゃんねるに表示される時間と同じ値になります。
	また、あぼーんや[[ここ壊れています]]の場合には、
	1970/01/01 09:00(time=0の時刻)となります。

	.note
	皇暦など、通常ではない時間の場合には不具合が出るかもしれません。

	ctlへrefreshと書くと、板またはスレッドを読みなおします。
	また、ctlを読むと、スレッドや板の詳細が入っています。
	共通して、文字の区切りはスペース(0x20)1つです。

		=board/ctl
		!host server.domain.dom

		その板のあるホスト名が入ります。

		=thread/ctl
		!rank XXXX
		!article XXXX

		rankはスレッド一覧の表示順位を持ちます。
		1が最新(上)で、順に下がっていきます。
		articleは、そのスレッドに書き込みされたレス数です。

		=thread/post

		ここへ書くと、それを書き込みとして処理します。

		!from:no name
		!mail:mail address
		!raw text...

		fromは書き込みした人の名前で、mailはメールアドレスです。
		from:またはmail:が先頭の行のみ、属性と認識されます。
		それ以外が現れた行以降は、ただのテキストと判断します。
		from,mailを省略すると、空文字列が補われます。

		=thread/post
		書き込みできる属性が見れます。
		acmeなどで開いて、そのまま使えます。

		!from:
		!mail:

		=board/post
		ほとんどthread/postと同じですが、
		属性にsubject:thread subjectが追加されています。

		日本語文字はUTF-8で書いてください。monafsが変換します。
		書き込みされた掲示板は、自動的にecho refresh >>ctlされます。

	=EXTRA
	rc/以下に、おまけのプログラムを用意してみました。
	詳しくはrc/READMEを読んでください。

	=BUGS
	まちBBSには対応してません。

	monafsのリリース以降、2chに仕様変更が起こったため
	現在おそらく書き込みできません。時間のあるときに修正します。

	バグなどはこちらまで <<lufia@lufia.org>>

	=TODO
		思いついたものを列挙してみました。

		=サーバに優しく
		*gzip圧縮に対応
		*If-Modified-Sinceで更新を調べる
		*差分だけ読み込む

		=仕様へ追いつく。
		*ID:xxxx BE:xxxx
		*subbbs.cgiの廃止

		=埋め込み設定を別ファイルにする。
		*実体参照テーブル
		*書き込み判定文字

		=外部板に対応
		*まちBBS
		*したらば、JBBS

		=ほか
		*●(有料)IDに対応
		*BEに対応。

.aside
{
	=関連リンク
	*[9ch(acme用2chブラウザ)|http://c.p9c.info/plan9/]
}
