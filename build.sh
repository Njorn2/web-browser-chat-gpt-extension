#!/bin/bash

echo "###############################"
echo "#      Build OrganizeGPT      #"
echo "###############################\n"

echo "-> Cleaning Past Buildts..."
rm -rf build
mkdir build
echo " \xE2\x9C\x94 Clean Past Buildts completed!\n"

MANIFEST_FILE="source/manifest.json"

echo "-> Checking Version."
version_file="VERSION"
browsers_path="BROWSERS"
VERSION="1.0.0"

# Read the version from the file
if [ -f "$version_file" ]; then
    VERSION=$(cat "$version_file")
fi
echo "-> Current Version v$VERSION\n"

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

echo " \xE2\x9C\x94 Building to ${browsers[@]}\n"

echo "-> Starting Builds\n"
for browser in "${browsers[@]}"; do
    echo "-> Starting build for $browser"
    mkdir build/$browser
    echo "\n-> Starting Copying Files...\n"

    # Copying Sources to build.
    echo "-> Copying Images..."
    mkdir build/$browser/images
    cp source/images/logo_top.png build/$browser/images
    cp source/images/icon_chat*.png build/$browser/images
    cp source/images/search.svg build/$browser/images
    echo " \xE2\x9C\x94 Images Done!\n"

    echo "-> Copying Manifest..."
    cp "source/$browser/manifest.json" build/$browser
    echo " \xE2\x9C\x94 Manifest Done!\n"
    echo "-> Copying Popup HTML..."
    cp source/popup.html build/$browser
    echo " \xE2\x9C\x94 Popup HTML Done!\n"

    echo " \xE2\x9C\x94 Copying files Done!\n"

    echo "-> Starting Minifyings...\n"
    echo "-> Minifying popup.js..."
    # Minify popup.js
    npx terser source/popup.js --compress --mangle --output build/$browser/popup.min.js
    echo " \xE2\x9C\x94 popup.min.js done!\n"

    # Minify background.js
    echo "-> Minifying background.js..."
    npx terser source/$browser/background.js --compress --mangle --output build/$browser/background.min.js
    echo " \xE2\x9C\x94 backrgound.min.js done!\n"

    # Minify content.js
    echo "-> Minifying content.js..."
    npx terser source/content.js --compress --mangle --output build/$browser/content.min.js
    echo " \xE2\x9C\x94 content.min.js done!\n"

    # Use sed to replace the string
    echo "-> Replacing popup.min.js on popup.html..."
    popupHtmlFile="build/$browser/popup.html"
    sed -i '' 's#<script src="popup.js" defer></script>#<script src="popup.min.js" defer></script>#' "$popupHtmlFile"
    echo " \xE2\x9C\x94 Replacing popup.min.js done!\n"

    echo "-> Replacing content.min.js on manifest.json..."
    manifestFile="build/$browser/manifest.json"
    sed -i '' 's#\"js\"\:\ \[\"content\.js\"\]\,#\"js\"\:\ \[\"content\.min\.js\"\]\,#' "$manifestFile"
    echo " \xE2\x9C\x94 Replacing content.min.js done!\n"

    echo "-> Replacing background.min.js on manifest.json..."
    if [ "$browser" == "firefox" ]; then
        sed -i '' 's#\"scripts\"\:\ \[\"background\.js\"\]#\"scripts\"\:\ \[\"background\.min\.js\"\]#' "$manifestFile"
    elif [ "$browser" == "chrome" ]; then
        sed -i '' 's#\"service_worker\"\:\ \"background\.js\"#\"service_worker\"\:\ \"background\.min\.js\"#' "$manifestFile"
    else
        echo "Browser not supported: $browser"
    fi
    echo " \xE2\x9C\x94 Replacing background.min.js done!\n"

    # Check the exit status of the command
    if [ $? -ne 0 ]; then
        echo "\n--> Build failed! :( <--\n" >&2
        exit 1  # Exit the script with a non-zero status
    else
        echo " \xE2\x9C\x94 Build v$VERSION to $browser successfully!  \xE2\x9C\x94\n"
    fi
    echo " \xE2\x9C\x94 $browser extension built!\n"
done
echo "\n \xE2\x9C\x94 Extensions to ${browsers[@]} built!\n"

echo "-> Ziping buildts to publish..."
mkdir build/zips
for browser in "${browsers[@]}"; do
    echo "-> Compressing $browser"
    cd build/$browser/ && zip -r ../zips/organizegpt-$browser.zip . && cd ../../
    cd targets/$browser/ && zip -r ../../build/zips/organizegpt-$browser-source.zip . && cd ../../
    echo " \xE2\x9C\x94 $browser compressed!\n"
done
echo " \xE2\x9C\x94 Buildts compressed!\n"

# Check the exit status of the command
if [ $? -ne 0 ]; then
    echo ""
    echo "--> Compression failed! :( <--" >&2
    echo ""
    exit 1  # Exit the script with a non-zero status
else
    echo ""
    echo " \xE2\x9C\x94 Compression v$VERSION successfully!  \xE2\x9C\x94"
    echo ""
fi
