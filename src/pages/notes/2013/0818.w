@include u.i
%title Mac OS Xのパッケージ管理

.revision
2013年8月18日作成
=Mac OS Xのパッケージ管理

	Macは、.app形式でアプリケーションを提供しているものと、
	インストーラ付きの.pkg形式のものがあります。
	前者は.appをまるっとゴミ箱に捨てればいいのですが、
	後者の場合、ファイルがいくつかの場所に分散するので簡単ではありません。
	そういった.pkgの管理について少しメモ。

	.note
	どちらの形式でも、ユーザごとの設定ファイル等は$HOME/Library/以下に
	作成されている場合があります。探して消しましょう。

	=インストール済みパッケージを調べる

	.console
	!$ pkgutil --pkgs

	インストール済みのパッケージIDが表示されます。
	com.apple.のものがいっぱいあるので、grep -vしておくと便利です。

	=パッケージのインストール先を調べる

	.console
	!$ pkgutil --info {パッケージID}

	上記コマンドの出力結果から、
	volumeとlocationを繋げた場所にインストールされています。

	!version: 17.0.2004.1119
	!volume: /
	!location: 
	!install-time: 1358076145

	たとえば、この場合は/直下です。

	=パッケージに含まれるファイルを調べる

	.console
	!$ pkgutil --files {パッケージID}

	ディレクトリ、ファイルを問わずすべて列挙します。
	たとえば--infoで調べたインストール先が/直下で、--filesの結果が

	!Applications
	!Applications/Example.app
	!Applications/Example.app/file

	であれば、実際のファイルは/Applications/Example.app/fileです。

	=パッケージを削除する

	Lion以前はpkgutil --unlinkが存在していたようですが、
	Mountain Lionからは無くなってしまったため、少々面倒です。

	まずは、ファイルを削除します。
	上記で挙げた例の場合、--infoと--filesの結果を組み合わせて、
	Example.appを手動で削除すればいいと思われます。
	ただし、ほとんどの場合、/Applicationsは消せないでしょう。
	削除するべきファイルとそうでないファイルを区別するのが少々面倒です。

	.note
	Githubに、[rm_pkg_files|
	https://github.com/niw/profiles/blob/master/bin/rm_pkg_files]が
	ありましたが、--filesの結果をみて、削除しているだけのようです。

	次に、インストールした情報を削除します。

	!sudo pkgutil --forget {パッケージID}

	他のコマンドと異なり、システムに手を入れるのでsudoが必要です。

	.note
	Mountain Lionでは、/Library/Receipts/InstallHistory.plistに
	インストール履歴があり、/private/var/db/receipts/以下に
	各種パッケージのbomとplistファイルがありますけれど、
	OSのバージョンによって変更される可能性があるためpkgutilを使え、
	ということみたいです。

	=削除できないパッケージを削除する

	pkgutil --forgetで削除すると、以下のようなエラーになる場合があります。

	!Unknown error Error Domain=NSCocoaErrorDomain Code=4 "“com.apple.pkg.iPhoto_710.bom” couldn’t be removed." UserInfo=0x7f97b2673470 {NSFilePath=/var/db/receipts/com.apple.pkg.iPhoto_710.bom, NSUserStringVariant=(
	!	Remove
	!), NSUnderlyingError=0x7f97b263ac80 "The operation couldn’t be completed. No such file or directory"}.
	!Forgot package 'com.apple.pkg.iPhoto_710' on '/'.

	この場合は、/Library/Receipts以下にゴミが残っているだけなので、
	削除したいpkgファイルを上記ディレクトリから手動で消してしまえば問題ありません。

.aside
{
	=参考サイト
	*[Mac OS Xのパッケージファイルを操作する|http://blog.niw.at/post/16690761384]
}

@include nav.i
