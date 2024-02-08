---
title: Mac移行まとめ
style: ../../../styles/global.css
pre: ../../../layouts/notes/u.i
post: ../../../layouts/notes/nav.i
---

.revision
2009年12月23日作成
=Mac移行まとめ

Macbook Airを買ってからおよそ1年経ったので、
とりあえずまとめを書いておこうかなあ、と。

	=Finderのフォルダ名翻訳
	Documentsなどの中に、.localizedという空のファイルを作れば
	書類などに翻訳されます。~/Applications/.localizedを作った。

	=Mail.app
		=証明書
		Mail.appを立ち上げるときに、自己証明書であれば警告が表示されます。
		ここで、証明書を表示させるとオプションがあったので、
		Plan9 SMTP/IMAPサーバで利用している証明書を常に信頼とした。

		=メールアドレスのエイリアス
		各アカウントのメールアドレス欄に、
		カンマで区切ってa@domain.dom, b@domain.domと書くと、
		メール作成時にどのアドレスを使うか選べるようになります。

	=ことえり
	Snow Leopardになってから、カタカナもトグルするようになりました。
	command+spaceを押してすぐ離すと、
	ひらがなと英字を交互に切り替えられるのですが、
	たまにcommandを長く押していたりすると、
	意図しないでカタカナになってしまい不便でした。

	システム環境設定→言語とテキスト→入力ソースを開き、
	ここからカタカナのチェックを外すと切り替え候補から外れてくれます。

	=DVDのバックアップ
	アプリケーションの中、ディスクユーティリティを使って
	データディスクのバックアップが取れます。
	ふつうにディスクを入れて使うだけなのですが、
	めんどくさいことに、バックアップを開始する前に
	マウント解除しておかないと、ディスクユーティリティが応答しなくなり、
	強制終了するしかなくなってしまいます。

	=クラムシェルモード
	Appleの[サポート情報|
	http://support.apple.com/kb/HT1308?viewlocale=ja_JP]より。
	ふたを閉じて外部ディスプレイを使うモードです。
	リッドクローズドモードとも呼ぶらしい。

	=バッテリーの調整
	これも[サポート情報|
	http://support.apple.com/kb/HT1490?viewlocale=ja_JP]から。
	フル充電してから、バッテリを空まで放電すればいいらしいです。

	=Spotlightコメント
	Snow Leopardになってから、
	Spotlightコメントの入力用Automatorが使えなくなりました。
	さてさて、どうしよう。

	=インストールしたもの
		=Drawterm
		Dockに登録しました。[Plan 9: Drawterm|
		../../plan9/doc/guide/drawterm.w]も参照。

		=Xcode Tools
		OSXのDVDに入っています。

		=Microsoft Messenger
		非公式のクライアントもあるようですが、公式のほうを[Mactopia|
		http://www.microsoft.com/Japan/mac/default.mspx]から
		ダウンロード。

		Documents以下に「Microsoftユーザデータ」が無い場合、
		表示アイコンが設定できないのですが、
		いちど会話ログを保存すれば自動で作ってくれます。
		アイコン設定時にも自動で作ればいいのにと思うのですが。不思議。

		=Windows 7
		BootCampで入れました。
		詳細は[Macbook AirでWindows7|1206.w]。

		=plan9port
		Xcode Toolsをインストールしてから。

		+~/plan9以下で、./INSTALLを実行。
		+~/.profileに環境変数PLAN9, PATH, NAMESPACEを設定。
		+$PLAN9/ndb/localに、authdom=mana.lufia.orgを追加。

		=HHKPS2USBDriver
		PS2のHHKをUSBに変換すると、
		commandキーが'a'になってしまいます。
		リッドクローズドモードのときに不便なので、[HHKPS2USBDriver|
		http://ichiro.nnip.org/osx/HHKPS2USBDriver/]を導入。

		SW-KVM4LPを使っているので、マニュアルの通りに調べて、
		以下の内容をHHKPS2USBDriverのInfo.plistに追加。

		.xml
		!<key>HHK via SANWA SW-KVM4LP</key>
		!<dict>
		!	<key>CFBundleIdentifier</key>
		!	<string>org.nnip.driver.HHKPS2USBDriver</string>
		!	<key>HIDDefaultBehavior</key>
		!	<string></string>
		!	<key>IOClass</key>
		!	<string>HHKPS2USBDriver</string>
		!	<key>IOProviderClass</key>
		!	<string>IOUSBInterface</string>
		!	<key>bConfigurationValue</key>
		!	<integer>1</integer>
		!	<key>bInterfaceNumber</key>
		!	<integer>0</integer>
		!	<key>idProduct</key>
		!	<integer>517</integer>
		!	<key>idVendor</key>
		!	<integer>2689</integer>
		!</dict>

		追加を終えたら、カーネルエクステンションの場所に置いて再起動。

		!/System/Library/Extensions/HHKPS2USBDriver.kext

		=Books for Mac OS Xの不満点
		*著者カテゴリが無い(すべてフラット)
		*文字列ソートなので、10巻が2巻より上にくる

		=Parallels Desktop 4
		Windows 2000を入れてゲームで遊んでみましたが、
		USBゲームパッド(サターンパッド)が認識しなかったので削除。

		ラネクシーのサイトより、[クリーンアンインストール|
		http://www.runexyfaq.com/parallels4.0/parallels_desktop_40_for_mac_5.html]のとおり実行。

		=MacFUSEのアンインストール
		Parallelsに付いてきましたが、いらないので。

		まずは、MacFUSEをアンインストール。
		システム環境設定からでもいいし、
		/Library/System/Filesystems/fusefs.fs/Support/uninstall
		なんたらを実行してもいいです。

		このままだとシステム環境設定にメニューが残り続けるので、
		/Library/PreferencePanes/MacFUSE.prefPaneを削除。
		で、/Library/Receipts/以下のFUSEと付くものも全部消して、
		Receipts/InstallHistory.plistからも消す。

.aside
{
	=関連情報
	*[HHKBを快適に使う|../2015/0718.w]
}
