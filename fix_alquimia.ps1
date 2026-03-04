$file = "C:\Code\marbel2011.github.io\alquimia.html"
$lines = Get-Content $file
$keep = @()
for ($i = 0; $i -lt $lines.Length; $i++) {
    $n = $i + 1
    if ($n -lt 382 -or $n -gt 638) { $keep += $lines[$i] }
}
[System.IO.File]::WriteAllLines($file, $keep, [System.Text.Encoding]::UTF8)
Write-Host "Done. Lines removed: 382-638. Total lines now: $($keep.Length)"
