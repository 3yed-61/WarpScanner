#!/bin/bash

install_python() {
    echo "Installing Python..."
    sudo apt update -y || { echo "Failed to update packages. Exiting."; exit 1; }
    sudo apt install python3 -y || { echo "Failed to install Python. Exiting."; exit 1; }
    sudo apt install python3-pip -y || { echo "Failed to install Python. Exiting."; exit 1; }
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

if ! command -v python3 || ! command -v pip3; then
    install_python
fi

if ! command -v git; then
    install_git
fi

if ! command -v wget; then
    install_wget
fi

if ! command -v curl; then
    install_curl
fi

if [ -f WarpScanner.py ]; then
    first_line=$(head -n 1 WarpScanner.py)
    if [ "$first_line" == "import urllib.request" ]; then
        rm WarpScanner.py
        echo "Updating WarpScanner.py..."
        curl -fsSL -o WarpScanner.py https://raw.githubusercontent.com/3yed-61/WarpScanner/main/WarpScanner.py || { echo "Failed to download WarpScanner.py. Exiting."; exit 1; }
        python3 WarpScanner.py
        exit 0
    fi
fi

if [ -f WarpScanner.py ]; then
    first_line=$(head -n 1 WarpScanner.py)
    if [ "$first_line" != "V=31" ]; then
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

echo "Installing WarpScanner.py"
curl -fsSL -o WarpScanner.py https://raw.githubusercontent.com/3yed-61/WarpScanner/main/WarpScanner.py || { echo "Failed to download WarpScanner.py. Exiting."; exit 1; }
python3 WarpScanner.py
