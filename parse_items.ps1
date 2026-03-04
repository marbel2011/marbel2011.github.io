# Run this script once from the repo root to generate items.json from Items.txt.
# Usage: powershell -ExecutionPolicy Bypass -File parse_items.ps1
#
# items.html works without this file (it parses Items.txt directly in the browser),
# but generating items.json improves load speed for the page.

$content = Get-Content "Items.txt" -Encoding UTF8
$items = [System.Collections.Generic.List[object]]::new()
$currentItem = $null
$skip = @{ 'Item Locations' = $true }

foreach ($line in $content) {
    $trimmed = $line.TrimEnd()
    if ($trimmed -match '^[^\s]') {
        $name = $trimmed.Trim()
        if ($name -eq '' -or $name -match '^-+$' -or $skip.ContainsKey($name)) { continue }
        if ($currentItem -ne $null) { $items.Add($currentItem) }
        $currentItem = [ordered]@{
            name      = $name
            locations = [System.Collections.Generic.List[string]]::new()
        }
    } elseif ($trimmed -match '^\s+' -and $currentItem -ne $null) {
        $loc = $trimmed.Trim()
        if ($loc -ne '') { $currentItem.locations.Add($loc) }
    }
}
if ($currentItem -ne $null) { $items.Add($currentItem) }

$outPath = Join-Path (Split-Path $MyInvocation.MyCommand.Path) "items.json"
$json = $items | ConvertTo-Json -Depth 5
[System.IO.File]::WriteAllText($outPath, $json, [System.Text.Encoding]::UTF8)
Write-Host "Done. $($items.Count) items written to items.json"
