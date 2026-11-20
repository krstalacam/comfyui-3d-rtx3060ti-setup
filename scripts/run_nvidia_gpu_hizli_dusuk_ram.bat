@echo off
rem RTX 3060 Ti (8 GB VRAM) + 32 GB RAM + C: NVMe SSD (C:\AI-Models\ComfyUI-TRELLIS2-Pixal3D) icin optimize edilmis baslatici
rem --lowvram      : 8 GB VRAM icin katman/model akisini guvenli yonetir
rem --cache-none   : Eski modelleri Sistem RAM'de biriktirmez (NVMe'den hizla yeniden okur)
rem --reserve-vram : Windows/ekran icin 1 GB VRAM ayirir, donmayi onler
.\python_embeded\python.exe -s ComfyUI\main.py --windows-standalone-build --lowvram --cache-none --reserve-vram 1.0 --port 8188
echo.
echo ComfyUI kapandi.
pause
