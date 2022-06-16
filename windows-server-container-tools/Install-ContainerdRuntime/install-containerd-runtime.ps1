# Download and extract desired containerd Windows binaries
$Version="1.6.4"
curl.exe -L https://github.com/containerd/containerd/releases/download/v$Version/containerd-$Version-windows-amd64.tar.gz -o containerd-windows-amd64.tar.gz
tar.exe xvf .\containerd-windows-amd64.tar.gz

$NerdVersion="0.20.0"
curl.exe -L https://github.com/containerd/nerdctl/releases/download/v$NerdVersion/nerdctl-$NerdVersion-windows-amd64.tar.gz -o nerdctl-windows-amd64.tar.gz
tar.exe xfv .\nerdctl-windows-amd64.tar.gz

$ContainerdPath = "$Env:ProgramFiles\containerd"

# Copy and add to path
Copy-Item -Path ".\bin\" -Destination $ContainerdPath -Recurse -Force
Copy-Item -Path ".\nerdctl.exe" -Destination $ContainerdPath -Recurse -Force

$OldPath = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name path).path
if(!($OldPath -contains "*containerd*")) {
    $NewPath = "$OldPath;$ContainerdPath"
    Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH -Value $newpath
    $env:Path = $NewPath
} else {
    echo "$ContainerdPath already in PATH"
}

#Configure
containerd.exe config default | Out-File $ContainerdPath\config.toml -Encoding ascii

# Review the configuration. Depending on setup you may want to adjust:
# - the sandbox_image (Kubernetes pause image)
# - cni bin_dir and conf_dir locations
Get-Content $ContainerdPath\config.toml

# Register and start service
containerd.exe --register-service
Start-Service containerd