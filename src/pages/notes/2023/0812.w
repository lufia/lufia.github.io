---
title: Goで繰り返しごとにスリープしたい時の書き方
style: ../../../styles/global.css
pre: ../include/u.i
post: ../include/nav.i
---

.revision
2023年8月12日作成
=Goで繰り返しごとにスリープしたい時の書き方

初回を除いて繰り返し処理ごとにスリープを挟みたい場合がある。
例えば、成功するまでリトライが必要な場合とか、
他のリソースが変化するまでポーリングを行なう場合などが想定される。

丁寧に実装したい場合はライブラリを探すといいと思うが、
簡単な実装でいいなら`for`を使って書ける。

.go
!for ;; time.Sleep(delay) {
!	...
!}

このコードはgolang-nutsの[Looping and tail-end code|
https://groups.google.com/g/golang-nuts/c/aZhtxUv3pdQ]を参照した。
