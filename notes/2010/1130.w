@include u.i
%title WindowsインストーラWiX

=WindowsインストーラWiX
.revision
2010年11月30日作成

	昨日、今日とマイクロソフト系のネタが続くなあ。。

	*[Platform SDK|
	http://msdn.microsoft.com/ja-jp/windowsserver/bb980924.aspx]
	*Orca
	*[Wix3.0|http://wix.sourceforge.net/]

	これらをインストール。
	Orcaは、Platform SDKがインストールされた場所のbinフォルダに、
	orca.msiがあるのでそれを実行すればいいです。分かりにくいね。

	.note
	Visual Studioのインテリセンスを有効にする場合は、
	Wixのインストール先から
	doc/wix.xsdをVC#/xml/Schema以下にコピーします。

	=構成ファイル

		拡張子をwxsにしたXMLファイルを作成します。
		基本的に参考サイトを見てもらったほうが早いかなあと思いますが、
		それだけだと寂しいので分かりにくいところをメモしました。

		=Product

		:Product.Id
		-アプリケーションのGUID
		:Product.Name
		-プログラムの追加と削除に表示する名前
		:Product.Language
		-日本語は1041
		:Codepage
		-文字コード？

		=Directory.Id

		:Id="TARGETDIR"の場合
		-ルートディレクトリ
		-特定の場所ではない
		:Id="ProgramFilesFolder"ほか
		-[特定のフォルダ|
		http://msdn.microsoft.com/en-us/library/Aa372057]
		:その他
		-DirectoryRef.Idで参照するためのID

		=ほか

		:UpgradeCode
		-これを変えればアップグレード？
		:Media.Id
		-Component.DiskIdまたはFile.DiskIdで参照するID
		:Component.KeyPath
		-これがあればインストール済みだとかなんとか
		:UIRef.Id
		-[インストーラの種類|
		http://cml.s10.xrea.com/ej/WiX/WixUI_dialog_library_old.htm]
		:Property.Id="WIXUI_INSTALLDIR"
		-UIRef.Id="WixUI_InstallDir"の場合は必須

	=ビルドコマンド

	Visual Studioのビルド完了後コマンド等に設定しておきます。

	!set WIX="c:\program files\windows installer xml v3\bin"
	!%WIX%\candle.exe "$(ProjectDir)\Setup.wxs"
	!%WIX%\light.exe -ext WixUIExtension -cultures:ja-jp Setup.wixobj

	これで、Setup.msiがDebugまたはReleaseフォルダ以下にできます。

	=サンプル

	!<?xml version="1.0" encoding="utf-8"?>
	!<Wix xmlns="http://schemas.microsoft.com/wix/2006/wi">
	!	<Product Id="B6A98E5F-D6A7-46FB-9E9D-1F7BF443491C" Name="ディスク容量ログビューア"
	!		Version="1.0.0" Manufacturer="lufia.org"
	!		Language="1041" Codepage="932"
	!		UpgradeCode="{E6A4DF6E-EC69-436b-917A-E875AC8F15F8}">
	!		<Package
	!			Description="ディスク容量ログビューア"
	!			InstallerVersion="200" Compressed="yes"
	!			Manufacturer="lufia.org" Languages="1041" SummaryCodepage="932"/>
	!		<Media Id="1" Cabinet="DiskUsage.cab" EmbedCab="yes"/>
	!
	!		<Directory Id="TARGETDIR" Name="SourceDir">
	!			<Directory Id="ProgramFilesFolder">
	!				<Directory Id="Applications" Name="社内ツール">
	!					<Directory Id="INSTALLLOCATION" Name="DiskUsage"/>
	!				</Directory>
	!			</Directory>
	!			<Directory Id="ProgramMenuFolder">
	!				<Directory Id="APPLICATIONPROGRAMFOLDER" Name="ツール"/>
	!			</Directory>
	!		</Directory>
	!
	!		<DirectoryRef Id="INSTALLLOCATION">
	!			<Component Id="Component1" DiskId="1" KeyPath="yes" Guid="C6849E44-5613-4733-B59D-24E01E01E90C">
	!				<File Id="DiskUsage.exe" Source="DiskUsage.exe"/>
	!				<File Id="DiskUsage.exe.config" Source="DiskUsage.exe.config"/>
	!				<File Id="DynamicDataDisplay.dll" Source="DynamicDataDisplay.dll"/>
	!				<File Id="Interop.IWshRuntimeLibrary.dll" Source="Interop.IWshRuntimeLibrary.dll"/>
	!				<File Id="Sys.dll" Source="Sys.dll"/>
	!				<File Id="README.txt" Source="README.txt"/>
	!			</Component>
	!		</DirectoryRef>
	!
	!		<DirectoryRef Id="APPLICATIONPROGRAMFOLDER">
	!			<Component Id="Component2" Guid="{2451FD7E-59F1-44dd-AF1B-30F540DA6831}">
	!				<Shortcut Id="Shortcut1" Name="ディスク容量ログビューア"
	!						Description="ディスク容量ログビューアの起動"
	!						Target="[INSTALLLOCATION]DiskUsage.exe"
	!						WorkingDirectory="INSTALLLOCATION"/>
	!				<RemoveFolder Id="APPLICATIONPROGRAMFOLDER" On="uninstall"/>
	!				<RegistryValue Root="HKCU" Key="Software\TryYearn\DiskUsage" Name="Installed"
	!					Type="integer" Value="1" KeyPath="yes"/>
	!			</Component>
	!		</DirectoryRef>
	!
	!		<Feature Id="Feature1" Level="1">
	!			<ComponentRef Id="Component1"/>
	!			<ComponentRef Id="Component2"/>
	!		</Feature>
	!
	!		<UIRef Id="WixUI_ErrorProgressText"/>
	!		<UIRef Id="WixUI_InstallDir"/>
	!		<Property Id="WIXUI_INSTALLDIR" Value="INSTALLLOCATION"/>
	!	</Product>
	!</Wix>

	=トラブルシューティング

		=ライセンスに同意して次へ進むと不明なエラー

		不明なエラー(コード2819)の場合は、
		Property.Id="WIXUI_INSTALLDIR"が無いためです。
		設定ファイルに追加すれば動きます。

		=ロケールが無い

		参考サイトの[WiX 3.0 UIの指定|
		http://yy2.sakura.ne.jp/007_wix/wix.html#N20111]によると、

		>WiXでは、UIをロケールに合わせて変更できるようになっています。
		>その設定が含まれているのがlocオプションで指定した
		>「WixUI_ja-jp.wxl」というファイルです。
		>この「WixUI_ja-jp.wxl」はWiXのソースコードを
		>ダウンロードすることで取得することができます。
		>(WiXのマニュアルを参照すると日本語は、
		>WiX内に含まれているように思われるので「WixUI_ja-jp.wxl」を
		>別途ダウンロードする必要はないように思えるのですが、
		>いろいろと試しましたがうまくいかず、
		>locオプションで指定する方法にしています。)

		とありますが、lightの引数で-culturesを指定すると変更できました。

		!cultures:ja-jp

		言語の一覧は[ローカライズされたバージョンのWixUIの使用|
		http://cml.s10.xrea.com/ej/WiX/WixUI_localization.htm]を
		参照です。

.aside
{
	=参考サイト

	*[黒ぬこ|http://kuronuko.com/vs_installer/wix_installer.html]
	*[Wix 3.0|http://yy2.sakura.ne.jp/007_wix/wix.html]
	*[GUIDを生成する|
	http://cml.s10.xrea.com/ej/WiX/generate_guids.htm]
}

@include nav.i
