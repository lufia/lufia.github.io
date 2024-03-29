---
title: Vistaの画像タグ保存場所
style: ../../../styles/global.css
pre: ../../../layouts/notes/u.i
post: ../../../layouts/notes/nav.i
---

.revision
2009年5月26日作成
=Vistaの画像タグ保存場所

Vistaに付属するフォトギャラリーは、
画像をタグで管理できるようになっていますが、さてさて、このタグ。
メールに添付されていた画像にもタグが残ったままになっていたので、
どのように保存されているのか調べてみました。

まず、JPEG形式はファイルに埋め込んでいます。Adobeの[XMP|
http://www.antenna.co.jp/XML/xmllist/XMP/AboutXMP.htm]
を使っているようです。画像を[strings(1)|
http://www.vitanuova.com/inferno/man/1/strings.html]
にかけると、XMLがずらずらと表示されます。

ずいぶん前の記事ですが、[メタデータとAdobeの思惑|
http://pc.watch.impress.co.jp/docs/2004/0716/config009.htm]
によれば、必ずしも埋め込まないといけないわけではないようですね。

>このデータは、ファイルに埋め込むこともできれば、
>サイドカーファイルとして別に持たせることもできます。
>この場合、純粋にXMLファイルが用意されますから応用はさらに容易になります。

信頼できない情報筋によれば、JPEGのほかにTIFFやHD Photoも埋め込むようです。

次に、JPEG以外のファイル(GIF, PNGなど)は、
XMPの埋め込みに対応していないので埋め込むことができません。
どうやらXMP自体はGIFやPNGへの埋め込みにも対応しているようですが、
少なくともVistaのフォトギャラリーは対応していません。
この場合、フォトギャラリーからタグの追加はできるのですが、
メール添付はもちろん、ファイルをコピーした場合にもタグは引き継がれませんし、
エクスプローラからプロパティを開いても、タグの項目がありません。
さらに、ファイル名の変更にも対応できていません。
フォトギャラリーから名前の変更をした場合は、タグもいっしょに付いてきますが、
エクスプローラから変更した場合には、タグが消えてしまいます。

うーん、メタデータもデータの一部なので、
通常の操作で勝手に消えるというのはどうなのかなあ、と思います。
Windows Live Photo Galleryでは改善されているのでしょうか。。

最後に、タグの削除のこと。Vistaのエクスプローラから、
JPEGファイルのプロパティを開いて詳細を選択すると、
「プロパティや個人情報を削除」という機能があります。
これを使えばXMPとして埋め込まれているタグそのものを消すことができますが、
XMPの枠組み自体は、依然としてJPEGファイルに埋め込まれたままです。
そのままでもファイル容量が増える以外に害はありませんが、
気になる場合は[JPEG Cleaner|
http://internet.watch.impress.co.jp/cda/biz_tool/2008/06/17/19953.html]
を使えば、枠組みから他にもいろいろ消してくれます。
