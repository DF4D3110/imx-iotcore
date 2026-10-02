# verify_fm.ps1 - Cross-check every .cab referenced by NXPEVK_iMX8M_4GB_DeviceFM.xml
# against the actual files in bsp-pkg. Fails the check if any reference is missing.
# Usage: powershell -ExecutionPolicy Bypass -File scripts\tools\verify_fm.ps1
$ErrorActionPreference = 'Stop'
$pkgDir = Join-Path (Split-Path $PSScriptRoot -Parent) '..\bsp-pkg'
$pkgDir = [System.IO.Path]::GetFullPath($pkgDir)
$fm = Join-Path $pkgDir 'NXPEVK_iMX8M_4GB_DeviceFM.xml'

[xml]$doc = Get-Content $fm
$refs = @()
foreach ($n in $doc.SelectNodes("//*[local-name()='PackageFile']")) {
    $refs += $n.GetAttribute('Name')
}
Write-Host "FM referenced cabs: $($refs.Count)"
$missing = @()
foreach ($r in ($refs | Sort-Object)) {
    $p = Join-Path $pkgDir $r
    if (Test-Path $p) {
        '{0,10}  OK   {1}' -f (Get-Item $p).Length, $r
    } else {
        "MISSING: $r"
        $missing += $r
    }
}
Write-Host ''
if ($missing.Count -eq 0) {
    Write-Host "ALL FM REFERENCED FILES PRESENT ($($refs.Count)/$($refs.Count))"
} else {
    Write-Host "MISSING COUNT: $($missing.Count)"
    $missing
}
