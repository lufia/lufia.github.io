@include u.i
%title SproutCore開発環境構築

.revision
2011年1月28日更新
=SproutCore開発環境構築

	JavaScriptフレームワークの[SproutCore|
	http://www.sproutcore.com/]を使ってみました。
	詰まったところをいろいろまとめていく予定です。
	今回は環境を準備するところまで。

	=インストール

		=Ruby 1.8.x
		まずはRubyのインストールから始めます。
		Macの場合はもともと付属しているので次に進みます。

		SproutCoreが依存しているjson 1.4.6は
		msvcrt-ruby18.dllを参照していて、
		まだ1.9系では使えないみたいなので、[Ruby 1.8.x-mswin|
		http://www.garbagecollect.jp/ruby/mswin32/ja/download/release.html]を
		c:\rubyにインストールします。

		=PATHの設定

		PATHにc:\ruby\binを追加します。

		=RubyGems

		Ruby 1.8系はgemが付属していないので、[RubyGems|
		http://rubyforge.org/frs/?group_id=126]から
		1.3.7.zipを展開してsetup.rbを実行。
		これでruby/bin/gemが作られます。

		!gem -v

		=各種ライブラリ
		必要なライブラリをc:\ruby\binにコピーします。
		11月時点でOpenSSLは0.9.8oと1.0.0aの2種類ありますが、
		1.0版を使うと序数xxxエラーで停止しますので注意です。

		*[zlib-1.1.4-1|http://jarp.does.notwork.org/win32/]/bin/zlib.dll
		*[readline-4.3-2-mswin|
		http://jarp.does.notwork.org/win32/]/bin/readline.dll
		*[OpenSSL for Win|
		http://www.limber.jp/?Software/OpenSSL for Windows]/sslay32.dll
		*[OpenSSL for Win|
		http://www.limber.jp/?Software/OpenSSL for Windows]/libeay32.dll
		*[iconv-1.8.win32|
		http://www.rubylife.jp/install/other/index1.html]/lib/iconv.dll

		=SproutCoreのインストール

		.console
		!$ gem install sproutcore

		依存するパッケージも含めて全部インストールしてくれます。便利。

		.console
		!$ gem update

		アップデートがあるものを全部まとめて処理してくれます。

		.console
		!$ gem cleanup

		最新のパッケージを除いて、古いものを削除します。

	=ファイルツリーのメモ

		=gemsのインストール先

		\$rubydir/lib/ruby/gems/$rubyver

		|$gems/doc/ridoc		リファレンスマニュアルっぽい
		|$gems/gems			各種パッケージ

		=SproutCoreパッケージ

		\$gems/gems/sproutcore-$ver

		|$sc/bin				sc-genやsc-serverといったコマンド
		|$sc/lib/buildtasks		各種rakeファイル
		|$sc/lib/doc_templates	?
		|$sc/lib/frameworks/sproutcore	これがソースっぽいね
		|$sc/lib/sproutcore		sc-コマンドで使うrbファイルかな
		|$sc/lib/gen			sc-genで使うテンプレート
		|$sc/design			?
		|$sc/spec				?

.aside
{
	=参考サイト
	*[モバイルWebアプリケーションフレームワークの比較|
	http://www.ibm.com/developerworks/jp/web/library/wa-mobilewebapp/]
}

@include nav.i
