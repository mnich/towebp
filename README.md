# towebp

**towebp** is a multi-threaded CLI tool written in Bash, designed for the batch conversion of images (JPG/JPEG, PNG) into the modern and efficient WebP format. The script is engineered for maximum performance, automation (e.g., via cron), and complete file safety.

## ✨ Features

- **Multi-threading** – detects the number of logical CPU cores (macOS/Linux) and runs `cwebp` jobs in parallel via `xargs -P`, which greatly reduces conversion time for large directories.
- **Cron-ready** – built to run in the background. Files that already have a `.webp` counterpart are skipped, so periodic scans (e.g. of `~/Downloads`) are cheap. A lock prevents overlapping runs.
- **Safe paths** – full support for file names containing spaces or special characters.
- **Disk cleanup** – the optional `--delete` flag removes original files **only** after a successful conversion (checked via the `cwebp` exit code).
- **No partial files** – images are written to a temporary file first and moved into place only when conversion succeeds.

## 📦 Installation (macOS / Linux)

The tool is distributed as a Homebrew package. All dependencies are installed automatically: the formula depends on the `webp` package (which provides `cwebp`), and the remaining tools (`bash`, `find`, `xargs`) are part of the operating system.

```bash
brew tap mnich/tools
brew install towebp
```

### Manual installation

If `cwebp` is missing and Homebrew is available, `towebp` installs the `webp` package automatically on first run. Without Homebrew, install it with your system package manager (e.g. `sudo apt install webp`).

```bash
curl -fsSL https://raw.githubusercontent.com/mnich/towebp/main/towebp -o /usr/local/bin/towebp
chmod +x /usr/local/bin/towebp
```

## 🚀 Usage

When run without arguments, `towebp` scans `~/Downloads` (recursively), uses 80% quality and as many parallel jobs as there are logical CPU cores.

```bash
towebp [OPTIONS]
```

### Options

| Option | Description |
| --- | --- |
| `-q`, `--quality <0-100>` | WebP quality (default: `80`) |
| `-d`, `--dir <path>` | Directory with images (default: `~/Downloads`) |
| `-t`, `--threads <n>` | Number of parallel jobs (default: number of logical cores) |
| `--delete` | Delete the original `.jpg` / `.jpeg` / `.png` after a successful conversion |
| `-v`, `--version` | Show version |
| `-h`, `--help` | Show help |

### Examples

Convert the `~/Pictures` folder with 85% quality using 8 threads, keeping the originals:

```bash
towebp -q 85 -d ~/Pictures -t 8
```

Convert `~/Downloads` and delete the originals afterwards:

```bash
towebp --delete
```

> **Note:** an image is skipped when a `.webp` file with the same base name already exists – an existing `.webp` is never overwritten, and with `--delete` the original of a skipped image is kept. If a directory contains e.g. `photo.jpg` and `photo.png`, only one of them is converted; the other stays untouched.

## ⏱ Automation (cron)

`towebp` can convert newly downloaded images in the background. Open your crontab:

```bash
crontab -e
```

and add the following line to run it every minute (use the absolute path to the binary – `/opt/homebrew/bin/towebp` on Apple Silicon, `/usr/local/bin/towebp` on Intel Macs – and to the directory):

```cron
* * * * * /opt/homebrew/bin/towebp -d /Users/YOUR_USERNAME/Downloads --delete > /tmp/towebp_cron.log 2>&1
```

Watch the log live with:

```bash
tail -f /tmp/towebp_cron.log
```

The script extends `PATH` with the standard Homebrew locations, so `cwebp` is found even in cron's minimal environment.

> **Using together with [toavif](https://github.com/mnich/toavif):** if you run both `towebp` and `toavif` on the same directory, do **not** pass `--delete` to either of them – whichever runs first would remove the originals before the other one converts them.

> **macOS:** to let cron access `~/Downloads`, grant **Full Disk Access** to `/usr/sbin/cron` in *System Settings → Privacy & Security*.

## 🍺 Publishing a release to Homebrew

The formula lives in a separate tap repository, [`mnich/homebrew-tools`](https://github.com/mnich/homebrew-tools) (tap repositories must be prefixed with `homebrew-`). A template is kept in [`homebrew/towebp.rb`](homebrew/towebp.rb).

1. Bump `VERSION` in `towebp`, commit, and create a GitHub release with a tag, e.g. `v1.0.0`.
2. Compute the SHA256 of the release tarball:

   ```bash
   curl -sL https://github.com/mnich/towebp/archive/refs/tags/v1.0.0.tar.gz | shasum -a 256
   ```

3. In `homebrew-tools`, update `url` and `sha256` in `Formula/towebp.rb` and push.
4. Users get the new version with `brew upgrade towebp`.

## 📄 License

This project is released under the [MIT License](LICENSE).
