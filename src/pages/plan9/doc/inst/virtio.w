---
title: VirtIOを使う
style: ../../../../styles/global.css
pre: ../../include/u.i
post: ../../include/nav.i
---

=VirtIOを使う

	=VirtIOのインストール

		=パッチを当てる

		VirtIOはPlan 9の標準ディストリビューションには含まれないので、
		9legacyのパッチを当てます。

		.console
		!% cd /
		!% hget http://www.9legacy.org/9legacy/patch/pc-sdvirtio.diff | ape/patch -p1
		!% hget http://www.9legacy.org/9legacy/patch/pc-ethervirtio.diff | ape/patch -p1

		自前のツールですが、9legacy/installを使うと便利です。

		.console
		!% 9legacy/init
		!% 9legacy/installall <{9legacy/stable}
		!% 9legacy/apply

		次に、カーネルコンフィグへVirtIOドライバを追加します。
		ここで不要なドライバを削除しておいてもいいかもしれません。

		.console
		!% cd /sys/src/9/pc
		!% ed pccpuf

		カーネルコンフィグは、たとえば以下のように。

		!link
		!    ethervirtio    pci
		!
		!misc
		!    sdvirtio        pci sdscsi

		また、9loadにも足しておかないとデバイスが見つからなくて
		ブートできなくなるので、9loadのコンフィグにもsdvirtioを足します。

		.console
		!% cd /sys/src/9/pcboot
		!% ed load

		loadはカーネルをロードするだけなので、sdvirtioがあれば十分だと思います。
		もし9bootも必要なら、そっちにはethervirtioを追加しましょう。

		=インストール

		カーネルのビルドを行います。

		.console
		!% cd /sys/src/9/pc
		!% mk 'CONF=pccpuf'

		次にローダのビルド。

		.console
		!% cd /sys/src/9/pcboot
		!% ed load
		!% mk 9load

		9fat領域へカーネルとローダをコピーしたらインストール完了です。

		.console
		!# 9fat:
		!# cp 9load /n/9fat/9load (きちんとdisk/format使ったほうが良いかも)
		!# cp 9pccpuf /n/9fat/9pccpuf

	=デバイス名を変更

	VirtIOを有効にすると、デバイス名が*sdC0*から*sdF0*に変わります。
	そのため、fossil等、デバイス名の変更が必要です。
	必ず、新しいカーネルでブートする前に実施しなくてはいけません。

	まず*plan9.ini*を変更。

	.ini
	!bootfile=sdF0!9fat!9pccpuf
	!bootargs=local!#S/sdF0/fossil
	!bootdisk=local!#S/sdF0/fossil

	fossilのconfにも設定が入っているので修正します。

	.console
	!# fossil/conf /dev/sdC0/fossil >fossil.conf
	!# ed fossil.conf
	!fsys main config /dev/sdF0/fossil
	!# fossil/conf -w /dev/sdC0/fossil fossil.conf

	ventiを使っている場合は、ventiの設定も修正が必要です。

	.console
	!% venti/conf /dev/sdC0/arenas >venti.conf
	!% ed venti.conf
	!isect /dev/sdF0/isect
	!arenas /dev/sdF0/arenas
	!% venti/conf -w /dev/sdC0/arenas <venti.conf

	このあと仮想マシンのVirtIOを有効にするのでシャットダウンさせます。

	=仮想マシンのVirtIO

	シャットダウンし終わったら、カスタムOSインストールを実行するか、
	ISOイメージインストールでVirtIOを有効にしてインストールを実行します。
	このとき、あくまで目的はVirtIOを有効にするだけなので、
	イメージから起動したらすぐに再起動させてしまってください。
	(VirtIO有効無効の切り替えはOSインストール時しかできないので)

	これで正しく設定できていればVirtIOドライバを使ったカーネルが動作します。

	=終わりに

	さくらVPSは、OS再インストールをすると
	仮想マシンのスイッチ設定がリセットされるので、
	ファイルサーバから/を得ている場合はスイッチの設定も忘れずに。

	=困ったときの対応

		少しはまったことをまとめました。

		=ブートしなくなった場合

		Plan 9のISOイメージからブートさせると、
		インストールするかCDからブートするかを選べるので、
		CDからブートして必要なリカバリを行いましょう。

		=ISOイメージのアップロードができない場合

		ISOをアップロードしようとしたら、
		以下のようなエラーで失敗するときがあります。

		.console
		!sftp> put plan9.iso
		!Uploading plan9.iso to /iso/plan9.iso
		!remote open("/iso/plan9.iso"): Failure

		[さくらの VPS で ISO イメージがアップできない|
		http://randomsoft.com/node/438]によると、ISOアカウントを削除したうえで、
		仮想マシンを起動・停止するといいそうです。

		それでもだめな場合は、起動・停止のかわりに
		カスタムOSインストール・停止させると解消します。

.aside
{
	=関連情報
	*[64bit環境(9kカーネル)を構築する|9k.w]
}
