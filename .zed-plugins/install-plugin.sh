#!/bin/bash

# Input JSON files
keymap_file="$HOME/.config/zed/keymap.json"
new_keymap_file=".zed-plugins/keymap.json"
temp_file=".zed-plugins/updated_keymap.json"

echo "Installing plugin OrganizeGPT Plugins..."

# Installing new keymaps
if [ ! -f "$keymap_file" ] || [ ! -f "$new_keymap_file" ]; then
  echo "Error: One or both JSON files do not exist."
  exit 1
fi

# Validate JSON syntax
if ! jq empty "$keymap_file" > /dev/null 2>&1; then
  echo "Error: Invalid JSON in $keymap_file"
  exit 1
fi

if ! jq empty "$new_keymap_file" > /dev/null 2>&1; then
  echo "Error: Invalid JSON in $new_keymap_file"
  exit 1
fi

# Merge JSON content using jq
jq -s '
  reduce .[] as $item ([];
    reduce $item[] as $entry (.;
      if any(.context == $entry.context) then
        map(if .context == $entry.context
          then .bindings += $entry.bindings
          else .
          end)
      else
        . + [$entry]
      end
    )
  )
' "$keymap_file" "$new_keymap_file" > "$temp_file"

# Check for jq command success
if [ $? -ne 0 ]; then
  echo "Error: Failed to merge JSON files"
  exit 1
fi

# Replace the original file with merged content
mv "$temp_file" "$keymap_file"

echo " ✓ OrganizeGPT Project Plugin Shortcuts Installed successfully."
