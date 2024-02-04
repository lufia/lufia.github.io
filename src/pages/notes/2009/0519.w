---
title: GENOウイルス
pre: ../include/u.i
post: ../include/nav.i
---

.revision
2009年5月19日作成
=GENOウイルス

	=怖いね
	Adobe製品の脆弱性により、
	ブラウザからJavaScriptを実行するだけで感染してしまうそうです。
	詳しくは[GENOウイルスまとめ|http://www29.atwiki.jp/geno/]に。

	問題はAdobe ReaderとFlash Playerの脆弱性が原因と言われているので、
	最新版にアップデートしておけば問題なさそうですね。
	被害対象となるOSはWindows 2000/XPだそうです。
	いま使ってるOSはPlan 9とVistaとMacなので、
	関係ないといえば関係ないのですが、怖いので更新かけておきました。

	=Windows Vista
		=Adobe Reader
		Readerを立ち上げて、[[ヘルプ]]→[[アップデートの有無をチェック]]。
		更新があればインストールするかを聞かれるので、インストールします。
		Reader 9なら9の範囲で更新するようなので、8以下の場合は手動で。

		=Flash Player
		\[Flash Player設定パネル|http://www.macromedia.com/support/documentation/jp/flashplayer/help/settings_manager05.html]を使えば、
		テキストファイルを編集しなくても簡単に設定できるようですが、
		最低7日までしか選べないので微妙です。
		というわけでテキストファイルを編集します。

		まず、%WINDIR%\System32\Macromed\Flash\mms.cfgを作成。
		ここで、64bit Windowsの場合は%WINDIR%\*SysWOW64*\Macromed\Flash\mms.cfgになります。
		非常に分かりにくいしAdobeのマニュアルにさえ書かれていませんが。
		原理は[64bit WindowsにおけるSystem32とSysWOW64|http://kait-field.spaces.live.com/blog/cns!B90E9B4A3C4DFD66!889.entry]を参照。

		mms.cfgファイルの内容は以下の通り。UTF-8で保存します。

		.ini
		!AutoUpdateDisable=0
		!AutoUpdateInterval=0

		AutoUpdateIntervalは日単位のようです。
		0の場合はFlash Player起動時に確認。

		mms.cfgを作成したら、OSを再起動して以下2つのFlash Playerを更新。
		ブラウザを立ち上げてFlashが再生されるページを開けば、
		更新確認のダイアログが開くはず。
		*Active X版(IE)
		*Plug-in(IE以外)

	=Mac OS X Leopard
		=Adobe Reader
		使ってないので何もしない。

		=Flash Player
		Apple Software Updateから、[10.5.7アップデート|
		http://support.apple.com/kb/HT3549]を
		当てればFlash Playerが更新されます。

	JavaScriptは、それしか対策が無いなら切りますが、
	アップデートすれば解決するようなのでそのまま。
	最新版にしたうえでJavaScriptを切るのは、やりすぎだと思うなあ。
