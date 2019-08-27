@include u.i
%title Macbook AirでWindows7

=Macbook AirでWindows7
.revision
2009年12月6日作成

	Macbook Air(OSX10.6)にWindows 7をインストールしてみました。

	アプリケーション→ユーティリティの、
	Boot CampアシスタントでWindows用に20GB確保。
	あとは指示どおりにインストールを開始します。
	今にして思えば、Win7 64bitはインストール直後で10Gほど使用するので、
	デフォルトの32Gにしておけばよかったかなあ。

	=パーティションのフォーマット
	Windows 7は、NTFSフォーマットされた
	パーティションにしかインストールできません。
	このため、Boot Campアシスタントで作ったパーティションを
	NTFSでフォーマットし直します。
	パーティションを作り直すとだめらしいので注意。
	あとは普通にインストールを続けて、2回ほど再起動すれば完了。

	=ドライバのインストール
	ログイン直後は、ドライバがそろっていないので
	Snow Leopardのディスクからインストールします。

	このとき、setup.exeを実行すると、64bit未対応というエラーになりますが、
	これはsetup.exeが意地悪しているだけなので、
	bootcamp64.msiを*管理者モードで*実行すればいいです。

	!d:¥boot camp¥drivers¥apple¥bootcamp64.msi

	管理者モードでの実行方法なのですが、
	Win7からは「管理者として実行」メニューが表示されていないので、
	非常にまわりくどい手順を踏むはめになりました。

	+アクセサリのコマンドプロンプトを実行してすぐ閉じる
	+スタートメニューに「コマンドプロンプト」が現れるので右クリック
	+管理者モードのプロンプトから上記のbootcamp64.msiを実行

	.note
	右クリックが使えない場合、shift+fn+F10で代用可能です。

	これで、一通りの環境が整います。

	=Windowsの起動方法
	Optionキーを押しながらブート。

	=トラブルとその解決
		=無線に繋がらない
		SSIDを見えなくしている場合、
		コントロールパネルにある、
		ネットワーク共有センター→ワイヤレスネットワークの管理で
		追加しなければならない。分かりにくい。

		=bluetoothマウスが認識しない
		接続しています、で止まる場合、
		いちど、Macのほうからシステム設定→bluetoothを開いて登録解除、
		そのままwinから認識させれば動いた。

		何が原因？よくわからない

		=トラックパッドがスクロールしか認識しない
		コントロールパネルの、
		システムとセキュリティ→bootcampに設定がある。
		デフォルトではほとんど無効なので全部にチェックを入れた。

		=Windowsでクラムシェルモード
		ふつうに外部ディスプレイを繋げば動く。
		ただし、不定期にスリープモードに入ってしまうことがある。
		スリープしない設定にしているのに。なぜ？

		=メモリが足りない
		Airは2Gしかメモリを塔載していませんので、
		ゲームなどを動かすと、それなりにしんどいです。
		Windows 7にSecurity Essentialsを入れただけで、
		メモリを600Mほど使いますし。

		*デスクトップテーマをクラシックに変更
		*Superfetchサービスを無効にする

		これでずいぶん改善されるはず。

		=MacからWindowsのディスクに書き込めない
		NTFSフォーマットでは、通常読むだけしかできませんが、
		/etc/fstabを作ると書き込みもできるらしいです。
		詳しくは[知られざるSnow Leopard(NTFS編)|
		http://journal.mycom.co.jp/column/osx/342/index.html]に。

		=WindowsからMacの個人フォルダを見るとファイルが無い
		フォルダに.XAuthorityがあると、見えなくなるようです。

@include nav.i
