#!/bin/bash

export LANG=en_US.UTF-8

TARGETS_PATH="targets/"
browsers=("chrome" "firefox")

MANIFEST_JSON="manifest.json"
BACKGROUND_JS="background.js"
README_MD="README.md"

## Checking if Targets exists
echo "-> Checking if exist Targets Folder..."
if [ -d "$TARGETS_PATH" ]; then
    echo " \xE2\x9C\x94 Targets Folder exists."
else
    echo "-> Targets Folder does not exist. Creating..."
    mkdir "$TARGETS_PATH"
    echo " \xE2\x9C\x94 Targets Folder created."
fi

## Cleaning Targets
if [ -z "$1" ]; then
    echo "-> Cleaning Targets..."
    for browser in "${browsers[@]}"
    do
        echo "-> Cleaning: $browser Target "
        rm -rf "$TARGETS_PATH$browser"
        mkdir "$TARGETS_PATH$browser"
        echo " \xE2\x9C\x94 Targets cleaned."
    done
else
    echo "-> Cleaning Targets $1..."
    rm -rf "$TARGETS_PATH$1"
    mkdir "$TARGETS_PATH$1"
    echo " \xE2\x9C\x94 $1 Target cleaned."
fi

if [ -z "$1" ]; then
    echo "-> Creating Targets..."
    for browser in "${browsers[@]}"
    do
        echo "-> Creating Target $browser..."
        echo "-> Copying manifest.json..."
        cp "source/$browser/$MANIFEST_JSON" "$TARGETS_PATH$browser"
        echo " \xE2\x9C\x94 manifest.json Done!"

        echo "-> Copying background.json..."
        cp "source/$browser/$BACKGROUND_JS" "$TARGETS_PATH$browser"
        echo " \xE2\x9C\x94 background.json Done!"

        echo "-> Copying README.md..."
        cp "source/$browser/$README_MD" "$TARGETS_PATH$browser"
        echo " \xE2\x9C\x94 README.md Done!"

        echo "-> Copying Images..."
        mkdir "$TARGETS_PATH$browser/images"
        cp source/images/logo_top.png "$TARGETS_PATH$browser/images"
        cp source/images/icon_chat*.png "$TARGETS_PATH$browser/images"
        cp source/images/search.svg "$TARGETS_PATH$browser/images"
        echo " \xE2\x9C\x94 Images Done!"

        echo "-> Copying Popup HTML..."
        cp source/popup.html "$TARGETS_PATH$browser"
        echo " \xE2\x9C\x94 Popup HTML Done!"

        echo "-> Copying Popup JS..."
        cp source/popup.js "$TARGETS_PATH$browser"
        echo " \xE2\x9C\x94 Popup JS Done!"

        echo "-> Copying content.js..."
        cp source/content.js "$TARGETS_PATH$browser"
        echo " \xE2\x9C\x94 content.js Done!\n"

        echo " \xE2\x9C\x94 Target $browser Configured!\n"
    done
else
    echo "-> Creating Targets $1..."
    echo "-> Copying manifest.json..."
    cp "source/$1/$MANIFEST_JSON" "$TARGETS_PATH$1"
    echo " \xE2\x9C\x94 manifest.json Done!"

    echo "-> Copying background.json..."
    cp "source/$1/$BACKGROUND_JS" "$TARGETS_PATH$1"
    echo " \xE2\x9C\x94 background.json Done!"

    echo "-> Copying README.md..."
    cp "source/$1/$README_MD" "$TARGETS_PATH$1"
    echo " \xE2\x9C\x94 README.md Done!"

    echo "-> Copying Images..."
    mkdir "$TARGETS_PATH$1/images"
    cp source/images/logo_top.png "$TARGETS_PATH$1/images"
    cp source/images/icon_chat*.png "$TARGETS_PATH$1/images"
    cp source/images/search.svg "$TARGETS_PATH$1/images"
    echo " \xE2\x9C\x94 Images Done!"

    echo "-> Copying Popup HTML..."
    cp source/popup.html "$TARGETS_PATH$1"
    echo " \xE2\x9C\x94 Popup HTML Done!"

    echo "-> Copying Popup JS..."
    cp source/popup.js "$TARGETS_PATH$1"
    echo " \xE2\x9C\x94 Popup JS Done!"

    echo "-> Copying content.js..."
    cp source/content.js "$TARGETS_PATH$1"
    echo " \xE2\x9C\x94 content.js Done!\n"

    echo " \xE2\x9C\x94 Target $1 Configured!"
fi
