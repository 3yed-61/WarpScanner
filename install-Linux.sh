#!/bin/bash

logfile="install.log"

log_error() {
    echo "$1" | tee -a $logfile
}

install_python() {
    echo "Installing Python..."
    apt install sudo -y || { log_error "Failed to install sudo. Exiting."; exit 1; }
    sudo apt update -y || { log_error "Failed to update packages. Exiting."; exit 1; }
    sudo apt install python3 -y || { log_error "Failed to install Python. Exiting."; exit 1; }
    sudo apt install python3-pip -y || { log_error "Failed to install pip. Exiting."; exit 1; }
    sudo apt install python3-venv -y || { log_error "Failed to install venv. Exiting."; exit 1; }
}

install_git() {
    echo "Installing Git..."
    sudo apt install git -y || { log_error "Failed to install Git. Exiting."; exit 1; }
}

install_wget() {
    echo "Installing wget..."
    sudo apt install wget -y || { log_error "Failed to install wget. Exiting."; exit 1; }
}

install_curl() {
    echo "Installing curl..."
    sudo apt install curl -y || { log_error "Failed to install curl. Exiting."; exit 1; }
}

# Check and install Python, pip, and venv
if ! command -v python3 &>/dev/null; then
    log_error "Python3 not found."
    install_python
elif ! command -v pip3 &>/dev/null; then
    log_error "pip3 not found."
    install_python
elif ! python3 -m venv --help &>/dev/null; then
    log_error "python3-venv not found."
    install_python
fi

# Check and install Git
if ! command -v git &>/dev/null; then
    log_error "Git not found."
    install_git
fi

# Check and install wget
if ! command -v wget &>/dev/null; then
    log_error "wget not found."
    install_wget
fi

# Check and install curl
if ! command -v curl &>/dev/null; then
    log_error "curl not found."
    install_curl
fi

# Create or activate the virtual environment
if [ ! -d "myenv" ]; then
    echo "Creating a virtual environment..."
    python3 -m venv myenv || { log_error "Failed to create virtual environment. Exiting."; exit 1; }
fi

# Activate the virtual environment
source myenv/bin/activate || { log_error "Failed to activate virtual environment. Exiting."; exit 1; }

# Install Python modules in the virtual environment
pip install retrying icmplib || { log_error "Failed to install required modules. Exiting."; deactivate; exit 1; }

# Function to download the latest WarpScanner_Linux.py
download_warp_scanner() {
    echo "Downloading WarpScanner_Linux.py..."
    curl -fsSL -o WarpScanner_Linux.py https://raw.githubusercontent.com/3yed-61/WarpScanner/main/WarpScanner_Linux.py || { log_error "Failed to download WarpScanner_Linux.py. Exiting."; deactivate; exit 1; }
}

# Check the existence and validity of warpscanner-Linux.py
if [ -f WarpScanner_Linux.py ]; then
    first_line=$(head -n 1 WarpScanner_Linux.py)
    if [[ "$first_line" == *"import urllib.request"* || "$first_line" != "V=31" ]]; then
        rm WarpScanner_Linux.py
        download_warp_scanner
    fi
else
    download_warp_scanner
fi

# Run WarpScanner_Linux.py using the virtual environment
python WarpScanner_Linux.py || { log_error "Failed to run WarpScanner_Linux.py. Exiting."; deactivate; exit 1; }

# Deactivate the virtual environment after execution
deactivate
