---
title: CDの取り扱い
style: ../../../../styles/global.css
pre: ../../../../layouts/plan9/u.i
post: ../../../../layouts/plan9/nav.i
---

.revision
2009年9月5日更新
=CDの取り扱い

	=CD-Rを焼く

	+cdfsでマウントする。
	+音楽ならwa/、データならwd/にコピー。
	+書き込みが終わって、そのディスクに追記しないならwa/またはwd/を削除。

	コマンドになおすと以下の通り。

	.console
	!% cdfs
	!% #echo [quick]blank >/mnt/cd/ctl
	!% cp data /mnt/cd/wd
	!% rm /mnt/cd/wd

	最近はブルーレイにも対応しているようですね。

	=CDのマウント

	CDから最初のトラックを/n/cdにマウントする場合

	.console
	!% cdfs
	!% 9660srv -f d000
	!% mount /srv/9660 /n/cd

.aside
{
	=関連情報
	*[バックアップ|../adm/backup.w]

	=マニュアル
	*[cdfs(4)]
}
