#!/bin/bash

# Environment variables
dotenv='MONGO_URI=mongodb://localhost:27017/todo'

# JavaScript code snippets
indexJScode='const express = require("express");
const dotenv = require("dotenv");
require("dotenv").config({ path: "../.env" });
const cors = require("cors");
const connectDB = require("./config/db");
const taskRoutes = require("./routes/taskRoutes");

dotenv.config();
connectDB();

const app = express();
app.use(cors());
app.use(express.json());

app.use("/tasks", taskRoutes);

app.listen(5000, () => console.log("Server running on port 5000"));'

dbJScode='const mongoose = require("mongoose");

const connectDB = async () => {
    try {
        await mongoose.connect(process.env.MONGO_URI);
        console.log("MongoDB Connected");
    } catch (error) {
        console.error("MongoDB Connection Failed", error);
        process.exit(1);
    }
};

module.exports = connectDB;'

taskJScode='const mongoose = require("mongoose");

const taskSchema = new mongoose.Schema({
    title: { 
        type: String, 
        required: true 
    },
    completed: { 
        type: Boolean, 
        default: false 
    }
});

module.exports = mongoose.model("Task", taskSchema);'

routesJScode='const express = require("express");
const { getTasks, addTask, deleteTask } = require("../controllers/taskController");

const router = express.Router();

router.get("/", getTasks);
router.post("/", addTask);
router.delete("/:id", deleteTask);

module.exports = router;'

controllerJScode='const Task = require("../models/Task");

// Get all tasks
const getTasks = async (req, res) => {
    const tasks = await Task.find();
    res.json(tasks);
};

// Add a new task
const addTask = async (req, res) => {
    const { title } = req.body;
    if (!title) return res.status(400).json({ message: "Title is required" });

    const newTask = new Task({ title });
    await newTask.save();
    res.json(newTask);
};

// Delete a task
const deleteTask = async (req, res) => {
    await Task.findByIdAndDelete(req.params.id);
    res.json({ message: "Task deleted" });
};

module.exports = { getTasks, addTask, deleteTask };'

indexCSScode='*{
  padding: 0;
  margin: 0;
  box-sizing: border-box;
  font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Oxygen, Ubuntu, Cantarell, "Open Sans", "Helvetica Neue", sans-serif;
}'

appJSXcode='import TaskList from "./components/TaskList";

function App() {
  return (
    <div className="App">
      <TaskList />
    </div>
  );
}

export default App;'

componentsJSXcode='import { useState, useEffect } from "react";
import axios from "axios";

const TaskList = () => {
  const [tasks, setTasks] = useState([]);
  const [newTask, setNewTask] = useState("");

  useEffect(() => {
    fetchTasks();
  }, []);

  const fetchTasks = async () => {
    const res = await axios.get("http://localhost:5000/tasks");
    setTasks(res.data);
  };

  const addTask = async () => {
    if (!newTask) return;
    await axios.post("http://localhost:5000/tasks", { title: newTask });
    setNewTask("");
    fetchTasks();
  };

  const deleteTask = async (id) => {
    await axios.delete(`http://localhost:5000/tasks/${id}`);
    fetchTasks();
  };

  return (
    <div>
      <h1>To-Do List</h1>
      <input 
        type="text" 
        placeholder="New task..." 
        value={newTask} 
        onChange={(e) => setNewTask(e.target.value)} 
      />
      <button onClick={addTask}>Add</button>
      <ul>
        {tasks.map((task) => (
          <li key={task._id}>
            {task.title}
            <button onClick={() => deleteTask(task._id)}>❌</button>
          </li>
        ))}
      </ul>
    </div>
  );
};

export default TaskList;'

# Function to create backend
create_backend() {
    npm init -y
    npm install express cors dotenv mongoose
    echo "Installed node packages: express, cors, dotenv, and mongoose"

    echo "$indexJScode" > index.js

    mkdir config controllers models routes

    echo "$dbJScode" > config/db.js
    echo "$controllerJScode" > controllers/taskController.js
    echo "$taskJScode" > models/Task.js
    echo "$routesJScode" > routes/taskRoutes.js

    echo "Backend setup complete"
}

# Function to create frontend
create_frontend() {
    npm create vite@latest .
    npm install
    npm install axios

    cd public
    rm vite.svg
    cd ../

    cd src/
    cd assets 
    rm react.svg
    cd ../

    rm App.css App.jsx index.css
    mkdir components pages 

    echo "$componentsJSXcode" > components/TaskList.jsx
    echo "$indexCSScode" > index.css
    echo "$appJSXcode" > App.jsx

    echo "Frontend setup complete"
}

# Check for required dependencies
check_dependencies() {
    command -v npm >/dev/null 2>&1 || { echo >&2 "npm is required but it's not installed. Aborting."; exit 1; }
    command -v node >/dev/null 2>&1 || { echo >&2 "node is required but it's not installed. Aborting."; exit 1; }
    command -v git >/dev/null 2>&1 || { echo >&2 "git is required but it's not installed. Aborting."; exit 1; }
}

# Main script execution
main() {
    check_dependencies

    clear
    echo "=============================="
    echo "  Project Setup Script  "
    echo "=============================="

    # Ask for project type
    echo "Select the option from below:"
    echo "1. Fullstack"
    echo "2. Frontend"
    echo "3. Backend"
    read -p "(1, 2, 3): " type

    # Ask for project name
    read -p "Enter the project name: " project_name

    # Create project directory
    mkdir "$project_name"
    cd "$project_name" || exit

    if [[ -z "$type" || ! "$type" =~ ^[0-9]+$ ]]; then
      echo "Invalid selection, please enter a valid number (1, 2, or 3)"
      exit 1
    fi

    if [ "$type" -eq 1 ]; then 
        echo "$dotenv" > .env
        mkdir backend frontend
        cd backend
        create_backend
        cd ../
        
        cd frontend
        create_frontend
        cd ../
    elif [ "$type" -eq 2 ]; then
        create_frontend
        echo "$dotenv" > .env
    elif [ "$type" -eq 3 ]; then
        echo "$dotenv" > .env
        create_backend
    else
        echo "Invalid selection, please try again"
        exit 1
    fi

    touch README.md .gitignore 
    echo "Project setup completed successfully!"

    read -p "Initiate Git repo? (y/n): " ans

    if [[ "$ans" == y || "$ans" == Y ]]; then
      git init
    fi

    echo "Opening your project in VS Code..."
    command -v code >/dev/null 2>&1 && code . || echo "VS Code command 'code' not found. Please open the project manually."
}

main