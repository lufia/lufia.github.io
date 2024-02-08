---
title: IL/IPv6対応
style: ../../../styles/global.css
pre: ../../../layouts/notes/u.i
post: ../../../layouts/notes/nav.i
---

.revision
2011年7月4日作成
=IL/IPv6対応

	さすがにそろそろIPv6は無視できないということで、
	ざっと[ILをIPv6に対応|../../plan9/src/il.c]させました。
	そのときのメモなどを少し書き残し。

	=IPv4とIPv6の違い

	当たり前ですが、ILそのものは特に変わりありません。
	雑に言うとIlhdrのIPヘッダ部分が違うだけなので、
	今回追加したコードはその振り分けとチェックサム計算部分です。

	Il6hdrの名前は、極力Il4hdrのものを残しました。
	IPv6の仕様ではnextheaderですがこれをprotoに、
	同様にhoplimitをttlとしました。

	=ヘッダの振り分け

	Block構造体があれば、そのrpからwpの間に、
	IPヘッダとデータが続けて格納されています。
	なので、これの最初4bitを調べると、IPバージョンが分かります。

	.c
	!Block *bp;
	!Il4hdr *h4;
	!Il6hdr *h6;
	!uchar version;
	!
	!h4 = (Il4hdr*)bp->rp;
	!version = ((h4->vihl&0xF0)==IP_VER6) ? V6 : V4;
	!switch(version){
	!case V4:
	!	...
	!	break;
	!case V6:
	!	h6 = (Il6hdr*)bp->rp;
	!	...
	!	break;
	!default:
	!	panic("ilxxx: version %d", version);
	!}

	ilkickなど、Blockが無い場合は、
	Conv構造体のipversionをみると判別できます。

	=チェックサム計算

	チェックサムはパケットが壊れていないかを判断するために使います。
	パケットの送信者がチェックサムフィールド(ilsum)を0として計算し、
	それをilsumに格納して送信します。
	データが届いたら、受信者はチェックサムを計算しますが、
	ここではilsumを受け取ったまま計算に含めます。
	データに破損がなければ、チェックサム値は0になります。
	詳しい話は置いておきますが、雑に書くと

	.c
	!~sum16(X + ~sum16(X)) = 0

	これは結局、0だった16bit数が~sum16(X)に置き換わるだけなので

	.c
	!~(sum16(X) + ~sum16(X)) = ~0xFFFF = 0

	次は実装について。

	IL/IPv4の場合、ILヘッダからチェックサムを計算します。
	これはIPv4がチェックサムを持っているから省略したのだと思われますが、
	IPv6では無くなっているので、IPヘッダも含めなければいけません。
	TCPやUDPでは[疑似ヘッダ|
	http://www.wdic.org/w/WDIC/%E7%96%91%E4%BC%BC%E3%83%98%E3%83%83%E3%83%80]
	を使っていますので、ILもそれに併せました。

	計算の実際では、疑似ヘッダをそのまま作ったりはしていません。
	その代わり、適当にそれっぽい値を割り当てて、まとめて計算しています。
	具体的には以下の通り。

	|*仕様*		*Il6hdrメンバ*
	|Length		viclfl
	|Zero(16bit)	len
	|Zero(8bit)	proto
	|Next Header	ttl
	|Source Addr	src
	|Dest Addr	dst

	暗号などと違い、チェックサムの計算アルゴリズムは比較的ゆるく、
	先頭から順に16bit数として加算し、その結果から1の補数を求める、
	というものなので順番が違っても問題にはならないのですね。

	=その他メモ

	ttlとtosは、ipoput4またはipoput6が設定しているので
	パケット組み立て時には気にしなくてもいいみたい。
	IPv6ヘッダにtosはありませんが、
	同等のものがviclflの5ビット目から12ビット目まで。

	IL/IPv6ヘッダは、長さフィールドがIPv6側とIL側にあります。
	これはどちらもIPヘッダを除いた長さ(ILヘッダ長+データ長)なので、
	illenはいらないかなあとは思いますけど、どうでしょうか。

.aside
{
	=関連情報
	*[il.cを読む|0618.w]
}
