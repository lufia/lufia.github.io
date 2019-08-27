@include u.i
%title ファイルの暗号化と複合

=ファイルの暗号化と複合
.revision
2006年10月2日更新

	ファイルを暗号化や複合する場合は、auth/aescbcで行う。
	どちらも暗号用パスワードの入力が必要。

	=暗号化

	!% auth/aescbc –e <cleartext >ciphertext

	=複合

	!% auth/aescbc –d <ciphertext >cleartext

.aside
{
	=関連情報
	*[secstoreの使い方|secstore.w]

	=マニュアル
	*[secstore(1)]
}

@include nav.i
