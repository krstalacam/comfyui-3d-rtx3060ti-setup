param(
    [string]$ComfyModelsDir = "D:\krstlcm Workspace\Programlar\ComfyUI-TRELLIS2-Pixal3D\ComfyUI_windows_portable\ComfyUI\models",
    [string]$NvmeTargetDir = "C:\AI-Models\ComfyUI-TRELLIS2-Pixal3D"
)

if (-not (Test-Path $NvmeTargetDir)) {
    New-Item -ItemType Directory -Force -Path $NvmeTargetDir | Out-Null
}

if (Test-Path $ComfyModelsDir) {
    $item = Get-Item $ComfyModelsDir
    if ($item.LinkType -eq "Junction") {
        Write-Host "Zaten Junction olarak bagli: $ComfyModelsDir -> $($item.Target)"
        exit 0
    }
    Write-Host "Mevcut models icerigi NVMe hedefe kopyalaniyor..."
    robocopy $ComfyModelsDir $NvmeTargetDir /E /MT:4 /R:2 /W:2
    cmd /c "rmdir /s /q `"$ComfyModelsDir`""
}

cmd /c "mklink /J `"$ComfyModelsDir`" `"$NvmeTargetDir`""
Write-Host "Tamamlandi: $ComfyModelsDir -> $NvmeTargetDir"
