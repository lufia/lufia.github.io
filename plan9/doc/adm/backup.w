@include u.i
%title バックアップ

.revision
2009年9月5日更新
=バックアップ

	Plan 9には、fsにしてもfossil+ventiにしても、
	日々のバックアップは自動で残すようになっています。
	なので、それほど必要ではありませんが、たとえば災害に備えて
	外部メディアに予備を残しておくというのは悪いことではありません。

	以下いくつかサンプルを書いていますが、どれも

	+生のファイルを見えるようにする。
	+mkfsを使って、バックアップを取る。
	+後片付け

	という手順になっています。

	=fsを/にマウントしている場合

	.console
	!% mount /srv/boot /n/fs
	!fs: allow
	!% disk/mkfs -a -u /n/fs/adm/users -s /n/fs \
	!	/sys/lib/sysconfig/proto/allproto >plan9.20090905
	!fs: disallow
	!% unmount /n/fs

	この場合、バックアップは1つのファイルになります。
	もしCDなどに焼いて、他のシステムからもそのまま閲覧したい場合は、
	上記のdisk/mkfs行を以下と差し替えます。

	.console
	!% disk/mk9660 -9cj -s /n/fs \
	!	-p /sys/lib/sysconfig/proto/allproto plan9.iso

	これでCDイメージを直接作成できますので、あとは焼くだけです。

	=kfsの場合

	この例では、直接CD-Rに書き込みしています。

	.console
	!% mount /srv/kfs /n/kfs
	!% disk/kfscmd allow
	!% disk/mkfs -a -u files/adm.users -s /n/kfs \
	!	/sys/lib/sysconfig/proto/allproto >/mnt/cd/wd/plan9.20090905
	!% disk/kfscmd disallow
	!% unmount /n/kfs

=リストア

	disk/mkfsで作成したバックアップを展開する場合です。

	=fsに展開する場合

	展開先のホスト名をfsとして、
	さらにfsはまっさらな状態(ream直後)とします。

	.console
	!% srv fs
	!% mount /srv/fs /n/fs
	!fs: allow
	!fs: users default
	!% disk/mkext -u -d /n/fs /adm/users <plan9.20090905
	!fs: users
	!% disk/mkext -u -d /n/fs <plan9.20090905

	disk/mkextを2度使っているのは、
	fsにユーザ情報を読み込ませないと標準以外の所有者・グループ等を
	うまく復元してくれないためです。

.aside
{
	=関連情報
	*[CDの取り扱い|../guide/disc.w]

	=参考ページ
	*[mkfs(8)]
	*[mk9660(8)]
}

@include nav.i
