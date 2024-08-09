#!/bin/bash

install_python() {
    echo "Installing Python..."
    sudo apt update -y || { echo "Failed to update packages. Exiting."; exit 1; }
    sudo apt install python3 -y || { echo "Failed to install Python. Exiting."; exit 1; }
    sudo apt install python3-pip -y || { echo "Failed to install pip. Exiting."; exit 1; }
}

install_git() {
    echo "Installing Git..."
    sudo apt install git -y || { echo "Failed to install Git. Exiting."; exit 1; }
}

install_wget() {
    echo "Installing wget..."
    sudo apt install wget -y || { echo "Failed to install wget. Exiting."; exit 1; }
}

install_curl() {
    echo "Installing curl..."
    sudo apt install curl -y || { echo "Failed to install curl. Exiting."; exit 1; }
}

# Check and install Python and pip
if ! command -v python3 &>/dev/null || ! command -v pip3 &>/dev/null; then
    install_python
fi

# Check and install Git
if ! command -v git &>/dev/null; then
    install_git
fi

# Check and install wget
if ! command -v wget &>/dev/null; then
    install_wget
fi

# Check and install curl
if ! command -v curl &>/dev/null; then
    install_curl
fi

# Function to download the latest WarpScanner.py
download_warp_scanner() {
    echo "Downloading WarpScanner.py..."
    curl -fsSL -o WarpScanner.py https://raw.githubusercontent.com/3yed-61/WarpScanner/main/WarpScanner.py || { echo "Failed to download WarpScanner.py. Exiting."; exit 1; }
}

# Check the existence and validity of WarpScanner.py
if [ -f WarpScanner.py ]; then
    first_line=$(head -n 1 WarpScanner.py)
    if [[ "$first_line" == *"import urllib.request"* || "$first_line" != "V=31" ]]; then
        rm WarpScanner.py
        download_warp_scanner
    fi
else
    download_warp_scanner
fi

# Run WarpScanner.py
python3 WarpScanner.py
