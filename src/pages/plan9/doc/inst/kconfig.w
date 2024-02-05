---
title: カーネルコンフィグの種類
style: ../../../../styles/global.css
pre: ../../include/u.i
post: ../../include/nav.i
---

.revision
2014年2月22日作成
=カーネルコンフィグの種類

Plan 9は標準でいくつかカーネルコンフィグを用意しています。
コンフィグファイルは、Intel系CPUの場合、*/sys/src/9/pc*以下に置かれています。

|*ファイル名*	*ファイルシステム*	*用途*
|pcf			fossil			Plan 9端末
|pcdisk		kfs				Plan 9端末
|pc			-				ディスクレスPlan 9端末
|pccpuf		fossil			CPUサーバ
|pccpu		-				ディスクレスCPUサーバ
|pcauth		fossil			pccpufベースの認証サーバ
|pcfs			fossil			pccpufベースの単体ファイルサーバ
|pccd		kfs				インストーラ用
|pcflop		kfs				フロッピー版インストーラ?

pcfsは、ファイルサービスをするだけのカーネルみたいでした。
pccpufとpcfsの主な違いは、ざっくり以下の2点です。

* pcfsは管理に必要なコマンド類を全てカーネルに埋め込む
* pcfsは各種設定を環境変数から取得する

サーバの運用にディスクを必要としなくなるため、
fsカーネルに近い運用形態になるのではないでしょうか。

.aside
{
	=参考ページ
	*[Compiling kernels|
	https://9p.io/wiki/plan9/compiling_kernels/index.html]
}
