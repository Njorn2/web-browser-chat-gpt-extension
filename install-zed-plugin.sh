#!/bin/bash

echo "-> Checking technologies to install Zed OrgaizeGPT Project Plugins..."
echo ""
echo "Installing plugin OrganizeGPT Plugins..."
if command -v node &> /dev/null
then
    node .zed-plugins/install-plugin.js
else
    if command -v deno &> /dev/null
    then
        deno run --allow-read --allow-writerun --allow-read --allow-write .zed-plugins/install-plugin.js
    else
    if command -v jq &> /dev/null
        then
            echo "installing on Shell Script"
        else
            echo "OrganizeGPT Zed Plugin is NOT installed. Please, install one of NodeJS, Deno or JQ to install plugin."
            if [ "$(uname)" == "Darwin" ]; then
                echo "-> Installing Node: brew install node"
                echo "-> Install Deno: brew install deno"
                echo "-> Install JQ: brew install jq"
            elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
                echo "-> Installing Node: brew install node"
                echo "-> Install Deno:"
                echo "---> curl -fsSL https://deno.land/x/install/install.sh | sh"
                echo "---> sudo apt update"
                echo "---> sudo apt install snapd"
                echo "---> sudo snap install deno"
                echo "-> End Install Deno. "
                echo "-> Install JQ: sudo apt install jq"
            fi

            echo "Install sudo apt install nodejs"
        fi
    fi
fi
