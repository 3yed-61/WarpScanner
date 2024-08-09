#!/bin/bash

install_python() {
    echo "Installing Python..."
    sudo apt-get update -y || { echo "Failed to update packages. Exiting."; exit 1; }
    sudo apt-get install python3 python3-pip -y || { echo "Failed to install Python. Exiting."; exit 1; }
}

install_git() {
    echo "Installing Git..."
    sudo apt-get install git -y || { echo "Failed to install Git. Exiting."; exit 1; }
}

install_wget() {
    echo "Installing wget..."
    sudo apt-get install wget -y || { echo "Failed to install wget. Exiting."; exit 1; }
}

install_curl() {
    echo "Installing curl..."
    sudo apt-get install curl -y || { echo "Failed to install curl. Exiting."; exit 1; }
}

# Check if Python is installed
if ! command -v python3 &> /dev/null || ! command -v pip3 &> /dev/null; then
    install_python
fi

# Check if Git is installed
if ! command -v git &> /dev/null; then
    install_git
fi

# Check if wget is installed
if ! command -v wget &> /dev/null; then
    install_wget
fi

# Check if curl is installed
if ! command -v curl &> /dev/null; then
    install_curl
fi

# Check if WarpScanner.py exists and update if necessary
if [ -f WarpScanner.py ]; then
    first_line=$(head -n 1 WarpScanner.py)
    if [ "$first_line" == "import urllib.request" ] || [ "$first_line" != "V=31" ]; then
        rm WarpScanner.py
        echo "Updating WarpScanner.py..."
        curl -fsSL -o WarpScanner.py https://raw.githubusercontent.com/3yed-61/WarpScanner/main/WarpScanner.py || { echo "Failed to download WarpScanner.py. Exiting."; exit 1; }
        python3 WarpScanner.py
        exit 0
    else
        python3 WarpScanner.py
        exit 0
    fi
fi

# Download and run WarpScanner.py if it doesn't exist
echo "Downloading WarpScanner.py..."
curl -fsSL -o WarpScanner.py https://raw.githubusercontent.com/3yed-61/WarpScanner/main/WarpScanner.py || { echo "Failed to download WarpScanner.py. Exiting."; exit 1; }
python3 WarpScanner.py
