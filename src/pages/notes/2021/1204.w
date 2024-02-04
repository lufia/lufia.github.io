---
title: GitのCombined Diffフォーマット
pre: ../include/u.i
post: ../include/nav.i
---

.revision
2021年12月4日作成
=GitのCombined Diffフォーマット

	通常のコミットに対して

	.console
	!% git diff

	すると、Unified Diffフォーマットで出力されます。
	このフォーマットでは左側1文字目の文字をみることで、
	その行が追加されたのか削除されたのか、を見わけることができます。

	.diff
	!diff --git a/sys/src/cmd/auth/factotum/totp.c b/sys/src/cmd/auth/factotum/totp.c
	!index f32caa77..95202886 100644
	!--- a/sys/src/cmd/auth/factotum/totp.c
	!+++ b/sys/src/cmd/auth/factotum/totp.c
	!@@ -50,7 +50,7 @@ base32d(uchar *dest, int ndest, char *src, int nsrc)
	!        tab = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567";
	!        while(nsrc>=8){
	!                for(i = 0; i < 8; i++){
	!-                       s = strchr(tab, src[i]);
	!+                       s = strchr(tab, toupper(src[i]));
	!                        if(s == nil)
	!                                return -1;
	!                        u[i] = s-tab;

	`+`の行は追加、`-`の行は削除、変更のない行はスペースです。

	=マージコミットの場合

	Gitでマージしたとき、以下の3つが登場します。

	+共通の祖先(`-1`, `--base`)
	+自分たちの差分(`-2`, `--ours`)
	+相手側(マージするブランチ)の差分(`-3`, `--theirs`)

	例えば、

	.console
	!% git switch main
	!% git merge other

	と実行した場合、`--base`は*main*と*other*の共通にある祖先、
	`--ours`は*main*の差分、`--theirs`は*other*の差分となります。

	マージまたはリベース時にコンフリクトが発生したとき、
	通常のdiffとは異なり、左側の先頭2文字で状態を表現するフォーマットが使われます。

	.diff
	!diff --cc sys/src/ape/lib/ap/plan9/_buf.c
	!index a2dea18c,67f3f9c6..00000000
	!--- a/sys/src/ape/lib/ap/plan9/_buf.c
	!+++ b/sys/src/ape/lib/ap/plan9/_buf.c
	!@@@ -349,7 -348,7 +404,13 @@@ select(int nfds, fd_set *rfds, fd_set *
	!        }
	!        mux->selwait = 1;
	!        unlock(&mux->lock);
	!++<<<<<<< HEAD
	! +      fd = (uintptr_t)_RENDEZVOUS(&mux->selwait, 0);
	!++||||||| 338bd13f
	!++      fd = _RENDEZVOUS((uintptr_t)&mux->selwait, 0);
	!++=======
	!+       fd = _RENDEZVOUS((unsigned long)&mux->selwait, 0);
	!++>>>>>>> stable
	!        if(fd >= 0) {
	!                b = _fdinfo[fd].buf;
	!                if(FD_ISSET(fd, &mux->rwant)) {

	このフォーマットはCombined Diffフォーマットといって、
	`--ours`に含まれる差分は1文字目、`--theirs`に含まれる差分は2文字目を使って表します。
	また、どちらにも存在しない(新規の)差分を`++`で表現します。
	上記例の場合、`++`となっているのはマージ失敗によりGitが追加した行ですね。

	このコンフリクトを解消してコミットすると、また少し異なる表示になります。

	.diff
	!diff --cc sys/src/ape/lib/ap/plan9/_buf.c
	!index a2dea18c,67f3f9c6..f6bd186a
	!--- a/sys/src/ape/lib/ap/plan9/_buf.c
	!+++ b/sys/src/ape/lib/ap/plan9/_buf.c
	!@@@ -349,7 -348,7 +348,7 @@@ select(int nfds, fd_set *rfds, fd_set *
	!  	     }
	!        mux->selwait = 1;
	!        unlock(&mux->lock);
	!-       fd = (uintptr_t)_RENDEZVOUS(&mux->selwait, 0);
	! -      fd = _RENDEZVOUS((unsigned long)&mux->selwait, 0);
	!++      fd = (int)_RENDEZVOUS(&mux->selwait, 0);
	!        if(fd >= 0) {
	!                b = _fdinfo[fd].buf;
	!                if(FD_ISSET(fd, &mux->rwant)) {

	これも同様に、`--ours`の差分を1文字目、
	`--theirs`の差分を2文字目を使って表しますが、
	上記のdiffはマージした結果なので、

	*`--ours`のブランチにあった行を削除
	*`--theirs`のブランチにあった行も削除
	*代わりに、`++`の行を追加

	このように編集すると、現在のブランチ内容と同じになる、という意味です。

	=参考

	*[Git - 高度なマージ手法|
	https://git-scm.com/book/ja/v2/Git-%E3%81%AE%E3%81%95%E3%81%BE%E3%81%96%E3%81%BE%E3%81%AA%E3%83%84%E3%83%BC%E3%83%AB-%E9%AB%98%E5%BA%A6%E3%81%AA%E3%83%9E%E3%83%BC%E3%82%B8%E6%89%8B%E6%B3%95#_combined_diff_%E5%BD%A2%E5%BC%8F]
