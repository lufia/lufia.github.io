---
title: IPv6の実装を読むよ(途中)
style: ../../../styles/global.css
pre: ../../../layouts/notes/u.i
post: ../../../layouts/notes/nav.i
---

.revision
2011年8月8日作成
=IPv6の実装を読むよ(途中)

	:Ipselftab
	:Ipself
	-チェインハッシュで実装されたローカルアドレスのキャッシュ
	-ルーティング用らしい
	:Ipmcast
	-マルチキャストのリストらしいが使ってないと思う
	:Ipifc
	-インターフェイスカード
	-rpはルータパラメータ
	:Routerparams
	-MTUとかいろいろなパラメータ
	-ipifcra6()で設定している

	=esp.c

	途中

	=ipaux.c

	途中

	=ipmux.c

	途中

	=ipv6.c

		=ipoput6

		!if(送信元アドレスが一時アドレス)
		!	ブロックを解放して終える
		!if(gating){
		!	いろいろ
		!}
		!ルート = v6lookup(送信先アドレス)
		!if(ルートのタイプが(Rifc|Runi))
		!	ゲート = 送信先アドレス
		!else if(ルートのタイプが(Rbcast|Rmulti)){
		!	ゲート = 送信先アドレス
		!	sr = v6lookup(送信元アドレス)
		!	if(srがユニキャストアドレス)
		!		ifc = sr->ifc
		!}else
		!	ゲート = ルート->v6.gate
		!
		!ブロックのヘッダにversion, ttl, tosを設定
		!if(ブロック長 <= 1度に送れる容量){
		!	bwrite(ブロック, V6, ゲート)
		!	return 0
		!}
		!if(gating && reassemble <= 0)
		!	discard
		!
		!for(フラグメント)
		!	分割して、1つずつbwrite()

		bwriteはethermedium.cで定義されているetherbwriteのこと。

	=ethermedium.c

		=etherbwrite

		!a = arpget(送信先アドレス, &MACアドレス)
		!if(a){
		!	// ARP未解決の場合
		!	bp = multicastarp(a, &MACアドレス)
		!	if(bp == nil){
		!		versionによりsendarp(v4)かresolveaddr6(v6)を呼び出す
		!		return
		!	}
		!}
		!bp = ブロックにetherヘッダ領域を確保
		!bp = ブロックのリストをひとつにまとめる
		!if(bpの長さが最小転送量より小さい)
		!	bp = adjustblock(bp)
		!eh = bpのetherヘッダ領域
		!ehに送信元/送信先のMACアドレスを設定
		!switch(version){
		!case V4:
		!	...
		!case V6:
		!	eh->t[0] = 0x86
		!	eh->t[1] = 0xDD
		!	devtab[mchan6->type]->bwrite(bp)
		!}

		=multicastarp

		!switch(ipforme(アドレス)){
		!case ユニキャスト:
		!	return nil
		!case ブロードキャスト:
		!	memset(MACアドレス, 0xff, 6)
		!	return arpresolve(ARPテーブル, ARPリクエスト, MACアドレス)
		!}
		!switch(multicastea(MACアドレス, アドレス)){
		!V6でもV4でも:
		!	return arpresolve(ARPテーブル, ARPリクエスト, MACアドレス)
		!}

		=resolveaddr6

		!if(ARPエントリがタイムアウト){
		!	arprelease(ARPエントリ)
		!	return
		!}
		!ARPエントリの待機リストから最後を残して削除
		!ARPエントリをいろいろ設定
		!if(sflag = ipv6anylocal(ipsrc))
		!	icmpns(ipsrc, TARG_MULTI, MACアドレス)

	=arp.c

		=arpget

		指定のIPアドレスがすでに解決されていれば、
		そのMACアドレスを引数に詰めてnilを返す。
		なければ、newarp6を呼び出しその戻り値を返す。

		!a = 指定のIPアドレスでarpテーブルを調べる
		!if(a == nil){
		!	a = newarp6(arpテーブル, V6なら1)
		!	aの状態をAWAITに
		!}
		!a->utime = NOW
		!if(aの状態がAWAIT){
		!	aの待機リスト(hold)に送るつもりのブロックを追加
		!	return a
		!}
		!引数macにarpで取得したMACアドレスを書き込む
		!if(aが古いエントリなら)
		!	cleanarpent(arpテーブル, a)
		!return nil

		=newarp6

		!a = 最も古いARPリクエスト
		!if(aがIPv4でなければ){
		!	arpのドロップリストにaの待機リストを追加
		!	wakeup(&arp->rxmtq)
		!}
		!arpハッシュ(hash)からaを削除
		!arpハッシュに新しくaを追加
		!aのip, utime, ctime, type, rtime, etcを更新
		!
		!if(!ipismulticast(a->ip) && version==V6){
		!	再送チェイン(rxmt)に登録？
		!}
		!a->nextrxt = nil
		!return a

		=arpresolve

		!a = ARPテーブルより調べるARPエントリを取り除く
		!memmove(a->mac, mac, len)
		!bp = aの待機リスト
		!aのtype, state, utime, holdをリセット
		!return bp

	=iproute.c

	途中

	=ip.c

	ip6パラメータとかフラグメントの初期化。

	ipiput4でバージョン判定してipiput6呼び出し。

	=ipifc.c

	:addselfcache
	-自分自身のIPアドレスをキャッシュに追加
	:iptentative
	-指定のアドレスが自分のものなら、それが一時的なものか調べる
	-一時的なアドレスなら1
	:ipforme
	-指定のアドレスが自分のものなら、その種類(uni, bcast, mcast)を返す
	-自分のアドレスでなければ0
	:v6addrtype
	-指定のアドレスがどのクラス(linklocalv6, globalv6)か調べる
	:findprimaryipv6
	-優先順にグローバル、リンクローカル、未指定でローカルアドレスを調べる
	-見つかれば引数localにそのアドレスが渡される

	=icmp6.c

	途中
