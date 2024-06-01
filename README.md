# Task Management Script

This project is a simple task manager that performs CRUD (Create, Read, Update, Delete) operations on tasks. The tasks are stored in a text file (`tasks.txt`) and manipulated using a Bash script.

## Design Choices

### Data Storage
Tasks are stored in a plain text file called `tasks.txt`. Each task is represented as a single line in the following format:
(id,title,description,location,due date,completion)
- **id**: Unique identifier for each task.
- **title**: Title of the task.
- **description**: Description of the task.
- **location**: Location of the task.
- **due_date**: Due date for the task (format YYYY-MM-DD).
- **completion**: Status of the task (yes for completed, no for not completed).

### Code Organization
The project is organized into a single script that handles all task management functionalities. The script includes the following functions:
- **display_today_tasks**: Lists tasks for today without requiring user input for the date.
- **list_tasks_by_day**: Lists tasks for a specific day.
- **list_tasks**: Lists all tasks.
- **create_task**: Creates a new task with input validation.
- **update_task**: Updates an existing task by its ID.
- **delete_task**: Deletes a task by its ID.
- **show_task**: Shows details of a specific task by its ID.
- **search_by_title**: Searches for tasks by their title.
- **help**: Displays usage information.

## Usage

### Adding a Task
To add a new task, run the script with the `create` command and follow the prompts:

./script.sh create
### Updating a Task
To update an existing task, run the script with the update command and follow the prompts:
./script.sh update
### Deleting a Task
To delete a task by its ID, run the script with the delete command and follow the prompts:
./script.sh delete
### Showing Task Details
To show details of a specific task by its ID, run the script with the show command:
### Listing All Tasks
To list all tasks, run the script with the list command:
./script.sh list
### Listing Tasks by Day
To list tasks for a specific day, run the script with the list_by_day command and follow the prompts, or provide the date directly:
./script.sh list_by_day
./script.sh list_by_day YYYY-MM-DD
### Searching for a Task by Title
To search for a task by its title, run the script with the search_by_title command and follow the prompts:
./script.sh search_by_title
### Displaying Help
To display usage information, run the script with the help command:
./script.sh help
### Displaying Today's Tasks
To display tasks due today, simply run the script without any arguments:
./script.sh
### Notes
The script initializes the current task ID by reading the highest existing ID from the tasks.txt file and increments it for new tasks.
Date input is validated to ensure correct format and valid dates.
Tasks are stored in a text file, making it easy to back up and transfer.
### Example
Here is an example of creating a task:

Run ./script.sh create
Follow the prompts to enter the task details.
The task will be saved in tasks.txt with a unique ID.
### Requirements
Bash (Unix-based system)
This script provides a simple yet effective way to manage tasks from the command line, suitable for personal use or small projects.


