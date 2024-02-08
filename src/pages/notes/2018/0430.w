---
title: 「ローカル項目」キーチェーンはiCloud Keychainのゴミ
style: ../../../styles/global.css
pre: ../../../layouts/notes/u.i
post: ../../../layouts/notes/nav.i
---

.revision
2018年4月30日作成
=「ローカル項目」キーチェーンはiCloud Keychainのゴミ

iCloud Keychainをオフにした状態でキーチェーンアクセスを開くと、
左上のリストに「ローカル項目」というキーチェーンが表示される。
これ自体は消すこともリネームもできない。

ローカル項目はiCloud Keychainで同期するためのキーチェーンで、
有効にしている場合はこの名前が「iCloud」に変わり、iCloud Keychainに同期される。
iCloud Keychainは、「iCloud」キーチェーンだけ対象になる。
iCloud Keychainを無効にすると「ローカル項目」となり、消せなくなる。

*[OS X 10.9 Mavericks: The Ars Technica Review|
https://arstechnica.com/gadgets/2013/10/os-x-10-9/5/]

「ログイン」と「ローカル項目」のどちらに保存するのかはアプリの実装による。
キーチェーンアイテムの種類が*アプリケーションパスワード*
または*Webフォームパスワード*で、かつ`kSecAttrSynchronizable`が`true`の場合に、
保存先が「ローカル項目」になる。

*[Keychainのバックアップについて調べた|
https://qiita.com/yukatou/items/05aec5dcc28e3271fd84]

iCloudを有効にしてしまうと、初回ログイン時に
デフォルトでiCloud Keychainが有効になるため、
このデザインはどうなんだろうと思う。
