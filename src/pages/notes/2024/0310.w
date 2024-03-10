---
title: Btrfsのskipping scrub of block group x due to active swapfile
style: ../../../styles/global.css
pre: ../../../layouts/notes/u.i
post: ../../../layouts/notes/nav.i
---

.revision
2024年3月10日作成
=Btrfsのskipping scrub of block group x due to active swapfile

	Linuxデスクトップのジャーナルをみていたら、
	以下の警告メッセージが出力されていた。

	>kernel: BTRFS warning (device dm-0):
	>skipping scrub of block group 1000000 due to active swapfile

	これを理解できるほどの知識は持ってなかったので、出現している単語を調べた。

	=Scrub

	BtrfsにはScrubというしくみがある。

	*[Scrub - BTRFS documentation|
	https://btrfs.readthedocs.io/en/latest/Scrub.html]

	Scrubはファイルシステム全体のチェックサムを調べて、
	壊れていたら(あれば)コピーから復旧する。
	ただし、あくまでチェックサムエラーのみを対象とするので、それ以外の破損、
	たとえばファイルシステムの構造が壊れている場合などは検出しない。
	いわゆる*fsck*の代替ではないので、そういった用途は[btrfs-check(8)|
	https://btrfs.readthedocs.io/en/latest/btrfs-check.html]を使う。

	=Scrubの起動

	Scrubは以下のコマンドで実行できる。

	.console
	!$ sudo btrfs scrub start -B /

	Arch Linuxでは一定周期でScrubを自動実行するので、通常は意識する必要はない。
	具体的には*btrfs-progs*パッケージにsystemdのユニットが含まれていて、
	\*btrfs-scrub@-.timer*によって*btrfs-scrub@-.service*が起動する。

	.console
	!$ systemctl status btrfs-scrub@-.timer

	=なぜ警告が出力されたのか

	Btrfsのソースコード[fs/btrfs/scrub.c|
	https://github.com/torvalds/linux/blob/master/fs/btrfs/scrub.c]によると、

	.c
	!if (ret == -ETXTBSY) {
	!	btrfs_warn(fs_info, "skipping scrub of block group %llu due to active swapfile",
	!		cache->start);

	とあった。`ret`はそのすぐ上で

	.c
	!ret = btrfs_inc_block_group_ro(cache, sctx->is_dev_replace);
	!if (!ret && sctx->is_dev_replace) {
	!	ret = finish_extent_writes_for_zoned(root, cache);

	のように取得している。

	続けて、`btrfs_inc_block_group_ro`を読んでいくと、

	.c
	!ret = inc_block_group_ro(cache, 0);
	!if (!ret)
	!	goto out;
	!if (ret == -ETXTBSY)
	!	goto unlock_out;

	とある。outやunlock_outは最後にretをreturnするだけ。
	そうして`inc_block_group_ro`は、

	.c
	!if (cache->swap_extents) {
	!	ret = -ETXTBSY;
	!	goto out;
	!}

	で後処理をしたあと`ret`を返す。
	なので、該当のアドレスがSwapfile extentsだからskipされたというログだった。

	*[Swapfile - BTRFS documentation|
	https://btrfs.readthedocs.io/en/latest/Swapfile.html]

	=Extents

	ざっくり表現すると、ストレージの領域に入っているデータの種類のこと。
	Btrfsでは以下のような種類がある。

	*`EXTENT_DATA`
	*`EXTENT_CSUM`
	*`EXTENT_DATA_REF`

	エクステントの一般的な説明は次の記事が分かりやすかった。

	*[エクステント - XTECH|
	https://xtech.nikkei.com/it/article/Keyword/20090417/328547/]
