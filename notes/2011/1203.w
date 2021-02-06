@include u.i
%title フレッツ光プレミアムの設定

.revision
2011年12月3日作成
=フレッツ光プレミアムの設定

	=前置き
	ずいぶん前の話ですが、フレッツ光プレミアムの設定をしたので
	記憶にある限りをメモしておきます。
	別の回線だと動いていたものを光プレミアムに移したら動かなくなった、
	という場合、これじゃないかと思われます。

	=CTUをブリッジモードに
	まずコレ、CTUというものがルータの役目をしているので、
	自分で用意したルータからプロバイダへ繋ぐには、CTUの設定を
	変更しなければなりません。CTUにつなげた状態から
	https://ctu.fletsnet.comにログインして、
	PPPoEパススルーか何かのメニューで、CTUをブリッジモードに変更します。
	設定する場所は忘れましたがたぶん見れば分かるのではないかと。

	=MTU
	次に、光プレミアムのMTUは他の回線に比べて若干小さい値です。

	|*回線*				*MTU*
	|PPPoE				1492
	|フレッツ光			1454
	|フレッツADSL			1454
	|フレッツ光プレミアム	1438

	なので、自動で認識しないルータの場合は、これの変更も必要です。

.aside
{
	=参考サイト
	*[自宅サーバLAN内の構成とCTUの設定例|
	http://sakaguch.com/SetCTUandLAN.html]
	*[BフレッツのMTUサイズ|http://www.infraexpert.com/info/6adsl.htm]
}

@include nav.i
