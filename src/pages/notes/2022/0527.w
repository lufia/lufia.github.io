---
title: LINEに配達状況が突然届いた
style: ../../../styles/global.css
pre: ../../../layouts/notes/u.i
post: ../../../layouts/notes/nav.i
---

.revision
2022年5月27日作成
=LINEに配達状況が突然届いた

こないだピザを注文したとき、該当企業を友だち追加していなかったけれども、
配送時間などが個人のLINEアカウントに届いて驚いた。
メッセージを読む限りでは、企業が持っている電話番号を使って、
同じ電話番号を所有するLINEアカウントにメッセージを送るものらしい。

実態は[LINE通知メッセージ|
https://developers.line.biz/ja/docs/partner-docs/line-notification-messages/]という機能で
実現されているようだった。このドキュメントによると、

>LINE通知メッセージの利用用途は、弊社がユーザーにとって
>有⽤かつ適切であると判断したものに限定されます。
>営利⽬的および広告⽬的のものは送信できません。

とあるので、この通知が悪用されることはないとは思うが、
とはいえ電話番号を登録した意図はあくまで多要素認証のためであって、
決して個人識別のIDとして登録したわけではないので、意図しない用途で使わないで欲しい。

LINEでは、電話番号を使った友だち検索機能があり、それは

+設定
+友だち
+「友だち自動追加」と「追加の許可」をオフにする

で無効化できるが、LINE通知メッセージは別の扱いになっており、

+設定
+プライバシー管理
+情報の提供
+通知メッセージ
+「通知メッセージを受信」をオフにする

で無効化する。

*[LINEで企業から来る通知メッセージ機能をオン・オフに設定する方法|
https://maiuma.com/line-noticemessage/]
