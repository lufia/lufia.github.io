---
title: うまくない
pre: ../include/u.i
post: ../include/nav.i
---

.revision
2007年4月17日作成
=うまくない

昨日の様子見で1日置いてみましたが、dumpがはじまると、
昨日までと同様に*mirrwrite $dev error at block $addr*になりました。
今度は*mirrread f{h0h2} error at block $addr*も出るように。。

あと、起動時dumpの順番も嘘っぽい。
結局プロンプトが出てから*mirrwrite error*になった。
でも少なくとも*cannot access /adm/users*は出なくなったので、
まあ効果はあったのかな。

今度は、マザーボードのIDEに繋がったHDDを、
SATAカードのほうに移行してみようかと思います。
