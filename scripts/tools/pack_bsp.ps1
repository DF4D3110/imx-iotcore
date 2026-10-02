$ErrorActionPreference = 'Stop'
$root = 'D:\BSP-IMX'
$packRoot = 'D:\firmware_build\pack'
$zipOut = 'D:\NXPEVK_iMX8M_4GB_BSP.zip'

Write-Host '=== 1. Clean empty dirs & marker ==='
$empties = @(
    'D:\BSP-IMX\Packages\BootFirmware\BootFirmware',
    'D:\BSP-IMX\Packages\BootLoader\BootLoader'
)
foreach ($d in $empties) {
    if (Test-Path $d) {
        Remove-Item $d -Recurse -Force
        Write-Host "removed empty dir: $d"
    }
}
$marker = 'D:\BSP-IMX\Packages\PWM\imxpwm.sys.lastcodeanalysissucceeded'
if (Test-Path $marker) {
    Remove-Item $marker -Force
    Write-Host "removed marker: $marker"
}

Write-Host ''
Write-Host '=== 2. Build clean tree (exclude *.pdb) ==='
if (Test-Path $packRoot) { Remove-Item $packRoot -Recurse -Force }
New-Item -ItemType Directory -Path $packRoot -Force | Out-Null
$dst = Join-Path $packRoot 'NXPEVK_iMX8M_4GB_BSP'
robocopy $root $dst /E /XF *.pdb /NFL /NDL /NJH /NJS /NP | Out-Null
if ($LASTEXITCODE -ge 8) { throw "robocopy failed, exit=$LASTEXITCODE" }

Write-Host ''
Write-Host '=== 3. Pack zip ==='
if (Test-Path $zipOut) { Remove-Item $zipOut -Force }
Compress-Archive -Path $dst -DestinationPath $zipOut -CompressionLevel Optimal
Write-Host "zip created: $zipOut"

Write-Host ''
Write-Host '=== 4. Verify zip ==='
Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = [System.IO.Compression.ZipFile]::OpenRead($zipOut)
$entries = $zip.Entries
$files = $entries | Where-Object { -not $_.FullName.EndsWith('/') }
Write-Host "total entries: $($entries.Count)   files: $($files.Count)"
$files | ForEach-Object { '{0,10}  {1}' -f $_.Length, $_.FullName }
$zip.Dispose()

Write-Host ''
Write-Host '=== 5. Remove temp pack dir ==='
Remove-Item $packRoot -Recurse -Force
Write-Host 'temp cleaned'

Write-Host ''
Write-Host '=== 6. zip size ==='
$z = Get-Item $zipOut
'{0:N2} MB' -f ($z.Length / 1MB)
