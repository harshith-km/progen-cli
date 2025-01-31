# progen - Project Generator

progen is a simple and lightweight Bash script that automates the setup of Fullstack, Frontend, or Backend projects. It creates the necessary directories and files for a quick development start, including backend (Node.js/Express/MongoDB) and frontend (React/Vite) configurations.


## Features
- Interactive CLI for selecting project type (Fullstack, Frontend, Backend)
- Automatically sets up directory structure and environment variables
- Initializes a Node.js backend with Express, MongoDB, and Mongoose
- Creates a React frontend using Vite and installs necessary dependencies
- Works in Linux, macOS, and WSL (Windows Subsystem for Linux)
- No external dependencies required beyond Node.js and npm


## Installation
Clone the Repository
`git clone https://github.com/your-username/progen.git`
`cd progen`

## Make the Script Executable
`chmod +x progen.sh`

## Usage
Run the script and follow the prompts:
`./progen.sh`


## Project Types
1. Fullstack: Creates backend (Node.js + Express + MongoDB) and frontend (React + Vite) directories.
2. Frontend: Sets up a React project using Vite.
3. Backend: Sets up an Express/MongoDB backend.


## Example

`./progen.sh`

Output:


## Project Structure
After running the script, the generated structure will look like this:
```
my-app/ 
├── backend/
│   ├── config/
│   │   └── db.js
│   ├── controllers/
│   │   └── taskController.js
│   ├── models/
│   │   └── Task.js
│   ├── routes/
│   │   └── taskRoutes.js
│   ├── index.js
│   └── .env
├── frontend/
│   ├── src/
│   │   ├── components/
│   │   │   └── TaskList.jsx
│   │   ├── index.css
│   │   └── App.jsx
│   ├── public/
│   ├── package.json
│   └── vite.config.js
├── README.md
├── .gitignore
└── progen.sh
```

## Dependencies Installed

>Backend:
- Express
- Cors
- Dotenv
- Mongoose

>Frontend:
- React (via Vite)
- Axios
- Contributing

Feel free to contribute by submitting issues or pull requests.
License
This project is licensed under the MIT License.