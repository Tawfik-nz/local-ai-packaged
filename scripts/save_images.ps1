$imgs = docker compose -p localai -f docker-compose.yml -f docker-compose.override.private.yml ps -q | ForEach-Object { docker inspect --format '{{.Config.Image}}' $_ } | Sort-Object -Unique
if (-not $imgs) { Write-Error 'No images found'; exit 1 }
$imagesPath = Join-Path $PSScriptRoot "..\backup\images"
New-Item -ItemType Directory -Force -Path $imagesPath | Out-Null
$manifest = @()
foreach ($img in $imgs) {
    $safe = $img -replace '[:/@]','_'
    $out = Join-Path $imagesPath ($safe + '.tar')
    Write-Host "Saving $img -> $out"
    docker save -o $out $img
    $manifest += [pscustomobject]@{image=$img; file=($safe + '.tar')}
}
$manifest | ConvertTo-Json -Depth 5 | Out-File -Encoding UTF8 (Join-Path $imagesPath 'manifest.json')
Write-Host 'Saved total bytes:' (Get-ChildItem $imagesPath | Measure-Object -Property Length -Sum).Sum
