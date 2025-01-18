const version = "1.0.0";
const years = new Object();
const log = console.log;
var aux = new Object();

/**
 * Renders the Conversations List.
 * @param {Array<Object>} conversations
 */
function renderConversations() {
  const list = document.getElementById("conversations-list");
  list.innerHTML = ""; // Clear the list

  /// Iterate through the Years.
  createYearsList(list);

  /// Add click event to list items.
  addClickListeners(".collapsible");
}

function createYearsList(list) {
  Object.keys(aux).forEach((year) => {
    const li = createElement("li");
    const yearDiv = createElement("h2", ["collapsible", "dark"]);
    yearDiv.textContent = year !== "1970" ? year : "No Date";
    li.appendChild(yearDiv);
    const monthsUl = createElement("ul", ["nested"]);

    /// Interatee the Months from the Year.
    createMonthsList(year, monthsUl);

    li.appendChild(monthsUl);
    list.appendChild(li);
  });
}

/**
 * Create the Month List inside the Year.
 * @param {String} year
 * @param {HTMLElement} ul
 */
function createMonthsList(year, ul) {
  Object.keys(aux[year]).forEach((month) => {
    const monthLi = createElement("li");
    const monthDiv = createElement("h3", ["collapsible", "white"]);
    monthDiv.textContent = month;
    monthLi.appendChild(monthDiv);
    const daysUl = createElement("ul", ["nested"]);

    /// Interate the Days from the Month.
    createConversationsList(year, month, daysUl);

    monthLi.appendChild(daysUl);
    ul.appendChild(monthLi);
  });
}

/**
 * Create the Daily Conversation List.
 * @param {String} year - Year of conversation.
 * @param {String} month - Month of conversation.
 * @param {HTMLElement} ul - List.
 */
function createConversationsList(year, month, ul) {
  aux[year][month].forEach((conv) => {
    const chatId = getChatID(conv);
    const dayLi = createElement("li", ["list-item"], {
      "chat-id": chatId,
    });
    dayLi.addEventListener("click", () => {
      openChat(dayLi.getAttribute("chat-id"));
    });

    dayLi.textContent = ` - ${conv.title || "Untitled"}`;
    ul.appendChild(dayLi);
  });
}

/**
 * Open Chat from ChatGPT
 * If you already on ChatGPT Site, it just will redirect to the conversation.
 * @param {String} id - Id from chat.
 */
function openChat(id) {
  chrome.tabs.query({ active: true, lastFocusedWindow: true }, (tabs) => {
    let url = tabs[0].url;
    let chatUrl = "https://chatgpt.com/c/".concat(id);
    if (
      url.includes("https://chat.openai.com") ||
      url.includes("https://chatgpt.com")
    ) {
      chrome.tabs.update(tabs[0].id, { url: chatUrl });
    } else {
      chrome.tabs.create({ url: chatUrl });
    }
  });
}

/**
 * Add Event Click on Element by QuerySelector.
 * @param {String} query - Query to find the elements do add Click Envent.
 */
function addClickListeners(query) {
  document.querySelectorAll(query).forEach((button) => {
    button.addEventListener("click", () => {
      button.classList.toggle("active");
      const nestedList = button.nextElementSibling;
      if (nestedList) {
        nestedList.style.display =
          nestedList.style.display === "block" ? "none" : "block";
      }
    });
  });
}

/**
 * Organize conversations by Year and Months.
 * @param {Array<Object>} conversations
 */
function organize(conversations) {
  getYears(conversations);

  conversations.forEach((conv) => {
    const year = getYear(conv);
    const month = getMonth(conv);
    if (years[year][month] == null) {
      years[year][month] = new Array();
    }
    years[year][month].push(conv);
  });
  sortMonths();
  aux = years;
}

function sortMonths() {
  const monthOrder = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  Object.keys(years).forEach((year) => {
    const months = years[year];
    const sortedMonths = new Object();
    monthOrder.forEach((month) => {
      if (months.hasOwnProperty(month)) {
        sortedMonths[month] = months[month];
      }
    });
    years[year] = sortedMonths;
  });
  console.log(years);
}

/**
 * Extract the year the conversation took place.
 * @param {Array<Object>} conversation
 * @returns
 */
function getYear(conversation) {
  if (conversation.create_time != null) {
    date = new Date(conversation.create_time);
  } else {
    date = new Date(conversation.update_time);
  }
  return date.getFullYear();
}

/**
 * Extracts all months where there were conversations in a given year.
 * @param {Array<Object>} conversation
 * @returns
 */
function getMonth(conversation) {
  if (conversation.create_time != null) {
    date = new Date(conversation.create_time);
  } else {
    date = new Date(conversation.update_time);
  }
  return date.toLocaleString("en-US", { month: "long" });
}

/**
 * Extracts all years where there were conversations.
 * @param {Array<Object>} conversation
 * @returns
 */
function getYears(conversations) {
  conversations.forEach((conv) => {
    let date;
    if (conv.create_time != null) {
      date = new Date(conv.create_time);
    } else {
      date = new Date(conv.update_time);
    }

    years[date.getFullYear()] = new Object();
  });
  return years;
}

/**
 * Create a HTML Element.
 * @param {String} tag - Element Name. Ex: div
 * @param {Array<String>} classes - CSS Classes to add to Element.
 * @param {Object<String, Any>} attribs - Attributes to add to Element. Ex: id = "teste"
 * @returns
 */
function createElement(tag, classes, attribs) {
  const element = document.createElement(tag);
  if (classes != null && classes.length > 0) {
    addClasses(element, classes);
  }
  if (attribs != null && Object.keys(attribs).length > 0) {
    addAttrib(element, attribs);
  }
  return element;
}

/**
 * Add Classes to Element.
 * @param {HTMLElement} element
 * @param {Array<String>} classes
 */
function addClasses(element, classes) {
  classes.forEach((classe) => {
    element.classList.add(classe);
  });
}

/**
 * Add Atributes to Element.
 * @param {HTMLElement} element
 * @param {Object<String, Any>} attribs
 */
function addAttrib(element, attribs) {
  Object.keys(attribs).forEach((key) => {
    element.setAttribute(key, attribs[key]);
  });
}

/**
 * Get String Date.
 * @param {String} date
 * @param {String} format - Formats "dd", "dd/MM", "dd/MM/yyyy"
 * @returns
 */
function getDate(date, format) {
  if (format != null && format === "dd") {
    const day = new Date(date).getDay();
    return day < 10 ? "0".concat(day) : day;
  }
  if (format != null && format === "dd/MM") {
    const day = new Date(date).getDay();
    const month = new Date(date).getMonth() + 1;
    return (
      (day < 10 ? "0".concat(day) : day) +
      "/" +
      (month < 10 ? "0".concat(month) : month)
    );
  }
  const options = { day: "2-digit", month: "2-digit", year: "numeric" };
  return new Date(date).toLocaleDateString("pt-BR", options);
}

/**
 * Extract the Conversation ID.
 * @param {Array<Object>} conversation
 * @returns {String} conversation_id || chat_id;
 */
function getChatID(conversation) {
  if (conversation.id != null && conversation.id.length > 0) {
    return conversation.id;
  }
  return conversation.conversation_id;
}

function search(input) {
  aux = new Object();
  const value = input.value;
  Object.keys(years).forEach((year) => {
    const months = years[year];
    Object.keys(months).forEach((month) => {
      const result = months[month].filter((conv) =>
        conv.title.toLowerCase().includes(value.toLowerCase()),
      );

      if (result != null && result.length > 0) {
        if (aux[year] == null) {
          aux[year] = new Object();
        }
        aux[year][month] = result;
      }
    });
  });
  if (Object.keys(aux).length <= 0) {
    aux = years;
  }
  renderConversations();
}

function updatePage() {
  chrome.tabs.query({ active: true, lastFocusedWindow: true }, (tabs) => {
    let url = tabs[0].url;
    if (
      url.includes("https://chat.openai.com") ||
      url.includes("https://chatgpt.com")
    ) {
      chrome.tabs.update(tabs[0].id, { url: url });
    } else {
      chrome.tabs.create({ url: "https://chatgpt.com" });
    }
  });
}

function checkRecords() {
  if (Object.keys(years).length === 0) {
    log("Years:", Object.keys(years).length);
    const p = createElement("p");
    p.innerText = "No conversations records.";

    const btnUpdate = createElement("button", null, { id: "btn-update" });
    btnUpdate.innerText = "update list";
    btnUpdate.addEventListener("click", () => {
      updatePage();
    });
    const list = document.getElementById("conversations-list");
    list.innerHTML = "";
    list.appendChild(p);
    list.appendChild(btnUpdate);
  }
}

/**
 * Sort Conversations on Year > Month > Conversations and render list on popup.
 * @param {Array<Object>} conversations
 */
function run(conversations) {
  if (conversations.length === 0) {
    checkRecords();
    return;
  }
  organize(conversations);
  renderConversations();
}

/**
 * Start on page load done.
 */
document.addEventListener("DOMContentLoaded", () => {
  // Load initial conversations
  chrome.storage.local.get("conversations", (result) => {
    const conversations = result.conversations || [];
    run(conversations);
  });

  // Listen for storage changes and update the popup
  chrome.storage.onChanged.addListener(function (changes, namespace) {
    if (namespace === "local" && changes.conversations) {
      run(changes.conversations.newValue || []);
    }
  });

  const inputSearch = document.getElementById("input-search");
  inputSearch.addEventListener("input", function () {
    search(inputSearch);
  });
  document.getElementById("version").innerText = "v".concat(version);
});
