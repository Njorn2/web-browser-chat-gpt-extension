#!/bin/bash

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

echo "###########################################"
echo "#                                         #"
echo "# Configuring Browsers Compatible Targets #"
echo "#                                         #"
echo "###########################################"

echo "-> Checking OS..."
os=""
cmd=""
if [ "$(uname -s)" = "Darwin" ]; then
    echo "-> System MacOS Selected!"
    os="macos"
    cmd="sh"
elif [ "$(uname -s)" = "Linux" ]; then
    echo "-> System Linux Selected!"
    os="linux"
    cmd="bash"
else
    echo "Unknown OS"
    cmd="sh"
fi

echo "-> Checking Version."
version_file="VERSION"
VERSION="1.0.0"

# Read the version from the file
if [ -f "$version_file" ]; then
    VERSION=$(cat "$version_file")
fi
echo "-> Current Version v$VERSION"

echo ""

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
echo "-> Compatible Browsers: ${browsers[@]}"

echo ""

# Iterate over the array ✓
echo "-> Creating Targets Config"
for browser in "${browsers[@]}"; do

    echo ""

    echo "-> Creating target-$browser.sh"
    touch "target-$browser.sh"
    echo "$cmd target.sh $browser" > "target-$browser.sh"
    echo " ✓ target-$browser.sh created."
done

echo ""

echo "-> Configuring Targets"
for browser in "${browsers[@]}"; do

    echo ""

    echo "-> Running target-$browser.sh"
    $cmd target-$browser.sh
    echo " ✓ target-$browser.sh configured."
done

echo ""

echo " ✓ Targets ${browsers[@]} created!"
