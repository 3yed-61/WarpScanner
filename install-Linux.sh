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

install_python() {
    echo "Installing Python..."
    sudo $PM update -y || { echo "Failed to update packages. Exiting."; exit 1; }
    
    case $PM in
        apt-get)
            sudo $PM install python3 python3-pip -y ;;
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

install_git() {
    echo "Installing Git..."
    
    case $PM in
        apt-get|yum|dnf|zypper)
            sudo $PM install git -y ;;
        pacman)
            sudo $PM -Sy git ;;
        *)
            echo "Unsupported package manager. Exiting."
            exit 1
    esac
}

install_wget() {
    echo "Installing wget..."
    
    case $PM in
        apt-get|yum|dnf|zypper)
            sudo $PM install wget -y ;;
        pacman)
            sudo $PM -Sy wget ;;
        *)
            echo "Unsupported package manager. Exiting."
            exit 1
    esac
}

install_curl() {
    echo "Installing curl..."
    
    case $PM in
        apt-get|yum|dnf|zypper)
            sudo $PM install curl -y ;;
        pacman)
            sudo $PM -Sy curl ;;
        *)
            echo "Unsupported package manager. Exiting."
            exit 1
    esac
}

# Determine the package manager
detect_package_manager

# Install Python if not already installed
if ! command -v python3 &> /dev/null || ! command -v pip3 &> /dev/null; then
    install_python
fi

# Install Git if not already installed
if ! command -v git &> /dev/null; then
    install_git
fi

# Install wget if not already installed
if ! command -v wget &> /dev/null; then
    install_wget
fi

# Install curl if not already installed
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
