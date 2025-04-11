param(
    [string]$version # new version (4 digits, e.g. "4.0.7.4" or "5.7.4.0")
)

if([string]::IsNullOrWhiteSpace($version)) { throw "Missing version parameter" }
$versionCheck = $version -as [version]
$versionDigits = $version.Split('.').Count
if($null -eq $versionCheck -or $versionDigits -ne 4) { throw "Invalid version '$version' (exactly 4 digits required)" }

$plcFolder = "$PSScriptRoot\PLC"
$cppFolder = "$PSScriptRoot\_internal\C++"
$ba = "Beckhoff Automation GmbH";

Get-ChildItem -Path $plcFolder -Filter *.tsproj -Recurse -File -Name | ForEach-Object {
    $tsProjPath = "$plcFolder\$_"
    (Get-Content $tsProjPath) -replace "$ba(\|(TcVision|TcIoGigEVision)\|)(\d+.\d+.\d+.\d+)", "$ba`${1}$version" | Set-Content $tsProjPath
}

Get-ChildItem -Path $cppFolder -Filter *.tsproj -Recurse -File -Name | ForEach-Object {
    $tsProjPath = "$cppFolder\$_"
    (Get-Content $tsProjPath) -replace "$ba(\|(Tc3_Vision|TcVision|TcIoGigEVision)\|)(\d+.\d+.\d+.\d+)", "$ba`${1}$version" | Set-Content $tsProjPath
}

Get-ChildItem -Path $cppFolder -Filter *.tmc -Recurse -File -Name | ForEach-Object {
    $tmcPath = "$cppFolder\$_"
    (Get-Content $tmcPath) -replace "$ba\|Tc3_Vision\|(\d+.\d+.\d+.\d+)", "$ba|Tc3_Vision|$version" | Set-Content $tmcPath
}

Get-ChildItem -Path $cppFolder -Filter *.props -Recurse -File -Name | ForEach-Object {
    $propsPath = "$cppFolder\$_"
    (Get-Content $propsPath) -replace "$ba\\Tc3_Vision\\(\d+.\d+.\d+.\d+)", "$ba\Tc3_Vision\$version" | Set-Content $propsPath
}