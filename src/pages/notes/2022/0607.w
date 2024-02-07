---
title: ffmpegでHTTPリクエストにヘッダを追加する
style: ../../../styles/global.css
pre: ../../../layouts/notes/u.i
post: ../../../layouts/notes/nav.i
---

.revision
2022年6月7日作成
=ffmpegでHTTPリクエストにヘッダを追加する

HLSをダウンロードする際に、`ffmpeg`にHTTPヘッダを指定したいことがある。
その場合、`ffmpeg`には`-headers`オプションがあるので、これを使うとよい。

.console
!$ ffmpeg -headers 'User-Agent: xx' -i 'https://example.com/movie.m3u8?q=xx' ...
!
!# User-Agent*の場合は`-user_agent`オプションが特別に用意されているので、
!# これで代用してもよい
!$ ffmpeg -user_agent 'xx' -i 'https://example.com/movie.m3u8?q=xx'

ここで、複数ヘッダを指定したい場合は、`-headers`オプションの値をCRLFで区切って与えるらしい。

.console
!$ ffmpeg -headers $'User-Agent: xx\r\nAuth-Token: xx\r\n' -i ...

ところで、`-headers`オプションと`-i`オプションを逆にすると、
実際のリクエストにヘッダが反映されない。

.console
!$ ffmpeg -i ... -headers ... # これは期待通りに動かない

この理由は、`ffmpeg`には[concatフィルタ|
https://trac.ffmpeg.org/wiki/Concatenate]など、
複数ストリームを扱うフィルタがあって、このとき複数の`-i`オプションを
与えることで一時ファイルを経由せずストリームを結合できるようになっている。
そのため、`-headers`のようなオプション(マニュアルによるとinfile options)は、
「次に出現する`-i`オプション」に対して反映される。
上記のコマンドでは、`-i`オプションの前には`-headers`がないので
デフォルトのヘッダでURLにリクエストするし、
また、`-headers`オプションの後に`-i`オプションがないのでこれは単に無視される。

実際にどのようなリクエストを送っているかは`-loglevel`オプションで確認できる。

.console
!$ ffmpeg -loglevel debug ...

.aside
{
	*[Packet corruption during download, then ffmpeg hangs|
	https://superuser.com/questions/1656570/packet-corruption-during-download-then-ffmpeg-hangs]
}
