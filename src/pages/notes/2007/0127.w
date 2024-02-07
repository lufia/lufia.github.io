---
title: foreachでノードを削除すると、1つ飛ばしに残る
style: ../../../styles/global.css
pre: ../../../layouts/notes/u.i
post: ../../../layouts/notes/nav.i
---

.revision
2007年1月27日作成
=foreachでノードを削除すると、1つ飛ばしに残る

C#のTreeNodeCollection。
以下のプログラムだと、削除した結果1つずれますが、
さらにforeachでひとつ進めるので、
結果として偶数ぶんは残ってしまうのです。

.cs
!TreeNodeCollection p;
!..
!foreach(TreeNode q in p)
!	p.Remove(q);

全部消すならこちら。

.cs
!while(p.Count > 0)
!	p.Remove(p[0]);

条件付き削除の場合はこのように。

.cs
!int nskip = 0;
!while(nskip < p.Count)
!	if(...)
!		p.Remove(p[nskip]);
!	else
!		nskip++;
