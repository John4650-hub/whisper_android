#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Installing Apktool..."
# Install Apktool
curl -L https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool -o apktool
curl -L https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.9.3.jar -o apktool.jar

sudo mv apktool apktool.jar /usr/local/bin/

# Install Java if not already installed (required for Apktool)
if ! command -v java &> /dev/null; then
    echo "Java not found. Installing Java..."
    sudo apt update
    sudo apt install -y default-jdk
fi

# Download the APK file from the provided URL
APK_URL="$1"  # The first argument passed to the script
APK_NAME="downloaded.apk"
echo "Downloading APK from $APK_URL..."
curl -o "$APK_NAME" "$APK_URL"

# Decompile the APK
echo "Decompiling APK..."
apktool d "$APK_NAME" -o decompiled_apk

# Modify minsdkVersion in apktool.yml
echo "Modifying minsdkVersion in apktool.yml..."
sed -i 's/minSdkVersion: .*/minSdkVersion: 23/' decompiled_apk/apktool.yml

# Recompile the APK
echo "Recompiling APK..."
apktool b decompiled_apk -o recompiled.apk

# Output the recompiled APK as an artifact
echo "Recompiled APK is ready: recompiled.apk"
