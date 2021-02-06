@include u.i
%title ASP.NET Ajaxのメモ

.revision
2007年11月8日作成
=ASP.NET Ajaxのメモ

	2007年2月頃、機会があったので遊んでみました。
	一部、Ajaxに限定しないものも含みます。
	HTMLのソースはとんでもないですが、
	こういうのもなかなか便利なものですね。

	=GridViewの不思議
	nullの場合に表示するテキストを設定するNullDisplayTextは、
	テンプレート化したカラムには存在しない。
	テンプレートになったものはそれで対応しろということなのかな。

	=変数の寿命
	たとえUpdatePanelで部分更新するとしても、
	クラス変数はPostBackが起こった時点ですべてリセットされる。

	このため、PostBack以後も永続的に保持したい場合は、
	なんらかのコントロールにEnableViewStateを設定し、
	そこに格納するといい。

	=仮想パスにはマルチバイト文字を書いてはいけない
	たぶん、Visual Studioの問題。
	webサイトの仮想パスに日本語文字などを書くと、
	Ajaxイベントに入ったところでunknown errorのアラートが出る。

	=PopupControlExtender問題
	PopupControlExtenderの中で部分更新を行う場合、
	ポップアップさせるPanelの中にUpdatePanelを起く必要がある。
	逆にした場合、JavaScriptエラー"behaviorなんたら"が出る。
	当然といえば当然なんですけどね。

	=TextBoxWatermark問題
	TextBoxに手で入力すれば通常どおり扱われるが、
	代入式などで入力したものが消えてしまう現象が起こる。

	おそらくTextBoxWatermarkがキーボードイベントをみていて、
	イベントが起こるまで未入力扱いになるため、
	何を代入しても無効になってしまうのではないかと。

	プログラムからの入力設定の可能性があるTextBoxには、
	TextBoxWatermarkExtenderは使わないこと。

	=デバッグ
	*[Internet ExplorerでJavaScriptエラーをデバッグする方法|
	http://labs.gmo.jp/blog/ku/2007/03/iejavascript.html]

	Officeに附属するスクリプトエディタをインストールして、
	IEでスクリプトのデバッグを有効にすればデバッグできるみたい。

@include nav.i
