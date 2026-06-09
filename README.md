<div align="center">

# 🌸 `uwu` 🌸

### Universal Wallpaper Utility

```text
█   █ █   █ █   █   
█░  █░█░  █░█░  █░  
█░░ █░█░█ █░█░░ █░░ 
█░░ █░██░██░█░░ █░░ 
 ███ ░█░░ █░░███ ░░ 
  ░░░ ░░░░ ░░ ░░░ ░ 
   ░░░  ░   ░  ░░░  


  ✨Set static and live wallpapers with Material You themes✨
  
```

</div>

---

**`uwu`** (Universal Wallpaper Utility) is a smart, automated wallpaper manager for Linux window managers. It doesn't just change your background—it breathes life into your entire desktop by dynamically extracting color palettes and applying them globally across your system!

## ✨ Features

- 🎨 **Dynamic Material You colors**: Automatically runs `matugen` to extract a beautiful color palette from your chosen wallpaper and applies it system-wide.
- 🎞️ **Automated Video-to-GIF Conversion**: Got a video file? `uwu` uses `ffmpeg` to transparently convert video files into optimized GIFs on the fly and sets them as animated wallpapers!
- 🪶 **Daemon Management**: Seamlessly manages the `awww-daemon` lifecycle. If it's dead, `uwu` revives it automatically before you even notice.
- 📂 **Smart Pathing**: Easily set a wallpaper relative to your `~/Pictures/wallpapers` directory or just pass an absolute path.
- 🚀 **Initial Environment Bootstrap**: Ships with a smart bootstrap phase that sets up your `matugen` configuration templates out-of-the-box.

## 🛠️ Requirements & Dependencies

To get the full `uwu` experience, make sure you have the following installed on your system:

- `bash` (You already have this!)
- [`awww`](https://github.com/awww-daemon/awww) - The blazing fast animated wallpaper daemon.
- [`matugen`](https://github.com/InioX/matugen) - Material You color generation tool.
- [`ffmpeg`](https://ffmpeg.org/) - Required for auto-converting videos into animated `.gif` wallpapers.
- `file` - Standard Linux utility to determine file MIME types.

## 📦 Installation

Clone the repository and make the script executable! You can optionally symlink it to your PATH for easy access anywhere.

```bash
# Clone the repo
git clone https://github.com/yourusername/uwu.git
cd uwu

# Make it executable
chmod +x uwu.sh

# (Optional) Link it to your local bin
ln -s $(pwd)/uwu.sh ~/.local/bin/uwu
```

> **Note:** The script expects some base system-wide templates at `/usr/share/uwu` to correctly seed your initial `~/.config/matugen` setup.

## 🚀 Usage

Using `uwu` is as simple as running the script with the path to the media file you want to use.

```bash
# Set a standard image
uwu path/to/wallpaper.png

# Set a wallpaper from your default ~/Pictures/wallpapers folder
uwu my_cool_wallpaper.jpg

# Set an MP4 video (It auto-converts to an optimized GIF!)
uwu animated_scenery.mp4
```

### What happens under the hood?

1. `uwu` checks if `matugen` is set up properly. If not, it configures it.
2. It ensures `awww-daemon` is alive and kicking.
3. It detects the media type. If it's a video, it runs an optimized `ffmpeg` pass to convert it to a looping palette-optimized GIF.
4. It sets the new background via `awww`.
5. It calls `matugen` to update all your desktop theme colors!

> [!CAUTION]
> Video wallpapers set may disable hyprlock lockscreen background and set it to default (No lockscreen background)

## 🤝 Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingCuteFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingCuteFeature'`)
4. Push to the Branch (`git push origin feature/AmazingCuteFeature`)
5. Open a Pull Request

## 📝 License

Distributed under the MIT License. See `LICENSE` for more information.

<div align="center">
  <sub>Built with 💖 for Linux ricing enthusiasts.</sub>
</div>
