---
title: 設定ファイルやキャッシュの保存先を変更する
style: ../../../styles/global.css
pre: ../include/u.i
post: ../include/nav.i
---

.revision
2021年12月19日作成
=設定ファイルやキャッシュの保存先を変更する

	Plan 9では、*.*で始まるファイルを隠さない。
	代わりに設定ファイルなどは*$home/lib*以下に入れられる。

	=Git

	環境変数`XDG_CONFIG_HOME`を設定して*$XDG_CONFIG_HOME/git/config*に置く。
	Linuxでは`XDG_CONFIG_HOME`を設定していなくても*~/.config/git/config*があれば認識する。

	.sh
	!export XDG_CONFIG_HOME=~/.config

	他のファイルは上記の*config*ファイルで変更できる。

	.ini
	![core]
	!    excludesfile = ~/.config/git/gitignore_global
	![init]
	!    temmplatedir = ~/.config/git/template
	![http]
	!    cookiefile = ~/.config/git/gitcookies

	=**env

	環境変数`**ENV_ROOT`を設定すると、指定したディレクトリで各種バージョンを管理できる。

	.sh
	!export NODENV_ROOT=~/pkg/nodenv
	!export RBENV_ROOT=~/pkg/rbenv
	!export PLENV_ROOT=~/pkg/plenv
	!
	!export PATH=$PATH:$NODENV_ROOT/shims:$RBENV_ROOT/shims:$PLENV/shims

	=nが管理するバージョンをインストールする先

	環境変数`N_PREFIX`で変更できる。

	.sh
	!export N_PREFIX=~/pkg/nodejs
	!
	!export PATH=$PATH:$N_PREFIX/bin

	=npmのいろいろ

	\*~/.npmrc*の`prefix`でnpmパッケージのインストール先を変更できる。

	.ini
	!prefix = ~/pkg/nodejs
	!init.author.email = user@example.com
	!init.author.name = username

	\*~/.npmrc*の場所は環境変数`NPM_CONFIG_USERCONFIG`で変更できる。

	.sh
	!export NPM_CONFIG_USERCONFIG=~/lib/npmrc

	システム全体の設定を扱う`NPM_CONFIG_GLOBALCONFIG`もある。

	=Pythonのpip --userでインストールする先を変更

	環境変数`PYTHONUSERBASE`で変更できる。

	.sh
	!export PYTHONUSERBASE=~/pkg/python
	!
	!export PATH=$PATH:$PYTHONUSERBASE/bin

	=RubyGemsのインストール先

	環境変数`GEM_HOME`で変更できるが、
	ディレクトリはRubyのバージョンごとに分かれているので少し工夫が必要だった。

	.sh
	!export GEM_HOME=~/pkg/gem/ruby/$(ruby -e 'puts RUBY_VERSION')
	!
	!export PATH=$PATH:$GEM_HOME/bin

	=Perlのcpanmでインストールする先を変更

	あまり覚えていないが、以下の環境変数を設定していた。

	.sh
	!export PERL_LOCAL_LIB_ROOT=~/pkg/perl
	!export PERL_MB_OPT="--install_base $PERL_LOCAL_LIB_ROOT"
	!export PERL_MM_OPT="INSTALL_BASE=$PERL_LOCAL_LIB_ROOT"
	!export PERL5LIB=$PERL_LOCAL_LIB_ROOT/lib/perl5
	!export PERL_CPANM_HOME=~/Library/Caches/cpanm
	!
	!export PATH=$PATH:$PERL_LOCAL_LIB_ROOT/bin

	=Cocoapods

	キャッシュを管理するディレクトリは`CP_HOME_DIR`で変更できる。

	.sh
	!export CP_HOME_DIR=~/pkg/cocoapods

.aside
{
	=メモ

	*[lufia/til: 環境構築|https://github.com/lufia/til/blob/master/setup.rst]
	*[XDG Base Directory - ArchWiki|https://wiki.archlinux.org/title/XDG_Base_Directory]
}
