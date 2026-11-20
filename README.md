# ComfyUI 3D (TRELLIS.2 + Pixal3D) — RTX 3060 Ti (8 GB VRAM) / 32 GB RAM Optimize Kurulum

Bu depo, **Windows + NVIDIA RTX 3060 Ti (8 GB VRAM) + 32 GB RAM** sistemlerde **ComfyUI (v0.46.0)** üzerinden hem **Pixal3D (INT8)** hem de **TRELLIS.2 (INT8)** ile çökmeden, `pagefile` şişirmeden ve yüksek hızda 3D (`.glb`) üretimi yapmak için hazırlanmış optimize kurulum, iş akışı ve betikleri içerir.

> **Not:** Büyük yapay zeka model ağırlıkları (~14,17 GB) bu depoya **eklenmemiştir**. Aşağıdaki tabloda resmi Hugging Face indirme bağlantıları ve otomatik indirme betiği (`scripts/download_models.ps1`) yer alır.

---

## Mimari: C: NVMe SSD + D: HDD Hibrit Düzen

- **Program, Python ve 3D çıktılar (`output/3d`):** Geniş `D:` diskinde durur (`C:` SSD'yi şişirmez).
- **Yapay Zeka Modelleri (~14,17 GB):** Hızlı **C: NVMe SSD** (`C:\AI-Models\ComfyUI-TRELLIS2-Pixal3D`) üzerinde tutulur ve `ComfyUI\models` klasörüne **NTFS Directory Junction (`mklink /J`)** ile bağlanır.
- **Bellek Yönetimi (`--lowvram --cache-none --reserve-vram 1.0`):**
  - `--lowvram`: 8 GB VRAM için katman akışını güvenli yönetir.
  - `--cache-none`: İşi biten modeli Sistem RAM'de biriktirmez; modeller NVMe SSD'den saniyeler içinde tekrar okunduğu için 32 GB RAM ve `pagefile.sys` hiç şişmez (ölçülen pagefile: **~32–93 MB**).
  - `--reserve-vram 1.0`: Windows arayüzünün donmaması için 1 GB VRAM ayırır.

---

## Kurulum Adımları

### 1. Resmi ComfyUI Portable'ı İndir
- [ComfyUI Releases](https://github.com/comfyanonymous/ComfyUI/releases) sayfasından `ComfyUI_windows_portable_nvidia.7z` paketini indirip `D:\...\ComfyUI-TRELLIS2-Pixal3D\` klasörüne aç.

### 2. Modelleri C: NVMe SSD'ye Bağla (Junction)
`scripts/setup_nvme_junction.ps1` betiğini çalıştırarak `ComfyUI\models` klasörünü `C:\AI-Models\ComfyUI-TRELLIS2-Pixal3D` konumuna bağla.

### 3. Gerekli 7 Resmi Modeli İndir (~14,17 GB)
`scripts/download_models.ps1` betiğini çalıştırabilir veya aşağıdaki resmi **Comfy-Org** bağlantılarından manuel indirip ilgili klasöre koyabilirsin:

| Alt Klasör (`models/...`) | Dosya Adı | Yaklaşık Boyut | Resmi İndirme Bağlantısı |
| :--- | :--- | :---: | :--- |
| `diffusion_models` | `pixal3d_int8_convrot.safetensors` | 5,20 GB | [Hugging Face](https://huggingface.co/Comfy-Org/Pixal3D/resolve/main/diffusion_models/pixal3d_int8_convrot.safetensors) |
| `diffusion_models` | `trellis_2_int8_convrot.safetensors` | 4,89 GB | [Hugging Face](https://huggingface.co/Comfy-Org/TRELLIS.2/resolve/main/diffusion_models/trellis_2_int8_convrot.safetensors) |
| `clip_vision` | `dino_v3_L_naf_fp32.safetensors` | 1,13 GB | [Hugging Face](https://huggingface.co/Comfy-Org/Pixal3D/resolve/main/clip_vision/dino_v3_L_naf_fp32.safetensors) |
| `vae` | `trellis_2_shape_vae_bf16.safetensors` | 1,02 GB | [Hugging Face](https://huggingface.co/Comfy-Org/Pixal3D/resolve/main/vae/trellis_2_shape_vae_bf16.safetensors) |
| `vae` | `trellis_2_texture_vae_bf16.safetensors` | 0,88 GB | [Hugging Face](https://huggingface.co/Comfy-Org/Pixal3D/resolve/main/vae/trellis_2_texture_vae_bf16.safetensors) |
| `geometry_estimation` | `moge_2_vitl_normal_fp16.safetensors` | 0,62 GB | [Hugging Face](https://huggingface.co/Comfy-Org/MoGe/resolve/main/geometry_estimation/moge_2_vitl_normal_fp16.safetensors) |
| `background_removal` | `birefnet.safetensors` | 0,41 GB | [Hugging Face](https://huggingface.co/Comfy-Org/BiRefNet/resolve/main/background_removal/birefnet.safetensors) |

### 4. Başlatıcı ve İş Akışını Kopyala
- `scripts/run_nvidia_gpu_hizli_dusuk_ram.bat` dosyasını `ComfyUI_windows_portable\` içine kopyala ve bununla başlat (`http://127.0.0.1:8188/`).
- `workflows/ANA_3D_URETIM_1024_RTX3060Ti.json` dosyasını `ComfyUI\user\default\workflows\` içine kopyala.

---

## İş Akışı Ayarları (`ANA_3D_URETIM_1024_RTX3060Ti.json`)

- **Çözünürlük:** `1024` *(varsayılan `1536` 8 GB VRAM / 32 GB RAM'de kilitlenmeye yol açtığı için `1024` seçildi)*
- **Doku Boyutu:** `2048` (`Base Color`, `Metallic`, `Roughness`, `Normal Map`)
- **Poligon Hedefi (`DecimateMesh`):** `250.000`
- **Yüzey Yumuşatma (`MeshSmoothNormals`):** `50°` (hafif kavisler yumuşak, ana low-poly köşeler net)
- **Model Seçimi (`Boolean: Switch to Trellis2`):**
  - `False` → **Pixal3D (INT8)**: Karakter, figür, çizgi film / organik modellerde en iyi renk ve form sadakati.
  - `True` → **TRELLIS.2 (INT8)**: Ev, taş, ağaç, mimari ve çevre varlıklarında en temiz zemin hizası ve geometri.

---

## Gerçek Ölçümler (RTX 3060 Ti 8 GB / 32 GB RAM / Kingston NVMe)

| Test Görseli (`1024` / `2048` doku / `250k`) | Model | Süre | Tepe VRAM | Tepe RAM | Pagefile |
| :--- | :--- | :---: | :---: | :---: | :---: |
| `einstein.png` | ComfyUI **Pixal3D** | 106,3 sn | 7,27 GB | 13,21 GB | 0,87 GB |
| `einstein.png` | ComfyUI **TRELLIS.2 INT8** | 121,3 sn | 6,83 GB | 11,21 GB | 0,90 GB |
| `lowpolyhome.png` | ComfyUI **Pixal3D** | 211,4 sn | 6,23 GB | 15,75 GB | 0,90 GB |
| `lowpolyhome.png` | ComfyUI **TRELLIS.2 INT8** | 317,2 sn | 7,33 GB | 12,03 GB | **0,03 GB** |
| `lowpolyrocks.jpeg` | ComfyUI **TRELLIS.2 INT8** | 75,5 sn | 7,31 GB | 9,61 GB | **0,03 GB** |

> **Donanım İpucu:** Kingston FURY Renegade / KC3000 (`SFYRS` / Phison E18) NVMe SSD kullanıyorsan ve yoğun yük altında `0x154 UNEXPECTED_STORE_EXCEPTION` + `volmgr 161` mavi ekranı alıyorsan **Kingston SSD Manager** ile firmware'i `EIFK31.6` → **`EIFK31.7`** (veya üstüne) güncelle.
