---
title: VMware Playerにファイルサーバをインストール
style: ../../../styles/global.css
pre: ../../../layouts/notes/u.i
post: ../../../layouts/notes/nav.i
---

.revision
2011年7月23日作成
=VMware Playerにファイルサーバをインストール

紆余曲折ありまして、だいぶ苦労しましたが、
とりあえず動くまではできました。

まずは端末をインストールするのですが、
今のPlayerでは新しい仮想マシンの作成もできるので
qemuを使ってvmdkを作らなくてもよくなっています。
代わりに、いろいろ試してみましたがインストール時にrioが使えないので、
inst/textonlyで進める必要があります。
インストールが終わればふつうに使えるのにね。

.ini
!vgasize=1024x768x24
!monitor=xga

次に、fsのソースを落としてコンパイルするのですが、
fsカーネルのE1000ドライバはVMwareのデバイスを認識しません。
この点についてパッチを当てた[etherigbe.c|
../../plan9/src/etherigbe.c]を置いておきますので差し替えてください。
変更したところは、定数i82545emの定義と、
各switch文にそれを含めただけですね。

.c
!i82545em = (0x100F<<16)|0x8086,

.note
{
	ファイルサーバを起動してpcihinvコマンドを使うと、
	デバイスのIDが見れます。

	!fs: pcihinv
	!...
	!2 0/0 0200 8086 100f 10 0:....
	!...
}

ここは[ファイルサーバのインストール|../../plan9/doc/inst/fs.w]そのまま。
ちょっとつまづいたのは2点、instに実行パーミッションが無いと
ファイルが見つからないというエラーになって動かないところと、
plan9.iniのbootfileエントリだけは、新しい書き方を取るところ。

.ini
!ether0=type=igbe
!scsi0=type=buslogic
!bootfile=fd0!dos!9fsfs64
!nvr=fd!0!plan9.nvr

これでフロッピーを作ればPlan 9側の処理は終わりですが、
最後にNICのチップセットを変更しておきます。
具体的にはvmxファイルに以下を追加。

.ini
!ethernet0.virtualDev = "e1000"

これで、仮想マシン間でip/pingも通りましたし、
外部のSNTPサーバとも通信ができました。
あとは、SCSIを認識しているもののSCSIディスクの追加方法が分からないので、
そこが確認できれば問題なさそうですね。

.aside
{
	=関連情報
	*[ファイルサーバのインストール|../../plan9/doc/inst/fs.w]
}
