require 'json'
require 'fileutils'

TASKS_PATH = ".zed-plugins/jsons-data/tasks.json"
KEYMAP_PATH = ".zed-plugins/jsons-data/keymap.json"

def read_file(file_path)
  File.read(file_path)
end

def write_file(file_path, content)
  FileUtils.mkdir_p(File.dirname(file_path))
  File.write(file_path, content)
end

def update_tasks(existing_tasks, new_tasks)
  tasks_map = existing_tasks.each_with_object({}) { |task, h| h[task['label']] = task }
  new_tasks.each do |task|
    if tasks_map.key?(task['label'])
      tasks_map[task['label']].merge!(task)
    else
      tasks_map[task['label']] = task
    end
  end
  tasks_map.values
end

def update_keymaps(existing_keymaps, new_keymaps)
  keymap_map = existing_keymaps.each_with_object({}) { |km, h| h[km['context']] = km }
  new_keymaps.each do |new_km|
    context = new_km['context']
    if keymap_map.key?(context)
      keymap_map[context]['bindings'] = keymap_map[context]['bindings'].merge(new_km['bindings'])
    else
      keymap_map[context] = new_km
    end
  end
  keymap_map.values
end

def remove_json_comments(json_string)
  json_string.gsub(/\/\/.*$/, '')
             .gsub(/\/\*.*?\*\//m, '')
end

def install_tasks(home_dir)
  tasks_json_path = File.join(home_dir, '.config/zed/tasks.json')
  new_tasks_path = TASKS_PATH

  begin
    existing = JSON.parse(remove_json_comments(File.read(tasks_json_path)))
    new_tasks = JSON.parse(File.read(new_tasks_path))
    merged = update_tasks(existing, new_tasks)
    write_file(tasks_json_path, JSON.pretty_generate(merged))
    puts "✓ Tasks installed successfully"
  rescue => e
    puts "Error installing tasks: #{e}"
  end
end

def install_keymaps(home_dir)
  keymap_json_path = File.join(home_dir, '.config/zed/keymap.json')
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

install_tasks(home_dir)
install_keymaps(home_dir)
