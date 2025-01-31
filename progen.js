#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const exec = require('child_process').exec;
const readline = require('readline');

// Constants for your predefined code
const dotenv = 'MONGO_URI=mongodb://localhost:27017/todo';

const indexJScode = `
const express = require("express");
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

app.listen(5000, () => console.log("Server running on port 5000"));
`;

const dbJScode = `
const mongoose = require("mongoose");

const connectDB = async () => {
    try {
        await mongoose.connect(process.env.MONGO_URI);
        console.log("MongoDB Connected");
    } catch (error) {
        console.error("MongoDB Connection Failed", error);
        process.exit(1);
    }
};

module.exports = connectDB;
`;

const taskJScode = `
const mongoose = require("mongoose");

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

module.exports = mongoose.model("Task", taskSchema);
`;

const routesJScode = `
const express = require("express");
const { getTasks, addTask, deleteTask } = require("../controllers/taskController");

const router = express.Router();

router.get("/", getTasks);
router.post("/", addTask);
router.delete("/:id", deleteTask);

module.exports = router;
`;

const controllerJScode = `
const Task = require("../models/Task");

const getTasks = async (req, res) => {
    const tasks = await Task.find();
    res.json(tasks);
};

const addTask = async (req, res) => {
    const { title } = req.body;
    if (!title) return res.status(400).json({ message: "Title is required" });

    const newTask = new Task({ title });
    await newTask.save();
    res.json(newTask);
};

const deleteTask = async (req, res) => {
    await Task.findByIdAndDelete(req.params.id);
    res.json({ message: "Task deleted" });
};

module.exports = { getTasks, addTask, deleteTask };
`;

const indexCSScode = `
*{
  padding: 0;
  margin: 0;
  box-sizing: border-box;
  font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Oxygen, Ubuntu, Cantarell, "Open Sans", "Helvetica Neue", sans-serif;
}
`;

const appJSXcode = `
import TaskList from "./components/TaskList";

function App() {
  return (
    <div className="App">
      <TaskList />
    </div>
  );
}

export default App;
`;

const componentsJSXcode = `
import { useState, useEffect } from "react";
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
    await axios.delete(\`http://localhost:5000/tasks/\${id}\`);
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

export default TaskList;
`;

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

// Create Backend Project
function createBackend() {
  exec('npm init -y', (error, stdout, stderr) => {
    if (error) {
      console.log(`Error initializing project: ${error}`);
      return;
    }

    exec('npm install express cors dotenv mongoose', (error, stdout, stderr) => {
      console.log('Installed node packages: express, cors, dotenv, and mongoose');
      createFilesAndDirectories('backend');
    });
  });
}

// Create Files and Directories for Backend
function createFilesAndDirectories(type) {
  if (type === 'backend') {
    fs.writeFileSync('index.js', indexJScode);
    fs.mkdirSync('config');
    fs.mkdirSync('controllers');
    fs.mkdirSync('models');
    fs.mkdirSync('routes');
    
    fs.writeFileSync('config/db.js', dbJScode);
    fs.writeFileSync('controllers/taskController.js', controllerJScode);
    fs.writeFileSync('models/Task.js', taskJScode);
    fs.writeFileSync('routes/taskRoutes.js', routesJScode);
  }
  console.log(`Backend setup complete for ${type}`);
}

// Create Frontend Project
function createFrontend() {
  exec('npm create vite@latest .', (error, stdout, stderr) => {
    if (error) {
      console.log(`Error creating frontend: ${error}`);
      return;
    }
    exec('npm install axios', (error, stdout, stderr) => {
      console.log('Installed axios');
      createFrontendFiles();
    });
  });
}

// Create Frontend Files
function createFrontendFiles() {
  fs.mkdirSync('src/components');
  fs.writeFileSync('src/components/TaskList.jsx', componentsJSXcode);
  fs.writeFileSync('src/App.jsx', appJSXcode);
  fs.writeFileSync('src/index.css', indexCSScode);
  console.log('Frontend setup complete');
}

// Clear Screen and Prompt User
function promptUser() {
  rl.question('Select the option from below:\n1. Fullstack\n2. Frontend\n3. Backend\n(1, 2, 3): ', (type) => {
    rl.question('Enter the project name: ', (projectName) => {
      fs.mkdirSync(projectName);
      process.chdir(projectName);

      if (type === '1') {
        createBackend();
        createFrontend();
      } else if (type === '2') {
        createFrontend();
      } else if (type === '3') {
        createBackend();
      } else {
        console.log('Invalid selection, please try again');
      }

      rl.close();
    });
  });
}

promptUser();

