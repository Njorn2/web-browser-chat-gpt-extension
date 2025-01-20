#!/bin/bash

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

TARGETS_PATH="targets/"

# BROWSERS Compabilities
file_path="BROWSERS"

# Browsers Array
browsers=()

# Read the file line by line and populate the array
echo "-> Getting Browsers compabilities from BROWSERS File."
while IFS= read -r line; do
    browsers+=("$line")
done < "$file_path"

# Print the array elements to verify
echo "-> Configuring targes to: ${browsers[@]}"

echo ""


MANIFEST_JSON="manifest.json"
BACKGROUND_JS="background.js"
README_MD="README.md"

## Checking if Targets exists
echo "-> Checking if exist Targets Folder..."
if [ -d "$TARGETS_PATH" ]; then
    echo " ✓ Targets Folder exists."
else
    echo "-> Targets Folder does not exist. Creating..."
    mkdir "$TARGETS_PATH"
    echo " ✓ Targets Folder created."
fi

echo ""

## Cleaning Targets
if [ -z "$1" ]; then
    echo "-> Cleaning Targets..."
    for browser in "${browsers[@]}"
    do
        echo "-> Cleaning: $browser Target "
        rm -rf "$TARGETS_PATH$browser"
        mkdir "$TARGETS_PATH$browser"
        echo " ✓ Targets cleaned."
    done
else
    echo "-> Cleaning Targets $1..."
    rm -rf "$TARGETS_PATH$1"
    mkdir "$TARGETS_PATH$1"
    echo " ✓ $1 Target cleaned."
fi

echo ""

if [ -z "$1" ]; then
    echo "-> Creating Targets..."
    for browser in "${browsers[@]}"
    do
        echo "-> Creating Target $browser..."
        echo "-> Copying manifest.json..."
        cp "source/$browser/$MANIFEST_JSON" "$TARGETS_PATH$browser"
        echo " ✓ manifest.json Done!"

        echo ""

        echo "-> Copying background.json..."
        cp "source/$browser/$BACKGROUND_JS" "$TARGETS_PATH$browser"
        echo " ✓ background.json Done!"

        echo ""

        echo "-> Copying README.md..."
        cp "source/$browser/$README_MD" "$TARGETS_PATH$browser"
        echo " ✓ README.md Done!"

        echo ""

        echo "-> Copying Images..."
        mkdir "$TARGETS_PATH$browser/images"
        cp source/images/logo_top.png "$TARGETS_PATH$browser/images"
        cp source/images/icon_chat*.png "$TARGETS_PATH$browser/images"
        cp source/images/search.svg "$TARGETS_PATH$browser/images"
        echo " ✓ Images Done!"

        echo ""

        echo "-> Copying Popup HTML..."
        cp source/popup.html "$TARGETS_PATH$browser"
        echo " ✓ Popup HTML Done!"

        echo ""

        echo "-> Copying Popup JS..."
        cp source/popup.js "$TARGETS_PATH$browser"
        echo " ✓ Popup JS Done!"

        echo ""

        echo "-> Copying content.js..."
        cp source/content.js "$TARGETS_PATH$browser"
        echo " ✓ content.js Done!"

        echo ""

        echo " ✓ Target $browser Configured!"

        echo ""
    done
else
    echo "-> Creating Targets $1..."

    echo ""

    echo "-> Copying manifest.json..."
    cp "source/$1/$MANIFEST_JSON" "$TARGETS_PATH$1"
    echo " ✓ manifest.json Done!"

    echo ""

    echo "-> Copying background.json..."
    cp "source/$1/$BACKGROUND_JS" "$TARGETS_PATH$1"
    echo " ✓ background.json Done!"

    echo ""

    echo "-> Copying README.md..."
    cp "source/$1/$README_MD" "$TARGETS_PATH$1"
    echo " ✓ README.md Done!"

    echo ""

    echo "-> Copying Images..."
    mkdir "$TARGETS_PATH$1/images"
    cp source/images/logo_top.png "$TARGETS_PATH$1/images"
    cp source/images/icon_chat*.png "$TARGETS_PATH$1/images"
    cp source/images/search.svg "$TARGETS_PATH$1/images"
    echo " ✓ Images Done!"

    echo ""

    echo "-> Copying Popup HTML..."
    cp source/popup.html "$TARGETS_PATH$1"
    echo " ✓ Popup HTML Done!"

    echo ""

    echo "-> Copying Popup JS..."
    cp source/popup.js "$TARGETS_PATH$1"
    echo " ✓ Popup JS Done!"

    echo ""

    echo "-> Copying content.js..."
    cp source/content.js "$TARGETS_PATH$1"
    echo " ✓ content.js Done!"

    echo ""

    echo " ✓ Target $1 Configured!"
fi
