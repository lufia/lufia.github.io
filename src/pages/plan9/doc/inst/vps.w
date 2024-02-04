---
title: さくらVPSにPlan 9をインストール
pre: ../../include/u.i
post: ../../include/nav.i
---

.revision
2014年2月22日作成
=さくらVPSにPlan 9をインストール

	さくらVPSにベル研版Plan 9をインストールしました。
	最近のさくらVPSはISOインストールが可能になっていますので、
	それを使っています。

	=ISOイメージの転送

	まずはさくらVPSコントロールパネルから、
	ISOアップロード用のsftpアカウントを作る必要があります。
	その後、Plan 9公式配布物のISOイメージをダウンロードして、
	(bz2を解凍してから)さくらVPSにアップロードします。

	アップロード用のアカウントは1日で自動的に無効化されるようです。
	また、アカウントを削除するとアップロードしたISOイメージも消えてまうので、
	やる気のあるときにアップロードすることをおすすめします。

	=Plan 9のインストール

	ISOイメージのアップロードが終わったら、
	コントロールパネルのOS再インストールメニューから、
	ISOイメージからインストールを選択します。

	次に、インストール内容確認のところで、virtio有効にチェックが入っているので、
	これを無効にしてから、インストールを開始します。
	(virtioが有効になっていると*/dev/sdC0*が見つかりませんでした)

	=インストール時の設定

	以下のようにインストーラからの質問へ答えました。

	|*メニュー*		*設定値*
	|dmaon			yes
	|mouseport		ps2
	|vgasize		1024x768x32
	|monitor		xga

	この後、しばらくするとrioが立ち上がってきます。
	ここから先はメニューに答えるだけです。

		=configfs

		fossil+ventiを選びました。

		=partdisk, prepdisk

		すでにLinux用のパーティションが存在しましたので、
		いちど全部を削除してから、作り直しが必要でした。
		全部削除してw, qでメニューを抜ければ、
		おすすめのパーティションが切られます。

		=fmtfossil

		インストーラが不要だと判断した場合はスキップされますが、
		必ず実行しておきましょう。

		=fmtventi

		fmtfossilと同様に、必ずフォーマットしておきましょう。

		=copydist

		ファイルのコピーが始まります。
		今回インストールしたときは10分もかかっていない気がします。

		=bootstrap

		Enable boot methodを聞かれたらplan9を選びます。
		[さくらVPSにまるまるPlan 9をインストール|
		http://www.tsubame2.org/2010/10/vps-plan-9_11.html]のように、
		ctl+dで抜ける方法を使っても大丈夫です。

		=finish

		インストールが一通り終わったら、再起動するように促されますが、
		その前に、*plan9.ini*へ行の追加が必要です。
		適当にウインドウを開いて、

		.console
		!% mount /srv/dos /n/9fat /dev/sdC0/9fat
		!% cat /n/9fat/plan9.ini
		!# 無ければ、以下の2行を追加
		!*nomp=1
		!console=0 b115200 l8 pn s1
		!% unmount /n/9fat

	=再起動

	さくらVPSのコントロールパネルから再起動したとき、
	GRUBから先に進まない状態になってしまっていたなら、
	もういちどISOからインストールを選びます。
	そうするとCDからブートしているけれど上記でインストールした
	環境を操作できるようになりますので、
	glendaでログインして以下のコマンドを実行しましょう。

	.console
	!% disk/mbr -m /386/mbr /dev/sdC0/data

	最初にventiへ書き込みをしているようで、とても重いです。
	少し待てば落ち着きます。

	=NICを認識させる

	インストール直後は、

	!igbe: p->cls 0x0, setting to 0x10
	!igbe: bad EEPROM checksum - 0x535E

	のようなエラーでNICが認識できていませんでしたので、[さくらVPSでPlan 9|
	https://oraccha.hatenadiary.org/entry/20100928/1285683705]を参考に
	\*/sys/src/9/pc/etherigbe.c*を以下のように変更2しました。

	.diff
	!--- /sys/src/9/pc/etherigbe.c
	!+++ /sys/src/9/pc/etherigbe.c
	!-snprint(rop, sizeof(rop), "S :%dDCc;", bits+3);
	!+snprint(rop, sizeof(rop), "CcS :%dDCc;", bits+3);

	あとはコンパイルして再起動でNICを認識できます。

	.console
	!% cd /sys/src/9/pc
	!% mk 'CONF=pcf'
	!% 9fat:
	!% mv 9pcf /n/9fat/9pcf
	!% mk 'CONF=pcf' nuke
	!% fshalt

.aside
{
	=関連情報
	*[VirtIOを使う|virtio.w]
	*[Sizka BASICへのインストール|sizka.w]
}
