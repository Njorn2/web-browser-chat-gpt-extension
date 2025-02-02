const tasks = ".zed-plugins/jsons-data/tasks.json";
const keymap = ".zed-plugins/jsons-data/keymap.json";

async function readFile(filePath) {
  if (typeof Deno !== "undefined") {
    return await Deno.readTextFile(filePath);
  } else if (typeof require !== "undefined") {
    const fs = (await import("fs")).promises;
    return await fs.readFile(filePath, "utf8");
  }
  throw new Error("Unsupported runtime");
}

async function writeFile(filePath, content) {
  if (typeof Deno !== "undefined") {
    await Deno.writeTextFile(filePath, content);
  } else if (typeof require !== "undefined") {
    const fs = (await import("fs")).promises;
    await fs.writeFile(filePath, content, "utf8");
  } else {
    throw new Error("Unsupported runtime");
  }
}

function updateTasks(tasks, newTasks) {
  const tasksMap = new Map(tasks.map((task) => [task.label, task]));
  newTasks.forEach((task) => {
    tasksMap.has(task.label)
      ? Object.assign(tasksMap.get(task.label), task)
      : tasksMap.set(task.label, task);
  });
  return Array.from(tasksMap.values());
}

function updateKeymaps(keymaps, newKeymaps) {
  const keymapMap = new Map(keymaps.map((k) => [k.context, k]));
  newKeymaps.forEach((newKm) => {
    const existing = keymapMap.get(newKm.context);
    if (existing) {
      existing.bindings = { ...existing.bindings, ...newKm.bindings };
    } else {
      keymapMap.set(newKm.context, newKm);
    }
  });
  return Array.from(keymapMap.values());
}

function removeJsonComments(jsonString) {
  return jsonString.replace(/\/\/.*$/gm, "").replace(/\/\*[\s\S]*?\*\//g, "");
}

async function installTasks(homeDir) {
  const tasksJsonPath = `${homeDir}/.config/zed/tasks.json`;
  const newTasksPath = tasks;

  try {
    const [existing, newTasks] = await Promise.all([
      readFile(tasksJsonPath).then(removeJsonComments).then(JSON.parse),
      readFile(newTasksPath).then(JSON.parse),
    ]);
    await writeFile(
      tasksJsonPath,
      JSON.stringify(updateTasks(existing, newTasks), null, 2),
    );
    console.log("✓ Tasks installed successfully");
  } catch (error) {
    console.error("Error installing tasks:", error);
  }
}

async function installKeymaps(homeDir) {
  const keymapJsonPath = `${homeDir}/.config/zed/keymap.json`;
  const newKeymapsPath = keymap;

  try {
    const [existing, newKeymaps] = await Promise.all([
      readFile(keymapJsonPath).then(removeJsonComments).then(JSON.parse),
      readFile(newKeymapsPath).then(JSON.parse),
    ]);
    await writeFile(
      keymapJsonPath,
      JSON.stringify(updateKeymaps(existing, newKeymaps), null, 2),
    );
    console.log("✓ Keymaps installed successfully");
  } catch (error) {
    console.error("Error installing keymaps:", error);
  }
}

function detectOS() {
  // 1. Deno detection
  if (typeof Deno !== "undefined") {
    return Deno.build.os === "darwin" ? "macos" : "linux";
  }

  // 2. Node.js detection
  if (typeof process !== "undefined") {
    const { platform } = require("os");
    return platform() === "darwin" ? "macos" : "linux";
  }

  // 3. Browser detection
  if (typeof navigator !== "undefined") {
    const platform = navigator.platform.toLowerCase();
    if (platform.includes("mac") || platform.includes("iphone")) return "macos";
    if (platform.includes("linux")) return "linux";
  }

  return "unknown";
}

(async () => {
  console.log("-> Installing OrganizeGPT plugin JS...");
  const homeDir =
    typeof Deno !== "undefined"
      ? Deno.env.get("HOME") || Deno.env.get("USERPROFILE")
      : (await import("os")).homedir();

  await Promise.all([installTasks(homeDir), installKeymaps(homeDir)]);
})();
