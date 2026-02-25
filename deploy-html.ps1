param(
    [string]$SourceFile = "",
    [string]$TargetDirectory = "C:\Users\RemiLequette\OneDrive\Tech4Best\Finance",
    [string]$TargetFileName = ""
)

$ErrorActionPreference = "Stop"

try {
    $scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path
    $sourcePath = $null

    if (-not [string]::IsNullOrWhiteSpace($SourceFile)) {
        $sourcePath = Join-Path -Path $scriptDirectory -ChildPath $SourceFile
    }

    if ($null -eq $sourcePath -or -not (Test-Path -LiteralPath $sourcePath)) {
        $htmlFiles = Get-ChildItem -LiteralPath $scriptDirectory -Filter "*.html" -File

        if ($htmlFiles.Count -eq 1) {
            $sourcePath = $htmlFiles[0].FullName
        }
        elseif ($htmlFiles.Count -gt 1) {
            throw "Fichier source introuvable ou ambigu. Plusieurs fichiers HTML détectés, précise -SourceFile."
        }
        else {
            throw "Aucun fichier HTML trouvé dans : $scriptDirectory"
        }
    }

    if (-not (Test-Path -LiteralPath $TargetDirectory)) {
        New-Item -ItemType Directory -Path $TargetDirectory -Force | Out-Null
    }

    if ([string]::IsNullOrWhiteSpace($TargetFileName)) {
        $TargetFileName = Split-Path -Path $sourcePath -Leaf
    }

    $destinationPath = Join-Path -Path $TargetDirectory -ChildPath $TargetFileName

    Copy-Item -LiteralPath $sourcePath -Destination $destinationPath -Force

    Write-Host "Déploiement réussi." -ForegroundColor Green
    Write-Host "Source      : $sourcePath"
    Write-Host "Destination : $destinationPath"
}
catch {
    Write-Host "Échec du déploiement : $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
