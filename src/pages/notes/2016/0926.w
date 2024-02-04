@include u.i
%title Windows 8.1以降でWi-Fiが「制限あり」になる

.revision
2016年9月26日作成
=Windows 8.1以降でWi-Fiが「制限あり」になる

MacBook AirのBootcampでWindowsを使っていますが、
確かWindows 8.1にした頃から無線ネットワークが頻繁に「制限あり」となってしまって
インターネットに接続できなくなる問題が起こっていました。

同様の問題を調べると、

*ドライバを入れなおす
*ネットワークのプロパティで「自動的に接続する」
*SSIDをブロードキャストしていなくても接続する
*電源オプションのワイヤレスアダプタ省電力モードを変更
*完全シャットダウンで電源を落とす
*ルータの再起動やファームウェアアップデート
*Wi-Fiのチャンネルを変更する

など、いくつか解決方法は見つかりましたが、どれも効果はありませんでした。

結局はドライバが原因で、ネットワークドライバの*WMM*を*無効*にすることで
「制限あり」となる問題は発生しなくなりました。
ただし、Windowsアップデート(特に大き目のアップデート)を行った後は
"WMM"の設定が"自動"に戻ってしまうことがあるため、その場合は再設定が必要です。

.aside
{
	=参考記事
	*[Windows 8.1でWi-Fi（無線LAN）が「制限あり」になってネットにつながらなくなる現象対策|
	http://cubeundcube.hatenablog.com/entry/2014/08/16/110945]
	*[MacBook Air (13-inch, Mid 2011)でWindows8.1を使っていると無線LANが頻繁に切れる問題を解決する|
	http://blog.kuborn.info/2013/11/macbook-air-13-inch-mid-2011windows81lan.html]
	*[Boot Camp Support Software 4.1.4586|https://support.apple.com/kb/DL1637?locale=ja_JP]
}

@include nav.i
