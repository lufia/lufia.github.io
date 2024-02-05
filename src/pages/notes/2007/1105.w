---
title: HDDエラーのトラブルシューティング
style: ../../../styles/global.css
pre: ../include/u.i
post: ../include/nav.i
---

.revision
2007年11月5日作成
=HDDエラーのトラブルシューティング

Plan 9ファイルサーバが、ブート直後は動いているのに、
しばらくすると反応しなくなるようになっていました。
クライアントからlsなどでアクセスすると反応なし。
ファイルサーバからstatd, statwでも反応なし。
コンソールにはSCSIエラーコード=-4、だったかな。

原因はSCSIケーブル不良だったのですが。
そのときに調べたサイトをメモ。

:[HDDタイムアウトに関するエラー メッセージのトラブルシューティング|
http://support.microsoft.com/kb/314093/ja]
-すごく役に立った。ID=11とかID=9とかは関係ないけど。
:[Additional sense codes および additional sense code qualifiers|
http://www.linux.or.jp/JF/JFdocs/SCSI-Programming-HOWTO-22.html]
-fs64の場合、エラーコードは/sys/src/fs/fs64/io.hにある
:[ホストバス関連コラム|
http://www.newtech.co.jp/topics/column/hba/]
-LVD/SEは混在してもいいのか、とか。ケーブル長とか。
