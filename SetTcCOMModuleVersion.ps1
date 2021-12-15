param(
    [string]$version # new version, e.g. "4.0.2.13"
)

if([string]::IsNullOrWhiteSpace($version)) { throw "missing version parameter" }

$plcFolder = "$PSScriptRoot\PLC"
$ba = "Beckhoff Automation GmbH";

Get-ChildItem -Path $plcFolder -Filter *.tsproj -Recurse -File -Name | ForEach-Object { 
    $tsProjPath = "$plcFolder\$_"
    (Get-Content $tsProjPath) -replace "$ba(\|(TcVision|TcIoGigEVision)\|)(\d+.\d+.\d+.\d+)", "$ba`${1}$version" | Set-Content $tsProjPath
}