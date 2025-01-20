<a id="readme-top"></a>

[![Version][version-shield]][version-url]
[![License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]

[![Chrome][chrome-shield]][chrome-url]
[![Firefox][firefox-shield]][firefox-url]
[![Opera][opera-shield]][opera-url]

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a>
    <img src="source/images/icon_chat128.png" alt="Logo" width="80" height="88">
  </a>

  <h3 align="center">OrganizeGPT</h3>

  <p align="center">
      A ChatGPT Conversation organizer to easily your life
  </p>
</div>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Menu Guide</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
    </li>
    <li>
      <a href="#features">Features</a>
    </li>
    <li><a href="#installation">Installation</a>
        <ul>
            <li>
              <a href="#installing-on-chrome">Installating on Chrome</a>
            </li>
            <li>
                <a href="#installing-on-firefox">Installating on Firefox</a>
            </li>
            <li>
                <a href="#installing-on-opera">Installating on Opera</a>
            </li>
        </ul>
    </li>
    <li><a href="#usagge">Usage</a></li>
    <li><a href="#permissions-justification">Permissions Justification</a></li>
    <li><a href="#development">Development</a></li>
    <li><a href="#prerequisites">Prerequisites</a></li>
    <li><a href="#build">Build</a></li>
    <li><a href="#supporting-new-browser">Supporting New Browser</a></li>
    <li>
        <a href="#keep-in-mind">Keep in Mind</a>
        <ul>
            <li>
              <a href="#chrome">Chrome</a>
            </li>
            <li>
                <a href="#firefox">Firefox</a>
            </li>
            <li>
                <a href="#opera">Opera</a>
            </li>
            <li>
                <a href="#new-browser">New Browser</a>
            </li>
        </ul>
    </li>
    <li><a href="#testing">Testing</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>

<!-- ABOUT THE PROJECT -->
## About The Project

[![OrganizeGPT Screen Shot][product-screenshot]](https://github.com/Njorn2/web-browser-chat-gpt-extension/)

Effortlessly organize and search your ChatGPT conversations by year and month with this Chrome extension. Save time and easily revisit past discussions.

## Features

- **Automatic Organization**: Lists and sorts your ChatGPT conversations by year and month.
- **Enhanced Search**: Quickly find conversations from a specific time period.
- **User-Friendly Interface**: Simple and intuitive design for seamless use.
- **Privacy-Focused**: Processes data locally, ensuring your information stays secure.

## Installation

1. Clone this repository or [download the ZIP file](https://github.com/Njorn2/web-browser-chat-gpt-extension/).
2. Extract the files if downloaded as a ZIP.
3. Open Terminal.
4. Run the command below.
  ```bash
   sh config-targets.sh
  ```
5. Follow the steps below to each browser.

### Installing on Chrome.
1. And run the another command below specific browser.
```bash
sh start.sh chrome
# or
sh start-chrome.sh
```
2. Open Chrome and navigate to `chrome://extensions/`.
3. Enable **Developer Mode** in the top-right corner.
4. Click **Load Unpacked** and select the folder target containing this extension. Ex: `/path/to/organizegpt/targets/chrome`
5. The extension will be added to your browser and ready to use!

### Installing on Firefox.
1. And run the another command below specific browser.
```bash
sh start.sh firefox
# or
sh start-firefox.sh
```
2. Open Firefox and navigate to `about:debugging#/runtime/this-firefox`.
3. Click **Load Temporary Add-on…** and select the folder target containing this extension. Ex: `/path/to/organizegpt/targets/firefox`
4. Select the manifest.json.
5. The extension will be added to your browser and ready to use!

### Installing on Opera.
1. And run the another command below specific browser.
```bash
sh start.sh opera
# or
sh start-opera.sh
```
2. Open Opera and navigate to `chrome://extensions/`.
3. Enable **Developer Mode** in the top-right corner.
4. Click **Load Unpacked** and select the folder target containing this extension. Ex: `/path/to/organizegpt/opera`
5. The extension will be added to your browser and ready to use!

## Usage

1. Open ChatGPT and navigate to your conversations.
2. The extension will categorize your conversations by year and month.
3. The extension updates recorded conversations as the ChatGPT conversation menu is updated. Scroll all the way to the bottom of the menu and ChatGPT will bring up the oldest conversations.
4. Use the extension popup to quickly search and filter your conversations.

## Permissions Justification

To ensure transparency, here’s why each permission is required:

- **activeTab and tabs**: Access the current tab and URL to identify ChatGPT pages and load conversations.
- **cookies**: Retrieve session information to fetch data from your ChatGPT history.
- **storage**: Save user preferences and settings for a personalized experience.
- **webRequest**: Monitor and process network requests to retrieve conversation data.
- **Host Permissions**: Access ChatGPT’s domain to organize and display conversations.

## Development

### Prerequisites

- **JavaScript** (for development feature scripts).
- **HTML** (for make the UI Popup).
- **CSS** (for style Extension UI).
- **Shell Script** (for automate configs and builds).
- **A code editor, such as VS Code, Zed, Sublime or NOVA.**

### Build

To modify or extend the extension:

1. Clone the repository:
   ```bash
   git clone https://github.com/Njorn2/web-browser-chat-gpt-extension/
   cd your-repo-folder
   ```
2. Make your changes source folder.
3. Use the following command to generate/update targets folder to test on Browser.

3.1. **Chrome**
  ```bash
  sh start-chrome.sh
  # or
  sh start.sh chrome
  ```
3.2. **Firefox**
  ```bash
  sh start-firefox.sh
  # or
  sh start.sh firefox
  ```
  3.2. **Opera**
  ```bash
  sh start-opera.sh
  # or
  sh start.sh opera
  ```
4. Change Version on file VERSION.
5. Use the following command to build and minify JavaScript files:
  ```bash
  sh build.sh
  ```

### Supporting new Browser

To add a new extension compatibility for a new browser:

1. Add the new browser name on file BROWSERS.

1.1. Current Supports
```bash
chrome
firefox
opera
  ```
1.2. Added new browser example.
```bash
chrome
firefox
opera
Edge
  ```
2. Create the folder config on folder **"source"** with the new browser name.
3. Add the files **"manifest.json"** and **"background.json"** to the new browser folder.
4. Run command below to generate target from new browser.
```bash
sh config-start.sh
```
5. Make config necessary adjusts on config files **"manifest.json"** and **"background.json"** from source/<new-browser>

### Keep in Mind

Each browser has its own configuration quirks and background services. So when editing, fixing, or creating support for a new browser, you need to have your own custom **manifest.json** and **background.js**

All changes, new features or fixes on **"popup.html"** and **"popup.js"**, needs be on files from folder **"source"**.
After changes, run command below to update targets folders to test on browsers.

#### **chrome**
```bash
sh start-chrome.sh
# or
sh start.sh chrome
```
#### **firefox**
```bash
sh start-firefox.sh
# or
sh start.sh firefox
```
#### **opera**
```bash
sh start-opera.sh
# or
sh start.sh opera
```
#### **new browser**
```bash
sh start-new-browser.sh
# or
sh start.sh new-browser
```

### Testing

Load the extension into your Browser as described in the **Installation** section to test your changes.

## Contributing

Contributions are welcome! If you’d like to improve the extension or add features:
1. Fork this repository.
2. Create a new branch:
   ```bash
   git checkout -b feature-name
   ```
3. Commit your changes:
   ```bash
   git commit -m "Add new feature <feature_name>"
   ```
4. Push to the branch:
   ```bash
   git push origin feature-name
   ```
5. Open a pull request.

## License

This project is licensed under the [MIT License](LICENSE).

## Acknowledgments

- Built with passion for the ChatGPT community.
- Thanks to all contributors for their support!

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[version-shield]: https://img.shields.io/badge/version-1.0.0-darkred
[version-url]: https://github.com/Njorn2/web-browser-chat-gpt-extension/releases/tag/1.0.0
[forks-shield]: https://img.shields.io/badge/forks-0-blue
[forks-url]: https://github.com/Njorn2/web-browser-chat-gpt-extension/forks
[stars-shield]: https://img.shields.io/badge/stars-0-blue
[stars-url]: https://github.com/Njorn2/web-browser-chat-gpt-extension/stargazers
[issues-shield]: https://img.shields.io/badge/issues-0-red
[issues-url]: https://github.com/Njorn2/web-browser-chat-gpt-extension/issues
[license-shield]: https://img.shields.io/badge/license-MIT-green
[license-url]: LICENSE
[linkedin-shield]: https://img.shields.io/badge/linked-in-blue
[linkedin-url]: https://www.linkedin.com/in/ruan-gustavo-oliveira/
[product-screenshot]: source/images/screen_shot_publish.png

[chrome-shield]: https://img.shields.io/badge/chrome-1.0.0-blue
[chrome-url]: https://chromewebstore.google.com/detail/organizegpt/joopoghilonoiigjmhdcfmcihjjkkimb?hl=pt-br
[firefox-shield]: https://img.shields.io/badge/firefox-1.0.0-orange
[firefox-url]: https://addons.mozilla.org/pt-BR/firefox/addon/organizegpt/
[opera-shield]: https://img.shields.io/badge/opera-1.0.0-red
[opera-url]: https://addons.opera.com/en/extensions/details/organizegpt/
