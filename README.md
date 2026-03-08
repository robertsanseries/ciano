<div align="center">
    <img width="64" height="64" src="https://github.com/robertsanseries/ciano/blob/master/data/icons/com.github.robertsanseries.ciano.png" alt="Icon">
    <h1>Ciano</h1>
    <h3 align="center">A multimedia file converter focused on simplicity.</h3>
</div>

<p align="center">
    <img src="https://github.com/robertsanseries/ciano/blob/master/data/screenshot.png" alt="Screenshot">
</p>

## ✨ Features

Convert videos, music, and pictures with a native, fast, and elegant experience.

* **Native:** Built with Vala and GTK4 for peak performance.
* **Simple:** No complex configurations, just select and convert.
* **Integrated:** A clean and modern interface that stays out of your way.
* **Supported Formats:**
    * **Video:** MP4, MPG, AVI, WMV, FLV, MKV, 3GP, MOV, VOB, OGV, WebM.
    * **Audio:** MP3, WMA, OGG, WAV, AAC, FLAC, AIFF, MMF, M4A.
    * **Images:** JPG, BMP, PNG, TIF, GIF, TGA.

## 📦 Get Ciano

| Platform | Download                                                                                                                                                          | Platform | Download                                                                                                                                                     |
|:---------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------|:---------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **elementary OS** | <a href="https://appcenter.elementary.io/com.github.robertsanseries.ciano"><img src="https://appcenter.elementary.io/badge.svg" height="45" alt="AppCenter"></a>  | **Fedora** | <a href="LINK_RPM_RELEASE"><img src="https://img.shields.io/badge/Fedora-RPM-294172?logo=fedora&logoColor=white" height="45" alt="Fedora"></a>               |
| **Debian** | <a href="https://github.com/robertsanseries/ciano/releases/download/0.1.4/com.github.robertsanseries.ciano_0.1.4_amd64.deb"><img src="data/assets/images/badges/debian-badge.svg" height="45" alt="Debian"></a>                                                     | **Arch Linux** | <a href="https://aur.archlinux.org/packages/ciano"><img src="data/assets/images/badges/arch-badge.svg" height="45" alt="Arch"></a>                           |
| **Flatpak (Flathub)** | <a href="https://flathub.org/apps/details/com.github.robertsanseries.ciano"><img src="data/assets/images/badges/flatpak-badge.svg" height="47" alt="Flathub"></a> | **Ubuntu (Snap)** | <a href="https://snapcraft.io/ciano"><img src="https://img.shields.io/badge/Snap-Download-82BEA0?logo=snapcraft&logoColor=white" height="45" alt="Snap"></a> |                        

## 🛠️ Installation from Source

### Dependencies
Before building, ensure you have these installed:
`meson`, `valac`, `libgranite-dev`, `libgtk-4-dev`, `ffmpeg`.

### Building and Installing
```bash
git clone https://github.com/robertsanseries/ciano.git && cd ciano
meson setup build --prefix=/usr
cd build
ninja
sudo ninja install
```
## ☕ Support the Development
If Ciano is useful to you, consider supporting its development. Every coffee helps!

| Support via | Link |
| :--- | :--- |
| **International (PayPal)** | [Donate USD](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=S698J2TUEMT3C) |
| **Brasil (PayPal Brasil)** | [Doar em BRL](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=FJ2EVELMCFPU6) |

## 🤝 Community
* **Contributing:** Interested in helping with code or design? See our [Contributing Guidelines](CONTRIBUTING.md).
* **Translate:** Help us bring Ciano to your language [here](https://github.com/robertsanseries/ciano/wiki/Translate).
* **Feedback:** Found a bug? [Open an issue](https://github.com/robertsanseries/ciano/issues).
