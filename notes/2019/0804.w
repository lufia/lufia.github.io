@include u.i
%title Android移行メモ

.revision
2019年8月4日作成
=Android移行メモ

	iPhone Xを落として画面を割ってしまって厳しいので、
	普段持ち運ぶ端末をPixel 3にしました。
	iPhone XもPixel 3も、どちらもSIMフリーの端末を使います。

	=移行前に注意が必要なところ

	LINEのバックアップは、異なるプラットフォーム間では引き継げません。
	LINEのトーク履歴などは、iPhoneではiCloud、
	AndroidではGoogle Driveにバックアップできます。
	ただし、AndroidからiCloudを参照したり、
	iPhoneからGoogle Driveにバックアップや復元することはできません。
	なのでトーク履歴の移行は諦める必要があります。

	*[機種変更時にLINEを引き継ぐ方法と注意点|
	https://begin-simfree.com/transfer-line-account-1690.html]

	AndroidからiCloudを参照できないのはサービスの特性から仕方ないとは思うものの、
	両プラットフォームからGoogle Driveを通してバックアップできて欲しいですね。

	=移行後にやったこと

	まずはAPNの設定をしないとモバイル回線に繋げないので設定します。
	ショップで端末の更新をする場合は、APNなどもおそらく店員さんが設定してくれますが、
	今回はもともとiPhoneで使っていたSIMをPixel 3に移し替えるので、自分でやります。

	+モバイルネットワークをタップ
	+詳細設定を展開する
	+アクセスポイント名をタップ

	これでAPNの画面が開くので、新しいAPNとして以下を追加します。

	:名前
	-softbank
	:APN
	-jpspir
	:ユーザー名
	-sirobit
	:パスワード
	-amstkoi
	:MMSC
	-https://mms/
	:MMSプロキシ
	-smilemms.softbank.ne.jp
	:MMSポート
	-8080
	:MCC
	-440
	:MNC
	-20
	:認証タイプ
	-PAPまたはCHAP
	:APNタイプ
	-default,mms,supl,hipri,fota,ims,cbs
	:APNプロトコル
	-IPv4/IPv6
	:APNローミングプロトコル
	-IPv4

	画面の流れなどは以下の記事に掲載されていました。

	*[iPhone用SIM（C2など）をAndroidスマホで使用する方法|
	https://usedoor.jp/howto/digital/android-smartphone/softbank-iphone-sim-apn-setting/]

	=他に設定したこと

	基本的にはデフォルトのまま使うので、設定したのはこの程度です。

	*通知設定で、「ロック画面上に、プライベートな内容を表示しない」へ変更
	*Digital Wellbeingでおやすみモードを設定
	*伏せるだけでサイレントモードをon

	他にも便利そうな設定があるので、必要な人は以下の記事を眺めてみると良いと思います。

	*[Pixel 4を買ったら設定しておきたい17のこと|
	https://mobilelaby.com/blog-entry-how-to-setup-pixel-3.html]

	この記事、2021年現在はPixel 4の記事だけど当時はPixel 3を対象としたものでした。

	=Androidの方が便利なところ

	*思っていたよりバックボタンは便利だった
	*異なるアプリ間でも、WebViewのログイン状態が残る
	*Face IDより指紋の方が全体的にはストレスがなかった
	*新しいWeb技術への対応が早い

	=移行した後に困ったところ 

	*Suicaアカウントを作らないと使えない
	*気に入った英和辞書アプリがない(物書堂アプリが欲しい)
	*Thingsアプリがない
	*汗をかいた場合など指紋認証が反応しなくて困る

@include nav.i
