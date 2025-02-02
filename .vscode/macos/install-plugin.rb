require 'json'
require 'fileutils'

KEYMAP_PATH = ".vscode/keymap.json"

def read_file(file_path)
  File.read(file_path)
end

def write_file(file_path, content)
  FileUtils.mkdir_p(File.dirname(file_path))
  File.write(file_path, content)
end

def update_keymaps(existing_keymaps, new_keymaps)
  keymap_map = existing_keymaps
  if keymap_map.length() > 0
    keymap_map = keymap_map.concat(new_keymaps).uniq
  else
    keymap_map = new_keymaps
  end
  keymap_map
end

def remove_json_comments(json_string)
  json_string.gsub(/\/\/.*$/, '')
             .gsub(/\/\*.*?\*\//m, '')
end

def install_keymaps(home_dir)
  keymap_json_path = File.join(home_dir, 'Library/Application Support/Code/User/keybindings.json')
  new_keymaps_path = KEYMAP_PATH

  begin
    existing = JSON.parse(remove_json_comments(File.read(keymap_json_path)))
    new_keymaps = JSON.parse(File.read(new_keymaps_path))
    merged = update_keymaps(existing, new_keymaps)
    write_file(keymap_json_path, JSON.pretty_generate(merged))
    puts "✓ Keymaps installed successfully"
  rescue => e
    puts "Error installing keymaps: #{e}"
  end
end

def detect_os
  case RUBY_PLATFORM.downcase
  when /darwin/ then 'macos'
  when /linux/ then 'linux'
  else 'unknown'
  end
end

puts "-> Installing OrganizeGPT plugin with Ruby..."
puts ""
home_dir = Dir.home

install_keymaps(home_dir)
