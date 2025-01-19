#!/bin/bash

echo "###########################################"
echo "#                                         #"
echo "# Configuring Browsers Compatible Targets #"
echo "#                                         #"
echo "###########################################"

echo "-> Checking Version."
version_file="VERSION"
VERSION="1.0.0"

# Read the version from the file
if [ -f "$version_file" ]; then
    VERSION=$(cat "$version_file")
fi
echo "-> Current Version v$VERSION"

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

# Iterate over the array \xE2\x9C\x94
echo "-> Creting Targets"
for browser in "${browsers[@]}"; do
    echo "-> Creating target-$browser.sh"
    touch "target-$browser.sh"
    echo "sh target.sh $browser" > "target-$browser.sh"
    echo " \xE2\x9C\x94 target-$browser.sh created."
done
echo "\n \xE2\x9C\x94 Targets ${browsers[@]} created!"
