@include u.i
%title foreachでノードを削除すると、1つ飛ばしに残る

=foreachでノードを削除すると、1つ飛ばしに残る
.revision
2007年1月27日作成

C#のTreeNodeCollection。
以下のプログラムだと、削除した結果1つずれますが、
さらにforeachでひとつ進めるので、
結果として偶数ぶんは残ってしまうのです。

!TreeNodeCollection p;
!..
!foreach(TreeNode q in p)
!	p.Remove(q);

全部消すならこちら。

!while(p.Count > 0)
!	p.Remove(p[0]);

条件付き削除の場合はこのように。

!int nskip = 0;
!while(nskip < p.Count)
!	if(...)
!		p.Remove(p[nskip]);
!	else
!		nskip++;

@include nav.i
