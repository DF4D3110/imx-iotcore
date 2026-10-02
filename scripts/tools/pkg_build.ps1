# pkg_build.ps1 - Generate the 6 BSP cabs referenced by DeviceFM.xml that are NOT driver cabs.
# Requires: ADK 17763 PkgGen.exe + Tools_17704 makecat.exe (adjust paths below if different).
# Usage: powershell -ExecutionPolicy Bypass -File scripts\tools\pkg_build.ps1
$ErrorActionPreference = 'Continue'

$pkggen    = 'E:\Assessment and Deployment Kit\adk-src\adk\17763\Windows Kits\10\tools\bin\i386\PkgGen.exe'
$makecatDir = 'E:\Assessment and Deployment Kit\build_tools\Tools_17704\bin\i386'
$env:PATH = "$makecatDir;$env:PATH"

# 源 wm.xml 目录（上游 BSP 源码包位置，按需修改）
$bk = 'D:\firmware_build\bsp_removed\Packages'
# 输出：仓库 bsp-pkg 目录
$out = Join-Path (Split-Path $PSScriptRoot -Parent) '..\bsp-pkg'
$out = [System.IO.Path]::GetFullPath($out)
New-Item -ItemType Directory -Path $out -Force | Out-Null

$jobs = @(
    @{ wm = "$bk\SystemInformation\SystemInformation.wm.xml";      cwd = $bk; vars = $null },
    @{ wm = "$bk\BootLoader\BootLoader.wm.xml";                    cwd = $bk; vars = $null },
    @{ wm = "$bk\BootFirmware\BootFirmware.wm.xml";                cwd = $bk; vars = $null },
    @{ wm = "$bk\DevicePlatform\OEMDevicePlatform.wm.xml";         cwd = "$bk\DevicePlatform"; vars = $null },
    @{ wm = "$bk\DeviceLayout\DeviceLayoutProd.wm.xml";            cwd = "$bk\DeviceLayout"; vars = $null },
    @{ wm = "$bk\SVPlatExtensions\svupdateOS.wm.xml";              cwd = $bk; vars = "_RELEASEDIR=$bk\USDHC" }
)

foreach ($j in $jobs) {
    Write-Host "=== $($j.wm) ==="
    Set-Location $j.cwd
    $args = @($j.wm, "/output:$out\", '/cpu:arm64', '/universalbsp:true', '/onecore:true')
    if ($j.vars) { $args += "/variables:$($j.vars)" }
    $r = & $pkggen $args 2>&1 | Out-String
    $r -split "`n" | Where-Object {
        $_ -match 'Saving CAB|ERROR|error|Failed|not found|Undefined'
    } | ForEach-Object { Write-Host $_ }
}
Set-Location 'C:\'
Write-Host ''
Write-Host "=== cabs in $out ==="
Get-ChildItem $out -Filter '*.cab' | Sort-Object Name | ForEach-Object { '{0,10}  {1}' -f $_.Length, $_.Name }
