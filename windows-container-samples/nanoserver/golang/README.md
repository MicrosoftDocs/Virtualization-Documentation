# Description:

Creates an image containing golang 1.6

This dockerfile is for demonstration purposes and may require modification for production use. 

# Environment:

Nano Server Base OS Image

# Usage:

**Docker Build**

```
docker build --isolation=hyperv -t golang:latest .
```

**Docker Run** 

This will start a container, display the Go version, and then exit.  Modify the Dockerfile appropriately for application use. 

```
docker run -it golang
```

## Dockerfile Details:
```
# This dockerfile utilizes components licensed by their respective owners/authors.
# Prior to utilizing this file or resulting images please review the respective licenses at: https://golang.org/LICENSE

FROM nanoserver

ENV GOLANG_VERSION 1.6
ENV GOLANG_DOWNLOAD_URL "https://golang.org/dl/go$GOLANG_VERSION.windows-amd64.zip"

RUN powershell.exe -Command ; \
	$handler = New-Object System.Net.Http.HttpClientHandler ; \
	$client = New-Object System.Net.Http.HttpClient($handler) ; \
	$client.Timeout = New-Object System.TimeSpan(0, 30, 0) ; \
	$cancelTokenSource = [System.Threading.CancellationTokenSource]::new() ; \
	$responseMsg = $client.GetAsync([System.Uri]::new('%GOLANG_DOWNLOAD_URL%'), $cancelTokenSource.Token) ; \
	$responseMsg.Wait() ; \
	$downloadedFileStream = [System.IO.FileStream]::new('c:\go.zip', [System.IO.FileMode]::Create, [System.IO.FileAccess]::Write) ; \
	$response = $responseMsg.Result ; \
	$copyStreamOp = $response.Content.CopyToAsync($downloadedFileStream) ; \
	$copyStreamOp.Wait() ; \
	$downloadedFileStream.Close() ; \
	[System.IO.Compression.ZipFile]::ExtractToDirectory('c:\go.zip','c:\') ; \
	Remove-Item c:\go.zip -Force

RUN powershell.exe -Command $env:path = $env:path + ';c:\go\bin'

```


