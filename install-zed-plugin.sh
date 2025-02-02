#!/bin/bash

echo "-> Checking technologies to install Zed OrgaizeGPT Project Plugins..."
os=""
if [ "$(uname -s)" = "Darwin" ]; then
    echo "-> System MacOS Detected!"
    os="macos"
elif [ "$(uname -s)" = "Linux" ]; then
    echo "-> System Linux Detected!"
    os="linux"
else
    echo "Unknown OS"
fi

echo ""

echo "-> Installing plugin OrganizeGPT Plugins..."
echo ""
if [ $os = "macos" ]; then
    echo "-> Starting Ruby..."
    ruby .zed-plugins/$os/install-plugin.rb
else
    if command -v node &> /dev/null
    then
        echo "-> Starting NodeJS..."
        node .zed-plugins/$os/install-plugin.js
    else
        if command -v deno &> /dev/null
        then
            echo "-> Starting Deno..."
            deno run --allow-read --allow-writerun --allow-read --allow-write .zed-plugins/$os/install-plugin.js
        else
            echo "OrganizeGPT Zed Plugin is NOT installed. Please, install one of Ruby, NodeJS or Deno to install plugin."
            echo "-> Installing Ruby: brew install ruby"
            echo "-> Installing Node: brew install node"
            echo "-> Install Deno: brew install deno"
        fi
    fi
fi
