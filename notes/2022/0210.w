@include u.i
%title 廃棄前にディスクのデータを消す

.revision
2022年2月10日作成
=廃棄前にディスクのデータを消す

	ストレージの種類によって消去方法が異なるのでメモ。

	=暗号化している場合

	鍵さえ漏れなければ読むことは不可能なので、そのままでよい。

	=HDD

	ATAコマンドのSecure Eraseを実装したディスクならそれを使えばいいらしい。
	実装されているかどうかは、`hdparm`コマンドで調べられる。

	.console
	!$ hdparm -I /dev/sda

	実装されていない場合は`shred`コマンドを使って、
	ランダムなデータを3回と最後にゼロで合計4回上書きすることになる。
	ゼロで上書きするだけでは最適化などの影響でデータが残り続けることがある。

	.console
	!$ sudo shred -v -n 3 -z /dev/sda

	手元で試すと、`shred`は100GBの領域を更新するのに1時間ほど必要だったので、
	容量の大きなディスクを消去する場合は分割実行を検討してもよいと思う。

	.console
	!$ sudo shred -v -n 1 /dev/sda
	!$ sudo shred -v -n 1 /dev/sda
	!$ sudo shred -v -n 1 /dev/sda
	!$ sudo shred -v -n 0 -z /dev/sda

	=SSD

	これは試したことがないけれど、NVMeと同じではないか。

	=NVMe

	これも規格によりSecure Eraseが提供されている。
	Secure Eraseを利用できるかどうかは以下のコマンドで調べられる。

	.console
	!$ sudo nvme id-ctrl /dev/nvme0 -H | grep 'Format \|Crypto Erase\|Sanitize'

	対応しているなら`nvme format`で消去するといい。

	.console
	!$ sudo nvme format /dev/nvme0 -ses 2 -n 1

	*[Solid state drive/Memory cell clearning - ArchWiki|
	https://wiki.archlinux.org/title/Solid_state_drive/Memory_cell_clearing]

	対応していない場合は、`rm`で全て消去したうえで`fstrim`を使うと良いらしい。

	.console
	!$ sudo mount /dev/nvme0n1p2 /mnt
	!$ sudo rm -rf /mnt/*
	!$ sudo sync
	!$ sudo fstrim -v /mnt

	SSDやNVMeはデータを更新するとき、空きブロックから新しいブロックを取得して、
	内容を更新したあとでアドレステーブルを交換するため`shred`はうまく動かない。

	*[Is shred bad for erasing SSDs?|
	https://unix.stackexchange.com/questions/593181/is-shred-bad-for-erasing-ssds]

@include nav.i
