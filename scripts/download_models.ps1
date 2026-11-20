param(
    [string]$ModelsRoot = "C:\AI-Models\ComfyUI-TRELLIS2-Pixal3D"
)

$models = @(
    @{ Dir="diffusion_models";    Name="pixal3d_int8_convrot.safetensors";       Url="https://huggingface.co/Comfy-Org/Pixal3D/resolve/main/diffusion_models/pixal3d_int8_convrot.safetensors" },
    @{ Dir="diffusion_models";    Name="trellis_2_int8_convrot.safetensors";     Url="https://huggingface.co/Comfy-Org/TRELLIS.2/resolve/main/diffusion_models/trellis_2_int8_convrot.safetensors" },
    @{ Dir="clip_vision";         Name="dino_v3_L_naf_fp32.safetensors";         Url="https://huggingface.co/Comfy-Org/Pixal3D/resolve/main/clip_vision/dino_v3_L_naf_fp32.safetensors" },
    @{ Dir="vae";                 Name="trellis_2_shape_vae_bf16.safetensors";   Url="https://huggingface.co/Comfy-Org/Pixal3D/resolve/main/vae/trellis_2_shape_vae_bf16.safetensors" },
    @{ Dir="vae";                 Name="trellis_2_texture_vae_bf16.safetensors"; Url="https://huggingface.co/Comfy-Org/Pixal3D/resolve/main/vae/trellis_2_texture_vae_bf16.safetensors" },
    @{ Dir="geometry_estimation"; Name="moge_2_vitl_normal_fp16.safetensors";    Url="https://huggingface.co/Comfy-Org/MoGe/resolve/main/geometry_estimation/moge_2_vitl_normal_fp16.safetensors" },
    @{ Dir="background_removal";  Name="birefnet.safetensors";                   Url="https://huggingface.co/Comfy-Org/BiRefNet/resolve/main/background_removal/birefnet.safetensors" }
)

foreach ($m in $models) {
    $dirPath = Join-Path $ModelsRoot $m.Dir
    New-Item -ItemType Directory -Force -Path $dirPath | Out-Null
    $outFile = Join-Path $dirPath $m.Name
    if (Test-Path $outFile) {
        Write-Host "[SKIP] Zaten mevcut: $outFile"
        continue
    }
    Write-Host "[DOWNLOAD] $($m.Name) -> $outFile"
    curl.exe -L -C - -o $outFile $m.Url
}
Write-Host "Tum modeller hazir."
