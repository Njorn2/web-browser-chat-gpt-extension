#!/bin/bash

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

echo "-> Cleaning Project OrganizeGPT..."

echo ""

echo "-> Cleaning Project Builds..."
rm -rf build
echo " ✓ Builds Cleaned."

echo ""

echo "-> Cleaning Project Targets..."
rm -rf targets
echo " ✓ Targets Cleaned."

echo ""

echo "-> Cleaning Targets Configs..."
# BROWSERS Compabilities
file_path="BROWSERS"

# Browsers Array
browsers=()

while IFS= read -r line; do
    browsers+=("$line")
done < "$file_path"

for browser in "${browsers[@]}"; do
    echo ""
    echo "-> Cleaning target-$browser config..."
    rm -rf "target-$browser.sh"
    echo " ✓ target-$browser cleaned."
done
echo ""
echo " ✓ Targets Configs Cleaned."
