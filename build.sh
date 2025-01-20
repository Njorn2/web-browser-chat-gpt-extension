#!/bin/bash

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

echo "###############################"
echo "#      Build OrganizeGPT      #"
echo "###############################"

echo ""

echo "-> Cleaning Past Buildts..."
rm -rf build
mkdir build
echo " ✓ Clean Past Buildts completed!"

echo ""

MANIFEST_FILE="source/manifest.json"

echo "-> Checking Version."
version_file="VERSION"
browsers_path="BROWSERS"
VERSION="1.0.0"

# Read the version from the file
if [ -f "$version_file" ]; then
    VERSION=$(cat "$version_file")
fi
echo "-> Current Version v$VERSION"

echo ""

readmeFile="README.md"
sed -i '' "s/\(version-\)[0-9]*\.[0-9]*\.[0-9]*/\1$VERSION/" "$readmeFile"
sed -i '' "s|\(tag/\)[0-9]*\.[0-9]*\.[0-9]*|\1$VERSION|" "$readmeFile"

# Browsers Array
browsers=()

# Read the file line by line and populate the array
echo "-> Getting Browsers compabilities from BROWSERS File."
while IFS= read -r line; do
    browsers+=("$line")
done < "$browsers_path"

echo " ✓ Building to ${browsers[@]}"

echo ""

echo "-> Starting Builds"
for browser in "${browsers[@]}"; do
    echo "-> Starting build for $browser"
    mkdir build/$browser
    echo "-> Starting Copying Files..."

    echo ""

    # Copying Sources to build.
    echo "-> Copying Images..."
    mkdir build/$browser/images
    cp source/images/logo_top.png build/$browser/images
    cp source/images/icon_chat*.png build/$browser/images
    cp source/images/search.svg build/$browser/images
    echo " ✓ Images Done!"

    echo ""

    echo "-> Copying Manifest..."
    cp "source/$browser/manifest.json" build/$browser
    echo " ✓ Manifest Done!"
    echo "-> Copying Popup HTML..."
    cp source/popup.html build/$browser
    echo " ✓ Popup HTML Done!"

    echo ""
    echo " ✓ Copying files Done!"
    echo ""

    echo "-> Starting Minifyings..."
    echo "-> Minifying popup.js..."
    # Minify popup.js
    npx terser source/popup.js --compress --mangle --output build/$browser/popup.min.js
    echo " ✓ popup.min.js done!"

    echo ""

    # Minify background.js
    echo "-> Minifying background.js..."
    npx terser source/$browser/background.js --compress --mangle --output build/$browser/background.min.js
    echo " ✓ backrgound.min.js done!"

    echo ""

    # Minify content.js
    echo "-> Minifying content.js..."
    npx terser source/content.js --compress --mangle --output build/$browser/content.min.js
    echo " ✓ content.min.js done!"

    echo ""

    # Use sed to replace the string
    echo "-> Replacing popup.min.js on popup.html..."
    popupHtmlFile="build/$browser/popup.html"
    sed -i '' 's#<script src="popup.js" defer></script>#<script src="popup.min.js" defer></script>#' "$popupHtmlFile"
    echo " ✓ Replacing popup.min.js done!"

    echo ""

    echo "-> Replacing content.min.js on manifest.json..."
    manifestFile="build/$browser/manifest.json"
    sed -i '' 's#\"js\"\:\ \[\"content\.js\"\]\,#\"js\"\:\ \[\"content\.min\.js\"\]\,#' "$manifestFile"
    echo " ✓ Replacing content.min.js done!"

    echo ""

    echo "-> Replacing background.min.js on manifest.json..."
    if [ "$browser" == "firefox" ]; then
        sed -i '' 's#\"scripts\"\:\ \[\"background\.js\"\]#\"scripts\"\:\ \[\"background\.min\.js\"\]#' "$manifestFile"
    elif [ "$browser" == "chrome" ]; then
        sed -i '' 's#\"service_worker\"\:\ \"background\.js\"#\"service_worker\"\:\ \"background\.min\.js\"#' "$manifestFile"
    elif [ "$browser" == "opera" ]; then
        sed -i '' 's#\"service_worker\"\:\ \"background\.js\"#\"service_worker\"\:\ \"background\.min\.js\"#' "$manifestFile"
    else
        echo "Browser not supported: $browser"
    fi
    echo " ✓ Replacing background.min.js done!"

    echo ""

    # Check the exit status of the command
    if [ $? -ne 0 ]; then
        echo "--> Build failed! :( <--" >&2
        exit 1  # Exit the script with a non-zero status
    else
        echo " ✓ Build v$VERSION to $browser successfully!  ✓"
    fi
    echo " ✓ $browser extension built!"
done
echo " ✓ Extensions to ${browsers[@]} built!"

echo "-> Ziping buildts to publish..."
mkdir build/zips
for browser in "${browsers[@]}"; do
    echo "-> Compressing $browser"
    cd build/$browser/ && zip -r ../zips/organizegpt-$browser.zip . && cd ../../
    cd targets/$browser/ && zip -r ../../build/zips/organizegpt-$browser-source.zip . && cd ../../
    echo " ✓ $browser compressed!"
done
echo " ✓ Buildts compressed!"

# Check the exit status of the command
if [ $? -ne 0 ]; then
    echo ""
    echo "--> Compression failed! :( <--" >&2
    echo ""
    exit 1  # Exit the script with a non-zero status
else
    echo ""
    echo " ✓ Compression v$VERSION successfully!  ✓"
    echo ""
fi
