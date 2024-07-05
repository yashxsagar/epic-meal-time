# cli-aqi App

🍽️ 🥗 🥑
A simple Bash + Node.js app to generate healthy snack recipes without leaving the terminal.

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Configuration](#configuration)
- [Contributing](#contributing)
- [License](#license)

## Introduction

- Do you live in the terminal?
- Do you often get hungry while coding but don't know what to cook?
- This app aka Bash + Node.js script generates 3 random but healthy snack recipes (Ingredients + Cooking Instructions) for you while ensuring the total calorie count for all dishes is below 1000 KCal.
- All you need is a simple run of the 'snacktime' command regardless of your woreking driectory (pwd)

## Features

- Fetches random healthy snack recipes from across the globe.
- Simple command-line interface requiring no setup of .env variables.
- Calculates total calories for all dishes.
- Logs the recipes and calorie counts with timestamps into a snacks.txt file.

## Prerequisites

- [Node.js](https://nodejs.org/) (v12.x or higher)
- npm (usually comes with Node.js)
- bash or zsh terminal

## Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/yashxsagar/epic-meal-time.git
   cd epic-meal-time
   ```

2. Make the setup.sh script executable:

   ```bash
   chmod +x setup.sh
   ```

3. Run the setup script:

   ```bash
   sudo ./setup.sh
   ```

   The setup script will:

   - Create and configure the necessary Node.js and Bash scripts.
   - Check for and install Node.js and `node-fetch` dependency if not already installed in the project's local repo folder.

## Usage

[Configuration](#configuration)

### Generate Snack Recipes

Run the following command to generate 3 random healthy snack recipes with their total calories:

```bash
snacktime
```

## Configuration

No configuration or envirnoment files needed

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
