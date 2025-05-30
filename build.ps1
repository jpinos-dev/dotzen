param(
    [switch]$All,
    [switch]$Clean,
    [switch]$Help
)

$BinaryName = "dotzen"
$BinDir = "bin"
$DistDir = "dist"

function Show-Help {
    Write-Host "DotZen Build Script" -ForegroundColor Green
    Write-Host ""
    Write-Host "Uso:"
    Write-Host "  .\build.ps1 [-All] [-Clean] [-Help]"
    Write-Host ""
    Write-Host "Opciones:"
    Write-Host "  -All      Compila para todas las plataformas"
    Write-Host "  -Clean    Limpia los archivos generados"
    Write-Host "  -Help     Muestra esta página de ayuda"
}

function Build-Current {
    Write-Host "🔨 Compilando para Windows..." -ForegroundColor Yellow

    if (!(Test-Path $BinDir)) {
        New-Item -ItemType Directory -Path $BinDir | Out-Null
    }

    go build -o "$BinDir\$BinaryName.exe" .\cmd\dotzen

    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Compilación completada: $BinDir\$BinaryName.exe" -ForegroundColor Green
    } else {
        Write-Host "❌ Error en la compilación" -ForegroundColor Red
        exit 1
    }
}

function Build-All {
    Write-Host "🔨 Compilando para todas las plataformas..." -ForegroundColor Yellow

    if (!(Test-Path $BinDir)) {
        New-Item -ItemType Directory -Path $BinDir | Out-Null
    }

    $platforms = @(
        @{os="darwin"; arch="amd64"},
        @{os="darwin"; arch="arm64"},
        @{os="linux"; arch="amd64"},
        @{os="linux"; arch="arm64"},
        @{os="windows"; arch="amd64"}
    )

    foreach ($platform in $platforms) {
        $os = $platform.os
        $arch = $platform.arch
        $outputName = "$BinaryName-$os-$arch"

        if ($os -eq "windows") {
            $outputName += ".exe"
        }

        Write-Host "📦 Compilando para $os/$arch..." -ForegroundColor Cyan

        $env:GOOS = $os
        $env:GOARCH = $arch

        go build -o "$BinDir\$outputName" .\cmd\dotzen

        if ($LASTEXITCODE -ne 0) {
            Write-Host "❌ Error compilando para $os/$arch" -ForegroundColor Red
            exit 1
        }
    }

    Write-Host "Todas las compilaciones completas" -ForegroundColor Green
}

function Clean-Files {
    Write-Host "🧹 Limpiando archivos generados..." -ForegroundColor Yellow

    if (Test-Path $BinDir) {
        Remove-Item -Recurse -Force $BinDir
    }

    if (Test-Path $DistDir) {
        Remove-Item -Recurse -Force $DistDir
    }

    Write-Host "✅ Limpieza completada" -ForegroundColor Green
}

if ($Help) {
    Show-Help
    exit 0
}

if ($Clean) {
    Clean-Files
    exit 0
}

if ($All) {
    Build-All
} else {
    Build-Current
}

