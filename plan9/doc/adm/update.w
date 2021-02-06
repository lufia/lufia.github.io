@include u.i
%title Plan 9のアップデート

.revision
2011年12月3日更新
=Plan 9のアップデート

似たような記事が[ファイルサーバのインストール|../inst/fs.w]
にもありますが、こちらはPlan 9環境全体のアップデート。
あちらはken fsソースそのもののアップデートになります。

fs環境で使っていると、*/dist/replica/network*が
うまく動いてくれません。fossilもkfsも無いからね。
なので、replicaするには自分で設定ファイルを作ります。

.console
!fs: create /dist/replica/inst sys sys 775

以下が*/dist/replica/inst*の内容。

.sh
!#!/bin/rc
!
!# Generic plan9 installation template.
!# Assumes that distribution CD or sources
!# is mounted at /n/dist, and should be installed
!# to /n/inst.
!
!s=/n/dist/dist/replica
!serverroot=/n/dist
!serverlog=$s/plan9.log
!serverproto=$s/plan9.proto
!fn servermount { status='' } 
!fn serverupdate { status='' }
!
!fn clientmount { status='' }
!c=/n/inst/dist/replica
!clientroot=/n/inst
!clientproto=$c/plan9.proto
!clientdb=$c/client/plan9.db
!clientexclude=(dist/replica/client)
!clientlog=$c/client/plan9.log
!
!applyopt=(-t -u -T$c/client/plan9.time)

実際にreplicaするときは以下のように。
ファイルサーバ側でallowするのを忘れないように。

.console
!% mount -c /srv/boot /n/inst
!% 9fs sources
!% bind /n/sources/plan9 /n/dist
!fs: allow
!% replica/pull -v /dist/replica/inst

以上でアップデートが行われます。
とても時間がかかるので、ゲームでも遊びながら待ちましょう。

pullに-vオプションを与えると詳細が表示されます。
このとき出てくる文字は、

:a
-追加
:c
-ファイル内容の変更
:d
-ファイルの削除
:m
-メタデータ(パーミッションとか)の変更
:!
-競合しているので変更しない

のようになっています。
競合した場合、サーバのファイルで更新したいときは、
全体のアップデートが終わった後で以下のように書きます。

.console
!% replica/pull -s sys/src/9/pcflop /dist/replica/inst

これでしばらく待つと、/sys/src/9/pcflopがサーバのもので更新されます。
競合が複数ある場合は、-sオプションを必要なだけ使って指示します。

.console
!% replica/pull -s file1 -s file2 /dist/replica/inst

終わったら後始末。

.console
!fs: disallow
!% unmount /n/dist
!% unmount /n/sources
!% rm /srv/sources
!% unmount /n/inst

.aside
{
	=参考ページ
	*[配布ファイルの更新|http://plan9.aichi-u.ac.jp/replica/]
}

@include nav.i
