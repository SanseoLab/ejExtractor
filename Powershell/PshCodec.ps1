

$Path = $args[1]
$ScriptBytes = [IO.File]::ReadAllBytes((Resolve-Path $Path))


if ($args[0] -eq "DeflateEncode") {
	$CompressedStream = New-Object IO.MemoryStream
	$DeflateStream = New-Object IO.Compression.DeflateStream ($CompressedStream, [IO.Compression.CompressionMode]::Compress)
	$DeflateStream.Write($ScriptBytes, 0, $ScriptBytes.Length)
	$DeflateStream.Dispose()
	$CompressedScriptBytes = $CompressedStream.ToArray()
	$CompressedStream.Dispose()
	$EncodedCompressedScript = [Convert]::ToBase64String($CompressedScriptBytes)
	
	$output = $EncodedCompressedScript
} 


elseif ($args[0] -eq "DeflateDecode") {
	$ScriptString = [System.Text.Encoding]::ASCII.GetString($ScriptBytes)
	$Decompressed64ScriptBytes = [Convert]::FromBase64String($ScriptString)
	
	$decoded = $(New-Object IO.StreamReader ($(New-Object IO.Compression.DeflateStream($(New-Object IO.MemoryStream(,$Decompressed64ScriptBytes)), [IO.Compression.CompressionMode]::Decompress)), [Text.Encoding]::ASCII)).ReadToEnd();
	
	$output = $decoded
}


elseif ($args[0] -eq "GzipEncode") {
	$CompressedStream = New-Object IO.MemoryStream
	$GzipStream = New-Object IO.Compression.GzipStream ($CompressedStream, [IO.Compression.CompressionMode]::Compress)
	$GzipStream.Write($ScriptBytes, 0, $ScriptBytes.Length)
	$GzipStream.Dispose()
	$CompressedScriptBytes = $CompressedStream.ToArray()
	$CompressedStream.Dispose()
	$EncodedCompressedScript = [Convert]::ToBase64String($CompressedScriptBytes)
	
	$output = $EncodedCompressedScript
} 


elseif ($args[0] -eq "GzipDecode") {
	$ScriptString = [System.Text.Encoding]::ASCII.GetString($ScriptBytes)
	$Decompressed64ScriptBytes = [Convert]::FromBase64String($ScriptString)
	
	$decoded = $(New-Object IO.StreamReader ($(New-Object IO.Compression.GzipStream($(New-Object IO.MemoryStream(,$Decompressed64ScriptBytes)), [IO.Compression.CompressionMode]::Decompress)), [Text.Encoding]::ASCII)).ReadToEnd();
	
	$output = $decoded
}


elseif ($args[0] -eq "SecureDecode") {
	# need additional argument like "173,14,135,91,147,167,51,102,137,66,252,224,178,191,244,248,227,30,210,26,48,244,99,235"
	
	#PtrToStringAuto
	#PtrToStringUni
	#PtrToStringAnsi
	#PtrToStringBSTR
	
	#SecureStringToBSTR
	#SecureStringToGlobalAllocUnicode
	#SecureStringToGlobalAllocAnsi

	# Management.Automation.PSCredential - GetNetworkCredential().Password
	# ex) https://www.joesandbox.com/analysis/50838/0/pdf

	$key = $args[2]
	$ScriptString = [System.Text.Encoding]::ASCII.GetString($ScriptBytes)
	$SecureString = ConvertTo-SecureString $ScriptString -key $key

	$output = [Runtime.InterOpServices.Marshal]::PtrToStringAuto([Runtime.InterOpServices.Marshal]::SecureStringToBSTR($SecureString))
}


elseif ($args[0] -eq "SecureEncode") {
	$key = $args[2]
	$ScriptString = [System.Text.Encoding]::ASCII.GetString($ScriptBytes)
	
	$SecureString = ConvertTo-SecureString $ScriptString -AsPlainText -Force
	$SecureStringText = $SecureString | ConvertFrom-SecureString -Key $key
	$output = $SecureStringText
}


Set-Content -Path '.\result.txt' -Value $output

