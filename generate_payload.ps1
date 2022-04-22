$initialMemoryStream = New-Object System.IO.MemoryStream
$gzipCompressedStream = New-Object System.IO.Compression.GZipStream($initialMemoryStream, [System.IO.Compression.CompressionMode]::Compress)
$binary_writer = New-Object System.IO.BinaryWriter($gzipCompressedStream)
$bytes = [IO.File]::ReadAllBytes($args[0])
$binary_writer.Write($bytes)
$binary_writer.Close();
$base64encoded = [System.Convert]::ToBase64String($initialMemoryStream.ToArray())
$payload = @{ payloadContent = $base64encoded; payloadSize = $bytes.Length }
$jsonEncoded = ConvertTo-JSON $payload
Write-Output $jsonEncoded