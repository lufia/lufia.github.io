---
title: VAIO Z(VJZ1421)を買った
pre: ../include/u.i
post: ../include/nav.i
---

.revision
2022年3月27日作成
=VAIO Z(VJZ1421)を買った

	1月末あたりに、[VAIO Zの勝色モデル|
	https://store.vaio.com/shop/pages/kachiiro_z142g.aspx]を購入した。

	それまでは[12インチMacBookにLinuxを入れて使っていた|
	https://blog.lufia.org/entry/2021/04/05/170000]けれど、
	2017年に購入してから5年になるし、少し前に[ストレージでI/O errorが発生|
	https://blog.lufia.org/entry/2022/01/10/181745]があって、頃合いと思った。

	=ハードウェア選び

	M1 Macが早くて良いという話だけど、次の候補からは外した。
	macOSはショートカットにCommandキーを使う習慣があるので、
	\*Ctrl+H*や*Ctrl+A*などのテキスト編集キーバインドと競合しないし、
	トラックパッドの挙動はmacOSの方が洗練されているのは実感としてある。
	だけども今のところ、macOSよりLinuxのほうが快適だと感じている。

	.note
	特にArch Linuxは、パッケージマネージャがOSに付属しているものなので、
	OS標準のコマンドとパッケージマネージャで追加したコマンドが競合しないし、
	開発環境のアップデートをするだけのために2時間待たされることもない。
	私は開発者なので、メッセージAppの強化や絵文字の追加よりも、
	FUSEやコンテナ対応、標準パッケージマネージャの追加、
	launchdの強化などが欲しいのだけど、対応される気配はない。

	LinuxのM1 Mac対応は[Asahi Linux|https://asahilinux.org/]が頑張っているが、
	新しいハードウェアをサポートし続けていくのは難しいだろうなと思う。
	Intel Macの対応状況は[State of Linux on the MacBook Pro 2016 & 2017|
	https://github.com/Dunedan/mbp-2016-linux]にあるが、状況はあまり良くない。
	Intel Macが下火になった事情はあるとしても、
	M1 Macで状況が劇的に改善されるとはあまり思えない。
	そしてLinuxデスクトップでWi-Fiが使えないのは普通に困る。

	最終的に、VAIO Z、DELL XPS、Microsoft Surfaceで悩んだが、
	軽くて性能が良いVAIO ZにArch Linuxを入れて使うことに決めた。
	VAIO Zは14インチなのに、今まで使っていた12インチMacBookと
	ほとんど重さが変わらないのはすごいと思う。

	=Linuxセットアップ

	1つのディスクだけを扱う場合は安定しているらしいので、
	ルートファイルシステムはBtrfsにした。
	セキュアブートや、TPM2デバイスからLUKS2の鍵を読む設定なども入れた。
	手順は他の記事に書いたのでそちらを参照してほしい。

	:[12インチMacBookにArch Linuxをインストールした|
	https://blog.lufia.org/entry/2021/04/05/170000]
	-ドライバまわりを除けばほとんど同じ
	:[業務端末としてLinuxデスクトップを使うために設定したこと|
	https://blog.lufia.org/entry/2022/01/18/203946]
	-GNOMEテーマの設定など
	:[TPM2.0デバイスを使って暗号化したボリュームのパスフレーズ入力を省略する|
	https://blog.lufia.org/entry/2022/02/13/020028]

	サウンド、ネットワーク、Bluetoothは遜色なく使える。
	サスペンドからの復帰も問題ない。
	デバイスに関連しているパッケージはこのあたり。

	*alsa-firmware
	*bluez-utils
	*iwd
	*pipewire-alsa
	*pipewire-pulse
	*sof-firmware

	指紋認証は使えなかった。そもそも*libfprintd*にデバイスが認識されない。
	VendorID、ProductIDを*libfprintd-tod-git*に追加するとデバイスは見つかるが、
	今度は`no left space`エラーでうまく動かなかった。

	顔認証(赤外線カメラ)は試していない。
	認証のためにはHowdyというツールを使えばいいらしい。

	=今後やること

	ハイバネートするためには、まだ設定が足りないらしいので対応する。

	*[サスペンドとハイバネート - ArchWiki|
	https://wiki.archlinux.jp/index.php/%E3%82%B5%E3%82%B9%E3%83%9A%E3%83%B3%E3%83%89%E3%81%A8%E3%83%8F%E3%82%A4%E3%83%90%E3%83%8D%E3%83%BC%E3%83%88]

	それから、SONY時代のVAIOは*/sys/devices/platform/sony-laptop*以下で
	静音設定などが行えたらしいが、このVAIO Zには無かったので、
	代わりとなるものがあるのかどうかは調べておきたい。

	*[VAIOに入れたLinuxで静音モードやバッテリーケアを有効にする|
	https://blog.myon.info/entry/2014/01/15/entry/]
