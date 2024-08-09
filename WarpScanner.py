#!/bin/bash

# Function to determine the package manager
detect_package_manager() {
    if command -v apt-get &> /dev/null; then
        PM="apt-get"
    elif command -v yum &> /dev/null; then
        PM="yum"
    elif command -v dnf &> /dev/null; then
        PM="dnf"
    elif command -v zypper &> /dev/null; then
        PM="zypper"
    elif command -v pacman &> /dev/null; then
        PM="pacman"
    else
        echo "Unsupported package manager. Exiting."
        exit 1
    fi
}

# Function to install Python and pip
install_python() {
    echo "Installing Python and pip..."
    sudo $PM update -y || { echo "Failed to update packages. Exiting."; exit 1; }

    case $PM in
        apt-get)
            sudo $PM install python3 python3-pip python3-venv -y ;;
        yum|dnf)
            sudo $PM install python3 python3-pip -y ;;
        zypper)
            sudo $PM install python3 python3-pip -y ;;
        pacman)
            sudo $PM -Sy python python-pip ;;
        *)
            echo "Unsupported package manager. Exiting."
            exit 1
    esac
}

# Function to install required packages
install_requirements() {
    echo "Setting up virtual environment and installing required Python packages..."
    
    python3 -m venv warp_env || { echo "Failed to create virtual environment. Exiting."; exit 1; }
    source warp_env/bin/activate || { echo "Failed to activate virtual environment. Exiting."; exit 1; }
    pip install retrying || { echo "Failed to install required Python packages. Exiting."; exit 1; }
}

# Function to download and run WarpScanner.py
run_warp_scanner() {
    echo "Checking for WarpScanner.py..."
    
    if [ -f WarpScanner.py ]; then
        first_line=$(head -n 1 WarpScanner.py)
        if [ "$first_line" != "V=31" ]; then
            rm WarpScanner.py
            echo "Updating WarpScanner.py..."
            curl -fsSL -o WarpScanner.py https://raw.githubusercontent.com/3yed-61/WarpScanner/main/WarpScanner.py || { echo "Failed to download WarpScanner.py. Exiting."; exit 1; }
        fi
    else
        echo "Downloading WarpScanner.py..."
        curl -fsSL -o WarpScanner.py https://raw.githubusercontent.com/3yed-61/WarpScanner/main/WarpScanner.py || { echo "Failed to download WarpScanner.py. Exiting."; exit 1; }
    fi

    echo "Running WarpScanner.py..."
    python3 WarpScanner.py
}

# Main script execution

# Detect the package manager
detect_package_manager

# Install Python if not already installed
if ! command -v python3 &> /dev/null || ! command -v pip3 &> /dev/null; then
    install_python
fi

# Install Python requirements
install_requirements

# Run WarpScanner.py
run_warp_scanner
