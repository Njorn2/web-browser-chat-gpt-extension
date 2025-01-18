(function () {
  const originalFetch = window.fetch;

  window.fetch = async function (...args) {
    console.log("Intercepted fetch call to:", args[0]); // Log the URL
    const response = await originalFetch(...args);

    if (args[0].includes("/backend-api/conversations")) {
      console.log("API call intercepted:", args[0]); // Log if the URL matches
    }
    return response;
  };
})();
