---
title: Excelメモ
pre: ../include/u.i
post: ../include/nav.i
---

.revision
2011年7月8日作成
=Excelメモ

セルをコピーするとアドレスをずらしてくれるのは、
だいたいの場合にとても便利ですが、
相対アドレスのままシフトせずにコピーしたいときもありまして。

まあ、全部手作業でやればいいかなあとも考えましたが、
件数が多くてめんどくさかったので固定コピー機能を書きました。
これを[個人用マクロブック|http://allabout.co.jp/gm/gc/297809/]に置いて、
AbsoluteCopyにCtl+Y、AbsolutePasteにCtl+Pあたりを割り当てました。
マクロメニューから呼び出すと、マクロが呼び出された時点で
Excelからみえるクリップボードが消えているためショートカットキー必須です。

!Sub AbsoluteCopy()
!	Dim p As Range
!	Dim p1 As Range
!	Dim w As Worksheet
!	Dim w1 As Worksheet
!	Dim addr As String
!	
!	addr = Selection.Address	' CreateTempの結果、アドレスが変わるので退避
!	Selection.Copy
!	Set w = ActiveSheet
!	Set w1 = CreateTemp("tmp")
!	Set p = w1.Range(addr)
!	p.PasteSpecial
!	For Each p1 In p
!		If p1.HasFormula Then
!			p1.Formula = Application.ConvertFormula(p1.Formula, xlA1, , xlAbsolute)
!		End If
!	Next
!	p.Copy
!	w.Activate
!	Debug.Print Application.ClipboardFormats(1)
!End Sub
!
!Sub AbsolutePaste()
!	Dim p1 As Range
!	
!	Selection.PasteSpecial
!	For Each p1 In Selection
!		If p1.HasFormula Then
!			p1.Formula = Application.ConvertFormula(p1.Formula, xlA1, xlA1, xlRelative)
!		End If
!	Next
!End Sub
!
!Function CreateTemp(ByVal s As String) As Worksheet
!	Dim i As Integer
!	Dim w As Worksheet
!	
!	If Not IsExist(s) Then
!		Set w = ThisWorkbook.Sheets.Add()
!		w.Name = s
!		Set CreateTemp = w
!		Exit Function
!	End If
!	
!	i = 1
!	Do While IsExist(s & i)
!		i = i + 1
!	Loop
!	
!	Set w = ThisWorkbook.Sheets.Add()
!	w.Name = s & i
!	Set CreateTemp = w
!End Function
!
!Function IsExist(ByVal s As String) As Boolean
!	Dim i As Integer
!	
!	For i = 1 To ThisWorkbook.Sheets.Count
!		If ThisWorkbook.Sheets(i).Name = s Then
!			IsExist = True
!			Exit Function
!		End If
!	Next
!	IsExist = False
!End Function

.aside
{
	=関連情報
	*[相対参照と絶対参照を変換する|
	http://www.officetanaka.net/excel/vba/tips/tips117.htm]
}
