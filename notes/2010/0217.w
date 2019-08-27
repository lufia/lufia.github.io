@include u.i
%title Accessメモ

=Accessメモ
.revision
2010年5月12日更新

	=イベントの発生順序
	+BeforeInsert
	+BeforeUpdate
	+AfterUpdate
	+AfterInsert

	印象と違っていたのでメモ。
	AfterInsertのほうがAfterUpdateより先だと思ってました。

	=OldValueを参照するとエラー
	TextBox.OldValueプロパティを参照するとエラーになって割と困りました。
	現象としては、値がNullとかではなく、プロパティが参照できません。
	これは、1対多リレーションシップのとき、
	1側のデータについてOldValueを調べると発生します。

	解決策は、Currentで値を残しておいて、あとからそれを調べるようにします。

	=OldValueの疑問
	たとえばTextBox.Valueを"テスト"から"test"に書き換えた場合。
	BeforeUpdateではOldValue="テスト"でしたが、
	AfterUpdateになるとOldValue="test"になっていました。
	これは何か他の要因？それともそういう仕様？

	=BeforeInsertイベントが発生しない
	ヘルプによると、プログラムから値を挿入した場合は発生しない、とあります。
	でも、たぶん。最初にどこをキックしたかによって変ってくるのではないかなあ。

	*ヘルプの通り、プログラムから挿入した場合は基本的には発生しない
	*最初に入力があったものがコントロールを介しての場合、プログラムからでも発生する
	*新しい行の最初に値が入ったとき、がBeforeInsertのタイミング
	*なので、それ以降はコントロールを介していようが発生しない

	まとめると、プログラムから扱う場合、Me!Itemがフィールドの場合は発生しないで、
	フィールドをバインドしたコントロールの場合は発生ということ？

	=NotInListイベント
	ComboBox.NotInListイベントは、入力チェックが有効になっていないと反応しない。

	=オートナンバーを持つテーブルをコピーする方法

	オートナンバーをキーにしている場合、
	番号がずれるとリレーションも切れてしまうので調べた。

	クエリを使ってinsertすればコピーできる。
	その際は、元のテーブルが記録していた次の番号のほうが大きければそれ。
	挿入したデータのほうが大きければその次の番号となる。

	リレーションがあってもコピーできるが、順番には注意。

	=オートナンバーのリセット
	!CurrentProject.Connection.Execute _
	!	CommandText:="Alter Table テーブル名 " _
	!		& "Alter Column フィールド名 Identity( 1, 1 );"

	または、

	!DoCmd.RunSQL "alter table tablename alter column columnname counter(1)"

	ただし、リレーションシップが張られている場合はエラーになる

.aside
{
	=関連情報
	*[SQL Serverのメモ|../2011/0805.w]
}
@include nav.i
