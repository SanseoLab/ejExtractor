' https://gallery.technet.microsoft.com/Encode-and-Decode-a-VB-a480d74c


Option Explicit

Const BIF_NEWDIALOGSTYLE = &H40
Const BIF_NONEWFOLDERBUTTON = &H200
Const BIF_RETURNONLYFSDIRS = &H1

Const FOR_READING = 1
Const FOR_WRITING = 2


Const TAG_BEGIN1 = "#@~^" 
Const TAG_BEGIN2 = "==" 
Const TAG_BEGIN2_OFFSET = 10 
Const TAG_BEGIN_LEN = 12
Const TAG_END = "==^#~@" 
Const TAG_END_LEN = 6

Dim argv
Dim wsoShellApp
Dim oFolder
Dim sFolder
Dim sFileSource
Dim sFileDest
Dim fso
Dim fld
Dim fc
Dim bEncoded
Dim fSource
Dim tsSource
Dim tsDest
Dim iNumExamined
Dim iNumProcessed
Dim iNumSkipped

Function Decode(Chaine)
	Dim se,i,c,j,index,ChaineTemp
	Dim tDecode(127)
	Const Combinaison="1231232332321323132311233213233211323231311231321323112331123132"

	Set se=WSCript.CreateObject("Scripting.Encoder")
	For i=9 to 127
		tDecode(i)="JLA"
	Next
	For i=9 to 127
		ChaineTemp=Mid(se.EncodeScriptFile(".vbs",string(3,i),0,""),13,3)
		For j=1 to 3
			c=Asc(Mid(ChaineTemp,j,1))
			tDecode(c)=Left(tDecode(c),j-1) & chr(i) & Mid(tDecode(c),j+1)
		Next
	Next
	
	tDecode(42)=Left(tDecode(42),1) & ")" & Right(tDecode(42),1)
	Set se=Nothing

	Chaine=Replace(Replace(Chaine,"@&",chr(10)),"@#",chr(13))
	Chaine=Replace(Replace(Chaine,"@*",">"),"@!","<")
	Chaine=Replace(Chaine,"@$","@")
	index=-1
	For i=1 to Len(Chaine)
		c=asc(Mid(Chaine,i,1))
		If c<128 Then index=index+1
		If (c=9) or ((c>31) and (c<128)) Then
			If (c<>60) and (c<>62) and (c<>64) Then
				Chaine=Left(Chaine,i-1) & Mid(tDecode(c),Mid(Combinaison,(index mod 64)+1,1),1) & Mid(Chaine,i+1)
			End If
		End If
	Next
	Decode=Chaine
End Function

Sub Process (s)
	Dim bProcess
	Dim iTagBeginPos
	Dim iTagEndPos


	iNumExamined = iNumExamined + 1

	iTagBeginPos = Instr(s, TAG_BEGIN1)

	Select Case iTagBeginPos
	Case 0
		MsgBox sFileSource & " does not appear to be encoded.  Missing Beginning Tag.  Skipping file."
		iNumSkipped = iNumSkipped + 1

	Case 1
		If (Instr(iTagBeginPos, s, TAG_BEGIN2) - iTagBeginPos) = TAG_BEGIN2_OFFSET Then
			iTagEndPos = Instr(iTagBeginPos, s, TAG_END)

			If iTagEndPos > 0 Then
				Select Case Mid(s, iTagEndPos + TAG_END_LEN)
				Case "", Chr(0)
					bProcess = True

					If fso.FileExists(sFileDest) Then
						If MsgBox("File """ & sFileDest & """ exists.  Overwrite?", vbYesNo + vbDefaultButton2) <> vbYes Then
							bProcess = False
							iNumSkipped = iNumSkipped + 1
						End If
					End If

					If bProcess Then
						s = Decode(Mid(s, iTagBeginPos + TAG_BEGIN_LEN, iTagEndPos - iTagBeginPos - TAG_BEGIN_LEN - TAG_END_LEN))

					

						Set tsDest = fso.CreateTextFile(sFileDest, TRUE, FALSE)
						tsDest.Write s
						tsDest.Close
						Set tsDest = Nothing

						iNumProcessed = iNumProcessed + 1
					End If

				Case Else
					MsgBox sFileSource & " does not appear to be encoded.  Found " & Len(Mid(s, iTagEndPos + TAG_END_LEN)) & " characters AFTER Ending Tag.  Skipping file."
					iNumSkipped = iNumSkipped + 1
				End Select

			Else
				MsgBox sFileSource & " does not appear to be encoded.  Missing ending Tag.  Skipping file."
				iNumSkipped = iNumSkipped + 1
			End If

		Else
			MsgBox sFileSource & " does not appear to be encoded.  Incomplete Beginning Tag.  Skipping file."
			iNumSkipped = iNumSkipped + 1
		End If

	Case Else
		MsgBox sFileSource & " does not appear to be encoded.  Found " & (iTagBeginPos - 1) & "characters BEFORE Beginning Tag.  Skipping file."
		iNumSkipped = iNumSkipped + 1
	End Select
End Sub

Set argv = WScript.Arguments 

sFileSource = ""
sFolder = ""
iNumExamined = 0
iNumProcessed = 0
iNumSkipped = 0

Select Case argv.Count
Case 0
	Set wsoShellApp = WScript.CreateObject("Shell.Application")

	On Error Resume Next
	set oFolder = wsoShellApp.BrowseForFolder (0, "Select a folder containing files to decode", BIF_NEWDIALOGSTYLE + BIF_NONEWFOLDERBUTTON + BIF_RETURNONLYFSDIRS)
	If Err.Number = 0 Then 
		If TypeName(oFolder) = "Folder3" Then Set oFolder = oFolder.Items.Item
		sFolder = oFolder.Path
	End If
	On Error GoTo 0

	Set oFolder = Nothing
	Set wsoShellApp = Nothing

	If sFolder = "" Then
		MsgBox "Please pass a full file spec or select a folder containing encoded files"
		WScript.Quit 
	End If

Case 1
	sFileSource = argv(0)

	If InStr(sFileSource, "?") > 0 Then 
		MsgBox "Pass a full file spec or no arguments (browse for a folder)"
		WScript.Quit
	End If

Case Else
	MsgBox "Pass a full file spec, -?, /?, ?, or no arguments (browse for a folder)"
	WScript.Quit 
End Select

Set fso = WScript.CreateObject("Scripting.FileSystemObject")

If sFolder <> "" Then
	On Error Resume Next
	Set fld = fso.GetFolder(sFolder)
	If Err.Number <> 0 Then 
		Set fld = Nothing
		Set fso = Nothing
		MsgBox "Folder """ & sFolder & """ is not valid in this context"
		WScript.Quit 
	End If
	On Error GoTo 0

	Set fc = fld.Files

	For Each fSource In fc
		sFileSource = fSource.Path

		Select Case LCase(Right(sFileSource, 4))
		Case ".vbe"
			sFileDest = Left(sFileSource, Len(sFileSource) - 1) & "s"
			bEncoded = True
	
		Case Else
			bEncoded = False
		End Select

		If bEncoded Then
			Set tsSource = fSource.OpenAsTextStream(FOR_READING)
			Process tsSource.ReadAll
			tsSource.Close
			Set tsSource = Nothing
		End If
	Next 

	Set fc = Nothing
	Set fld = Nothing

Else
	If Not fso.FileExists(sFileSource) Then
		MsgBox "File """ & sFileSource & """ not found"
	Else
		bEncoded = False

		Select Case LCase(Right(sFileSource, 4))
		Case ".vbe"
			sFileDest = Left(sFileSource, Len(sFileSource) - 1) & "s"
			bEncoded = True
				Case Else
			MsgBox "File """ & sFileSource & """ needs to be of type VBE or JSE"
			bEncoded = False
		End Select

		If bEncoded Then
			Set tsSource = fso.OpenTextFile(sFileSource, FOR_READING)
			Process tsSource.ReadAll
			tsSource.Close
			Set tsSource = Nothing
		End If
	End If
End If

Set fso = Nothing

MsgBox iNumExamined & " Files Examined; " & iNumProcessed & " Files Processed; " & iNumSkipped & " Files Skipped"