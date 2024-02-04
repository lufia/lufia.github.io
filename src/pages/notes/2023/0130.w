---
title: PostgreSQLのメジャーバージョンアップグレード
pre: ../include/u.i
post: ../include/nav.i
---

.revision
2023年1月30日作成
=PostgreSQLのメジャーバージョンアップグレード

	この記事は以下のWikiを自分用にまとめたものなので、Wikiを見るほうが正確だと思う。

	*[Upgrading PostgreSQL - ArchWiki|
	https://wiki.archlinux.org/title/PostgreSQL#Upgrading_PostgreSQL]

	=PostgreSQLのアップグレード

	PostgreSQL自体のアップグレードは、*postgresql*を単に更新すればよい。

	.console
	!$ sudo pacman -Syu

	アップグレードしたとき、データの更新が必要な場合はログにメッセージが出力される。

	=データのアップグレード

	PostgreSQLのデータは*/var/lib/postgresql/data/PG_VERSION*にバージョン情報を持っている。
	コマンドのバージョンが上がったとき、`pg_upgrade`でデータのバージョンも更新する必要がある。

	このとき、`pg_upgrade`は古いバージョンのコマンドも要求するが、
	Arch Linuxの*postgresql*パッケージは古いバージョンを持っていない。
	そのため*postgresql-old-upgrade*をインストールする。

	.console
	!$ sudo pacman -S postgresql-old-upgrade

	次に、データ変換のための準備をする。
	前バージョンの*/var/lib/postgresql/data*をリネームして、新しい*data*にコピーする形になる。
	新しいバージョンと以前のバージョンを両方実行してレプリケーションをしているらしいが、
	詳細までは追っていない。

	.console
	!$ cd /var/lib/postgresql
	!$ sudo mv data olddata
	!$ sudo mkdir data tmp
	!$ sudo chown postgres:postgres data tmp

	新しいバージョンのデータを初期化して、`pg_upgrade`を実行する。

	.console
	!$ sudo -u postgres -i
	!$ cd /var/lib/postgres/tmp
	!postgres$ initdb -D /var/lib/postgres/data [--locale=C]  [--encoding=UTF8] [-U lufia] [--data-checksums]
	!postgres$ pg_upgrade -b /opt/pgsql-14/bin -B /usr/bin -d /var/lib/postgres/olddata -D /var/lib/postgres/data [-U lufia]

	このとき、古いバージョンのデータとオプションを揃えておく。
	例えば`--data-checksums`オプションが無効になっているデータから、
	オプションを有効にしたデータへ移行しようとすると`pg_upgrade`で以下のようなエラーが発生する。

	.console
	!postgres$ pg_upgrade -b /opt/pgsql-14/bin -B /usr/bin -d /var/lib/postgres/olddata -D /var/lib/postgres/data
	!Performing Consistency Checks
	!-----------------------------
	!Checking cluster versions                                   ok
	!
	!old cluster does not use data checksums but the new one does
	!Failure, exiting

	または、データベースのスーパーユーザーが異なる場合は以下のようなエラーになる。

	.console
	!postgres$ pg_upgrade -b /opt/pgsql-14/bin -B /usr/bin -d /var/lib/postgres/olddata -D /var/lib/postgres/data
	!Performing Consistency Checks
	!-----------------------------
	!Checking cluster versions                                   ok
	!
	!connection to server on socket "/var/lib/postgres/tmp/.s.PGSQL.50432" failed: FATAL:  role "postgres" does not exist

	=後始末

	これで一通り移行が終わったのでサービスを起動する。ついでに掃除もしておく。

	!$ sudo systemctl start postgresql.service
	!$ sudo rm -rf /var/lib/postgresql/{olddata,tmp}
	!postgres$ vacuumdb --all --analyze-in-stages [-U lufia]
