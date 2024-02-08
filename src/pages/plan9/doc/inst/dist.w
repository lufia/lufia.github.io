---
title: 分散システムのインストール
style: ../../../../styles/global.css
pre: ../../../../layouts/plan9/u.i
post: ../../../../layouts/plan9/nav.i
---

.revision
2006年10月30日更新
=分散システムのインストール

	Plan 9は、各端末や認証サーバでさえも、
	ファイルサーバをルートファイルシステムとして扱えます。
	ちょっと手間ですし、いくつか認証サーバ構築の時と
	同じ設定をしなければいけませんが、
	一度やってしまえばディスクレス運用も可能になるのでオススメです。

	以下、認証サーバとファイルサーバを切り替えながら構築していきます。
	プロンプトでどちらの作業か分かるように書いていく予定です。

	.console
	!# 認証サーバ、ホストオーナー
	!#
	!
	!# 認証サーバ、一般ユーザ
	!%
	!
	!# ファイルサーバ、configモード
	!config:
	!
	!# ファイルサーバ、通常モード
	!fs:

	=配布ファイルの展開

	現状、[Installing a Plan 9 File Server|https://9p.io/wiki/plan9/Installing_a_Plan_9_File_Server/index.html]にあるwrap/instコマンドがありません。
	9fansで調べると[problems installing the plan9 distribution on fileserver|http://9fans.net/archive/2003/03/322]というのがあったので、それに沿って対応。

	.console
	!% 9fs sources
	!% bind /n/sources/plan9 /n/dist
	!% srv fairy
	!% mount -c /srv/fairy /n/inst
	!% cp /n/dist/dist/replica/inst /dist/replica (#instが無かったので作成)
	!% chmod +x /dist/replica/inst

	.console
	!fs: create /dist sys sys 775 d
	!fs: create /dist/replica sys sys 775 d
	!fs: create /dist/replica/ndist sys sys 775
	!fs: create /dist/replica/client sys sys 775 d
	!fs: create /dist/replica/client/plan9.db sys sys 664
	!fs: create /dist/replica/client/plan9.log sys sys 664 a

	.console
	!% replica/pull -v /dist/replica/inst

	=cpu/auth: nvramの設定
	最初の立ち上げ時に聞かれます。
	自分で呼び出す場合はauth/wrkey。

	!authid: bootes
	!authdom: mana.lufia.org
	!secstore: xxxxx    # bootesは使わないけど、とりあえず設定
	!password: zzzzz

	=ファイルサーバ: cronの準備
	.console
	!fs: create /sys/log/cron sys sys 666 a

	=ファイルサーバ: secstoreの準備
	.console
	!fs: create /adm/secstore adm adm 775 d

	=ファイルサーバ: cpu/authで使うファイルの編集
	cpu/authからファイルサーバをマウントして作業。
	このあたりは[認証サーバのインストール|auth.w]そのまま。

	.console
	!% 9fs $fileserver

	**/rc/bin/termrc*   (# 端末がなければどうでもいい)
	**/rc/bin/cpurc*
	**/adm/timezone/local*
	**/lib/ndb/local*
	**/lib/ndb/auth*
	**/rc/bin/^(service service.auth)*  # cpurcから変更されるので作業はない

	補足として、secstoreを有効にするために、
	cpurcのauth/cronの次行に、auth/secstoredを追加しています。

	=ファイルサーバ: /bin/cpurcでmvの行を有効にしたなら
	.console
	!fs: newuser sys +bootes

	=cpu/auth: plan9.iniの設定
	.console
	!# 9fat:
	!# cd /n/9fat
	!# ramfs
	!# ed plan9.ini
	!# unmount /n/9fat

	\*plan9.ini*の必要なところだけ抜粋。

	.ini
	!bootfile=sdC0!9fat!9pcauth
	!bootargs=il -g x.x.x.x ether /net/ether0 y.y.y.y m.m.m.m
	!fs=z.z.z.z
	!auth=y.y.y.y

	.note
	だいたい分かるかと思われますが、いちおう。
	:x.x.x.x
	-デフォルトゲートウェイ
	:y.y.y.y
	-いま構築している認証サーバ のIPアドレス
	:m.m.m.m
	-y.y.y.yのマスク
	:z.z.z.z
	-ファイルサーバのIPアドレス

	=cpu/auth: 再起動
	.console
	!# fshalt
	!# ^t ^t r
	\*/rc/bin/service/^(il566 tcp567)*が無くてエラーになるけど、
	目的はサービスの無効化なので無視

	=ファイルサーバ: ユーザの作成
	.console
	!fs: newuser lufia
	!fs: newuser adm +bootes

	.note
	bootesをadmに所属させない限り、
	auth/changeuserの結果を保存できません。

	=cpu/auth: ユーザの作成
	.console
	!# auth/changeuser -p bootes  (# パスワードはnvramと同じにする)
	!# auth/changeuser -p lufia

	=cpu/auth: 認証でadmとsysをはじく
	.console
	!# cat >>/lib/ndb/auth
	!hostid=bootes
	!    uid=!sys uid=!adm uid=**
	!^D

	=cpu/auth: secstoreの設定
	.console
	!# auth/secuser -v lufia
	!# echo 'key proto=p9sk1 dom=mana.lufia.org user=lufia !password=xxxx' >/mnt/factotum/ctl  (# 最初のdrawterm接続のため)

	=drawtermで接続テスト
	secstoreに何も保存されてない場合、
	secstoreパスワードを入力するとエラーになるので、空にしてログインする。

	.console
	!% drawterm -a wisp -c wisp
	!user[none]: lufia
	!password: xxxx
	!secstore password:

	=lufiaの環境設定
	.console
	!% /sys/lib/newuser

	これで、メールやらなにやらのファイルが作られます。

	=lufiaのsecstoreに、drawterm他用のアカウントを保存
	ファイル名をfactotum以外にすると、次回ログイン時に
	secsotreがremote file factotum does not existsとエラーを吐くので注意。
	.console
	!% ramfs
	!% cd /tmp
	!% echo 'key proto=p9sk1 dom=mana.lufia.org user=lufia !password=xxxx' >factotum
	!% auth/secstore -p factotum
	!% rm factotum

	ちなみに、すでにアカウントが保存されている場合はこちら
	.console
	!% ramfs
	!% cd /tmp
	!% auth/secstore -g factotum
	!% echo 'key proto...' >>factotum
	!% auth/secstore -p factotum
	!% rm factotum

	=cpu/auth: 再起動して動作確認
	.console
	!# fshalt

	=ファイルサーバ: 後始末
	drawtermでlufiaがログインできるのを確認してから後始末。
	というのも、(たぶんkeyfsの)停止時に*/adm/keys*に書くため、
	\*bootes*に*adm*権が必要だから。
	.console
	!fs: newuser sys -bootes
	!fs: newuser adm -bootes

.aside
{
	=関連情報
	*[ファイルサーバのインストール|fs.w]

	=参考ページ
	*[Installing a Plan 9 File Server|
	https://9p.io/wiki/plan9/Installing_a_Plan_9_File_Server/index.html]
	*[分散システムの構築|http://p9.nyx.link/install/distrib.html]
}
