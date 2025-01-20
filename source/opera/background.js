let authToken = "";

chrome.webRequest.onBeforeSendHeaders.addListener(
  (details) => {
    const headers = details.requestHeaders;
    const authHeader = headers.find(
      (header) => header.name.toLowerCase() === "authorization",
    );
    if (authHeader) {
      authToken = authHeader.value; // Save the token dynamically
    }
  },
  { urls: ["https://chatgpt.com/backend-api/conversations*"] },
  ["requestHeaders"],
);

chrome.webRequest.onCompleted.addListener(
  async (details) => {
    try {
      // Skip extension-initiated requests
      if (details.initiator && details.initiator.includes("chrome-extension")) {
        return;
      }
      if (!authToken) {
        console.error("Authorization token not found.");
        return;
      }

      // Retrieve cookies for the domain
      const cookies = await new Promise((resolve, reject) =>
        chrome.cookies.getAll({ domain: "chatgpt.com" }, (cookieList) => {
          if (chrome.runtime.lastError) {
            reject(chrome.runtime.lastError);
          } else {
            resolve(cookieList);
          }
        }),
      );

      if (!cookies || cookies.length === 0) {
        console.warn("No cookies found for chatgpt.com");
        return;
      }

      // Build the cookie string
      const cookieString = cookies
        .map((c) => `${c.name}=${c.value}`)
        .join("; ");

      // Fetch data from the API with cookies and the auth token
      console.log("URL:", details.url);
      const response = await fetch(details.url, {
        method: "GET",
        headers: {
          "Content-Type": "application/json",
          Authorization: authToken,
          Cookie: cookieString,
        },
      });

      const data = await response.json();
      if (data.items && data.items.length > 0) {
        chrome.storage.local.get("conversations", (result) => {
          const existingConversations = result.conversations || [];

          // Merge and deduplicate items
          const allConversations = [...existingConversations, ...data.items];
          const uniqueConversations = Array.from(
            new Map(
              allConversations.map((item) => [getChatID(item), item]),
            ).values(),
          );

          // Sort conversations by date
          uniqueConversations.sort(
            (a, b) => new Date(b.created_time) - new Date(a.created_time),
          );

          console.log("Body:", uniqueConversations);
          // Save unique conversations to storage
          chrome.storage.local.set({ conversations: uniqueConversations });
        });
      } else {
        console.log("No conversations returned:", data);
      }
    } catch (error) {
      console.error("Error intercepting and fetching conversations:", error);
    }
  },
  {
    urls: [
      "https://chat.openai.com/backend-api/conversations*",
      "https://chatgpt.com/backend-api/conversations*",
    ],
  },
  ["responseHeaders"],
);

function getChatID(conv) {
  const id = conv.id == null ? conv.conversation_id : conv.id;
  return id;
}
