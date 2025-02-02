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
    ruby .vscode/$os/install-plugin.rb
else
    echo "OrganizeGPT Zed Plugin is NOT installed. Please, install Ruby to install plugin."
    echo "-> Installing Ruby: brew install ruby"
fi
