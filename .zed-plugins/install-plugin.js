async function readFile(filePath) {
  if (typeof Deno !== "undefined") {
    // Deno environment
    const decoder = new TextDecoder("utf-8");
    const data = await Deno.readFile(filePath);
    return decoder.decode(data);
  } else if (typeof require !== "undefined") {
    // Node.js environment
    const fs = require("fs").promises;
    return await fs.readFile(filePath, "utf8");
  } else {
    throw new Error("Unsupported runtime environment");
  }
}

async function writeFile(filePath, content) {
  if (typeof Deno !== "undefined") {
    // Deno environment
    const encoder = new TextEncoder();
    await Deno.writeFile(filePath, encoder.encode(content));
  } else if (typeof require !== "undefined") {
    // Node.js environment
    const fs = require("fs").promises;
    await fs.writeFile(filePath, content, "utf8");
  } else {
    throw new Error("Unsupported runtime environment");
  }
}

async function updateTasks(tasks, newTasks) {
  const tasksMap = new Map(tasks.map((task) => [task.label, task]));

  newTasks.forEach((task) => {
    if (tasksMap.has(task.label)) {
      Object.assign(tasksMap.get(task.label), task);
    } else {
      tasksMap.set(task.label, task);
    }
  });

  const updatedTasks = Array.from(tasksMap.values());

  return updatedTasks;
}

async function updateKeymaps(keymap, newKeymap) {
  const keymapMap = new Map(keymap.map((keymap) => [keymap.context, keymap]));

  newKeymap.forEach((keymap) => {
    if (keymapMap.has(keymap.context)) {
      Object.assign(keymapMap.get(keymap.context), keymap.bindings);
    } else {
      keymapMap.set(keymap.context, keymap);
    }
  });

  const updatedKeymaps = Array.from(keymapMap.values());

  return updatedKeymaps;
}
function removeJsonComments(jsonString) {
  return jsonString
    .replace(/\/\/.*$/gm, "") // Remove single-line comments
    .replace(/\/\*[\s\S]*?\*\//g, ""); // Remove multi-line comments
}

async function installTasks(homeDir) {
  const tasksJsonFile = `${homeDir}/.config/zed/tasks.json`;
  const newTasksJsonFile = ".zed-plugins/tasks.json";

  const tasksJsonString = await readFile(tasksJsonFile);
  const newTasksJsonString = await readFile(newTasksJsonFile);
  let tasksArrayObj = JSON.parse(removeJsonComments(tasksJsonString));
  let newTasksArrayObj = JSON.parse(newTasksJsonString);
  const tasks = updateTasks(tasksArrayObj, newTasksArrayObj);

  tasks
    .then(async (result) => {
      await writeFile(tasksJsonFile, JSON.stringify(result, null, 2));
      console.log(
        " ✓ OrganizeGPT Project Plugin Tasks Installed successfully.",
      );
    })
    .catch((error) => {
      console.log("-> Error on Installing OrganizeGPT Zed Plugin:", error);
    });
}

async function installKeymaps(homeDir) {
  const keymapJsonFile = `${homeDir}/.config/zed/keymap.json`;
  const newKeymapJsonFile = ".zed-plugins/keymap.json";

  const keymapJsonString = await readFile(keymapJsonFile);
  const newKeymapJsonString = await readFile(newKeymapJsonFile);
  let keymapArrayObj = JSON.parse(removeJsonComments(keymapJsonString));
  let newKeymapArrayObj = JSON.parse(newKeymapJsonString);
  const keymap = updateTasks(keymapArrayObj, newKeymapArrayObj);

  keymap
    .then(async (result) => {
      await writeFile(keymapJsonFile, JSON.stringify(result, null, 2));
      console.log(
        " ✓ OrganizeGPT Project Plugin Shortcuts Installed successfully.",
      );
    })
    .catch((error) => {
      console.log("-> Error on Installing OrganizeGPT Zed Plugin:", error);
    });
}

// Example usage
(async () => {
  console.log("-> Installing OrganizeGPT plugin to Zed...");
  const homeDir =
    typeof Deno !== "undefined"
      ? Deno.env.get("HOME") || Deno.env.get("USERPROFILE") // Deno
      : require("os").homedir();

  installTasks(homeDir);
  installKeymaps(homeDir);
})();
