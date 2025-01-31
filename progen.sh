dotenv='MONGO_URI=mongodb://localhost:27017/todo'

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

# backend
createBackend(){
    npm init -y
    npm install express cors dotenv mongoose
    echo "installed node packages : express, cors, dotenv and mongoose"

    echo "$indexJScode" > index.js

    mkdir config controllers models routes middleware

    cd config
    echo "$dbJScode" > db.js
    cd ../

    cd controllers
    echo "$controllerJScode" > taskController.js
    cd ../

    cd models
    echo "$taskJScode" > Task.js
    cd ../

    cd routes
    echo "$routesJScode" > taskRoutes.js
    cd ../

    node index.js
}

createFrontend(){
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


    cd components
    echo "$componentsJSXcode" > TaskList.jsx
    cd ../
    echo "$indexCSScode" > index.css
    echo "$appJSXcode" > App.jsx

    npm run dev
}


# Clear screen and display title
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

if [ "$type" -eq 1 ]; then 
    echo "$dotenv" > .env
    mkdir backend frontend
    cd backend
    createBackend
    cd ../
    
    cd frontend
    createFrontend
elif [ "$type" -eq 2 ]; then
    createFrontend
    echo "$dotenv" > .env
    cd ../
    
elif [ "$type" -eq 3 ]; then
    echo "$dotenv" > .env
    createBackend
else
    echo "Invalid selection, please try again"
fi

touch README.md .gitignore 
echo "Project setup completed successfully!"

