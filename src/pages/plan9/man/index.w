---
title: 自作ツール集
style: ../../../styles/global.css
pre: ../../../layouts/plan9/u.i
post: ../../../layouts/plan9/nav.i
---

=自作ツール集
.revision
2011年7月23日

	=更新情報

	:2012/10/07
	-AMD Vlanceドライバ追加
	:2011/07/23
	-E1000ドライバ追加
	:2011/07/01
	-IL/IPv6追加
	:2010/01/18
	-map言語を追加
	:2009/09/11
	-WebSlice削除

	=プログラム

	.main-cards
	:[notefs|/plan9/src/notefs.c]
	-メモを書き溜めるだけのファイルサーバ
	-newに書けば、書いた日の$year/$mon/$day/$idに保存する
	:[monafs|/plan9/src/monafs.tgz]
	-2ちゃんねるを読むためのファイルサーバ
	-[マニュアル|monafs.w]
	:[wf|/plan9/src/wf.tgz]
	-wikiのような文法の、HTML5ジェネレータ
	-[マニュアル|wf.w]
	:[tc|/plan9/src/tc.tgz]
	-t-code入力用プログラム
	:[msnfs|/plan9/src/msnfs.tgz]
	-MSN Messenger file serer
	:[dryad|/plan9/src/dryad.awk]
	-簡易ユニットテストツール
	-[マニュアル|dryad.w]
	:map言語
	-マップを描画する言語とそのジェネレータ
	-使用例は[エストポリスのページ|../../estpolis/map/index.w]あたりに
	-[マニュアル|map.w]

	=一般カーネル用パッチ

	.main-cards
	:[IL/IPv6|../src/il.c]
	-ilにIPv6パッチを当てたもの
	-詳しくは[カーネルにilを組み込む|../doc/inst/il.w]を参照

	=ファイルサーバカーネル用パッチ

	.main-cards
	:[AMD Vlance|../src/ether79c970.c]
	-VMware ESXiのデバイスに対応させた
	-詳しくは[VMware ESXiにPlan 9を移行したときのトラブルまとめ|
	../../notes/2012/1006.w]を参照
	:[E1000|../src/etherigbe.c]
	-ファイルサーバカーネルのE1000ドライバ
	-VMware Playerのデバイスに対応させた
	-詳しくは[VMware Playerにファイルサーバをインストール|
	../../notes/2011/0723.w]を参照

	=失敗作

	.main-cards
	:[win9p|/plan9/src/win9p.zip]
	-Pythonで書いた、9P用Windowsシェル名前空間拡張
	-ドライブレター割り当てが不可能のため機能の実装が不可能と分かり、廃棄
