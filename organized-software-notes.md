# Software Configuration Notes

## Radian (R Console)

### Installation Path

```
/Users/chris/Library/Python/3.x/bin/radian
```

### Installation Troubleshooting

- If Radian fails to install due to `rchitect` build issues:
  1. Fix using solution from github.com/randy3k/rchitect/issues/37
  - Download Source.
  - Find `process_events.c` file.
  - Edit `R_ToplevelExec(cb_polled_events_interruptible, NULL);` function to be `R_ToplevelExec((void (*)(void *))cb_polled_events_interruptible, NULL);`.

    ```
    diff --git i/rchitect/src/process_events.c w/rchitect/src/process_events.c
    index 3f07d02..4efe5f0 100644
    --- i/rchitect/src/process_events.c
    +++ w/rchitect/src/process_events.c
    @@ -31,7 +31,7 @@ int peek_event(void) {
    #else

    void polled_events() {
    -    R_ToplevelExec(cb_polled_events_interruptible, NULL);
    +    R_ToplevelExec((void (*)(void *))cb_polled_events_interruptible, NULL);
    }

    static void Call_R_checkActivity(void** what) {
    ```
  2. Compile manually: `sudo python3 setup.py install` from the directory
  3. Then run `pip install radian` (use pipx or --break-system-packages if managed by homebrew)

## R Configuration

### Language Server

- Install from github.com/REditorSupport/languageserver
- Create `.lintr` file in home directory with these settings:
  ```r
  linters: linters_with_defaults(
      line_length_linter(200),
      commented_code_linter = NULL,
      object_name_linter = NULL,
      trailing_blank_lines_linter = NULL,
      seq_linter = NULL,
      T_and_F_symbol_linter = NULL,
      indentation_linter = NULL
    )
  ```
  _Note: Add an empty line at the end of the file_

### Lintr Config File Location

```
/Users/chris/.lintr
```

## Jupyter Notebook with R

Install jupyter through pip or through OS store. Check OS store (COSMIC on POP OS) first and install. Not recommended to use --break-system-packages.

### Installing R Kernel

```r
# In R environment
install.packages("devtools")

# For Fedora Linux
# Get R-devtools from https://koji.fedoraproject.org/koji/index
# Search R-devtools
# Install .rpm using sudo dnf install
# Then in R:
install.packages("devtools")
devtools::install_github("IRkernel/IRkernel")
IRkernel::installspec()
```

### Jupyter PDF Export with R Kernel

#### MacOS Setup

Install required TeX packages:

```bash
tlmgr install upquote caption pdfcol tcolorbox parskip xcolor pgf environ trimspaces etoolbox eurosym grffile adjustbox titling enumitem ulem soul mathrsfs jknapltx

# Install collections
tlmgr install \
  collection-fontsrecommended \
  collection-latexrecommended \
  collection-mathscience
```

#### Convert Notebook to PDF

```bash
jupyter nbconvert --to pdf test.ipynb
```

### VSCode Migration to VSCodium
```bash
# Copy all extensions
cp -R ~/.vscode/extensions ~/.vscode-oss/

# Copy keybindings.json and settings.json files
cp ~/Library/Application\ Support/Code/User/keybindings.json ~/Library/Application\ Support/VSCodium/User
cp ~/Library/Application\ Support/Code/User/settings.json ~/Library/Application\ Support/VSCodium/User
```

### VSCode PDF Export

#### Troubleshooting VSCode Export

If VSCode forces Python kernel selection:

1. Temporarily use a Python kernel to see the error
2. Install TeX packages:

   ```bash
   # Install basic TeX Live with XeLaTeX
   sudo dnf install texlive-xetex

   # Additional packages for Jupyter
   sudo dnf install texlive-collection-latex texlive-collection-latexrecommended texlive-collection-latexextra
   ```

3. If wheel building fails:

   ```bash
   # Install development tools
   sudo dnf install gcc python3-devel zeromq-devel

   # Reinstall pyzmq
   pip install --upgrade --force-reinstall pyzmq

   # Force upgrade nbconvert
   pip install --upgrade jupyter nbconvert ipykernel
   ```

### Removing Title/Date from PDF Exports

1. Navigate to: `/opt/homebrew/Cellar/jupyterlab/4.3.5/libexec/share/jupyter/nbconvert/templates` (System-Wide. Don't use. Use userspace for permanent change).
   - `/home/c/.local/share/jupyter/nbconvert/templates` on fedora. Same path on Pop OS.
   - For User-specific templates (recommended) on MacOS.
     1. Make folder `mkdir -p /Users/chris/Library/Jupyter/nbconvert/templates/latex` if does not exist.
     2. Copy over system-wide files `cp -r /opt/homebrew/Cellar/jupyterlab/4.4.0_1/libexec/share/jupyter/nbconvert/templates/latex/* /Users/chris/Library/Jupyter/nbconvert/templates/latex/`. Go to 4.
   - Change Jupyterlab version and path accordingly. Replace Version Using `jupyter --paths`.
2. Edit the `latex` folder or copy to create a new template
3. Edit `base.tex.j2` file
4. Delete the line: `((* block maketitle *))\maketitle((* endblock maketitle *))`
5. Save and exit
6. Use custom template: `jupyter nbconvert --to pdf filename.ipynb --template=hide_header`

## R Markdown Configuration

### PDF Document Settings

```yaml
---
output:
  pdf_document:
    number_sections: false
    latex_engine: xelatex
  header-includes:
    - \usepackage{fontspec}
    - \usepackage{unicode-math}
---
```

## System Administration

### Set Hostname

```bash
sudo hostnamectl set-hostname your-new-hostname
```

### Font

```bash
dnf install fira-code-fonts
brew install font-fira-code
```

### POP_OS Suspend Issue on NVIDIA Drivers

First, enable NVIDIA services:
```bash
sudo systemctl enable nvidia-suspend.service
sudo systemctl enable nvidia-hibernate.service
sudo systemctl enable nvidia-resume.service
```

If Pop_OS wake does not turn on screen, edit PreserveMemoryAllocations to use a temporary directory:

```bash
sudo nano /etc/modprobe.d/nvidia-power-management.conf
```
Insert `options nvidia NVreg_PreserveVideoMemoryAllocations=1 NVreg_TemporaryFilePath=/var/tmp`, and save.

Create temporary directory and update:

```bash
sudo mkdir -p /var/tmp
sudo update-initramfs -u
sudo reboot
```

### NVIDIA Driver on Fedora

Driver available by default.

```bash
# Get all updates
sudo dnf update -y
sudo dnf install akmod-nvidia
# cuda/nvenc/nvdec support
sudo dnf install xorg-x11-drv-nvidia-cuda
```

Wait until kmod is built. Check using: `modinfo -F version nvidia`. Should output driver version number (440.64), rather than 
`modinfo: ERROR: module nvidia not found`.

### NVIDIA Driver on Ubuntu/Pop OS

To find latest updated driver:
```bash
# Current Driver and Find the driver version
nvidia-smi
apt search nvidia-driver
# Remove the current kernel driver
sudo apt remove nvidia-driver-570-open
# Install the latest stable driver (regular, not open)
sudo apt install nvidia-driver-580
# Or if you want to stick with open kernel drivers:
sudo apt install nvidia-driver-580-open
```

### Pip Upgrade All Packages:
```bash
pip --disable-pip-version-check list --outdated --format=json | python -c "import json, sys; print('\n'.join([x['name'] for x in json.load(sys.stdin)]))" | xargs -n1 pip install -U
```
## Firefox

Remove session restore when powering off without closing Firefox:
 - In `about:config`. Set `browser.sessionstore.max_resumed_crashes = 0`.

## GPTK 3.0

### Retina Support Resolution.

Add Registry Entry:

Change Path to Wine:
```WINEPREFIX=~/my-game-prefix `brew --prefix game-porting-toolkit`/bin/wine64 regedit```

Add at (New Key with name `RetinaMode` and value `y`:
```
[HKEY_CURRENT_USER\Software\Wine\Mac Driver]
"RetinaMode" = "y"
```
Go to winecfg and change dpi scaling to 254 (or depending on the screen size) under the Graphics Tab:
```
WINEPREFIX=~/my-game-prefix `brew --prefix game-porting-toolkit`/bin/wine64 winecfg
```

## UV Python Env Manager
```bash
brew install uv
```
Workflow:
```bash
cd ~/Documents/Homework/PHB_227/HW1
source ~/Documents/Homework/.venv/bin/activate
code .
# Work in VSCode, select Python or R kernel as needed
deactivate  # when done
```
Installing Global Packages (like pipx):
```bash
# Can run from anywhere
uv tool install radian
uv tool install ipython
```

Installing into .venv:
```bash
cd ~/Documents/Homework
source .venv/bin/activate
uv pip install pandas  # installs into the venv
```

## SSH GitHub Setup
```bash
ssh-keygen -t ed25519 -C "your-email@example.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub
```
Copy Public Key and Paste it into Github Settings page.

To clone:
```bash
git clone git@github.com:[Repository].git
```
## AWS Workspaces on 24.04 Ubuntu

From https://www.deplication.net/2025/03/02/installing-amazon-workspaces-ubuntu-24.html:

There is currently no Ubuntu 24.04 client for Amazon Workspaces, fortunately the 22.04 client can be installed via apt with only a minor tweak.

Following the Linux install instructions here will lead to a signature error when performing ‘apt update’:
```
Failed to fetch https://d3nt0h4h6pmmc4.cloudfront.net/ubuntu/dists/jammy/InRelease  The following signatures couldn't be verified because the public key is not available: NO_PUBKEY 04B0588859EF5026
```
The reason for this is the key from Amazon is not in the binary format apt is expecting. Changing the key retrieval command from
```
wget -q -O - https://workspaces-client-linux-public-key.s3-us-west-2.amazonaws.com/ADB332E7.asc | sudo tee /etc/apt/trusted.gpg.d/amazon-workspaces-clients.gpg > /dev/null
```
To:
```
wget -q -O - https://workspaces-client-linux-public-key.s3-us-west-2.amazonaws.com/ADB332E7.asc | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/amazon-workspaces-clients.gpg
```
Writes the key in the expected format and allows apt to verify the source signatures and install the package correctly. Note that the 22.04 client only supports DCV, you will need to modify your Workspace to switch to DCV if it is provisioned as PCoIP.


