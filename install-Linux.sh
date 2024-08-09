#!/bin/bash

install_python() {
    echo "Installing Python..."
    sudo apt update -y || { echo "Failed to update packages. Exiting."; exit 1; }
    sudo apt install python3 -y || { echo "Failed to install Python. Exiting."; exit 1; }
    sudo apt install python3-pip -y || { echo "Failed to install pip. Exiting."; exit 1; }
    sudo apt install python3-venv -y || { echo "Failed to install venv. Exiting."; exit 1; }
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

# Check and install Python, pip and venv
if ! command -v python3 &>/dev/null || ! command -v pip3 &>/dev/null || ! python3 -m venv --help &>/dev/null; then
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

# Create a virtual environment
echo "Creating a virtual environment..."
python3 -m venv myenv || { echo "Failed to create virtual environment. Exiting."; exit 1; }

# Activate the virtual environment
source myenv/bin/activate

# Install Python modules in the virtual environment
pip install retrying icmplib || { echo "Failed to install required modules. Exiting."; deactivate; exit 1; }

# Function to download the latest WarpScanner.py
download_warp_scanner() {
    echo "Downloading WarpScanner.py..."
    curl -fsSL -o WarpScanner.py https://raw.githubusercontent.com/3yed-61/WarpScanner/main/WarpScanner.py || { echo "Failed to download WarpScanner.py. Exiting."; deactivate; exit 1; }
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

# Run WarpScanner.py using the virtual environment
python WarpScanner.py

# Deactivate the virtual environment after execution
deactivate
