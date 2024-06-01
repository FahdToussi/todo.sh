#!/bin/bash

# Define where tasks are stored.
TASK_FILE="tasks.txt"
CURRENT_ID=1  # Initialize the current ID to one

# Ensure the task file exists or create it if it doesn't.
if [ ! -f "$TASK_FILE" ]; then
    touch "$TASK_FILE"
fi

# Read the highest ID used so far from the task file to initialize the CURRENT_ID.
if [ -s "$TASK_FILE" ]; then
    CURRENT_ID=$(awk -F, '{print $1}' "$TASK_FILE" | sort -nr | head -n1)
    ((CURRENT_ID++))
fi

# Function to list tasks by a specific day without user input for the date.
display_today_tasks() {
    local today=$(date '+%Y-%m-%d')
    echo "Displaying tasks for today: $today"
    list_tasks_by_day "$today"
}

# Function to list tasks by a specific day.
list_tasks_by_day() {
    local day
    if [ -n "$1" ]; then
        day="$1"
    else
        echo "Enter the day to list tasks for (format YYYY-MM-DD):"
        read day
    fi

    if ! [[ $day =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] || ! date -d "$day" >/dev/null 2>&1; then
        echo "Invalid date format. Please use YYYY-MM-DD." >&2
        return
    fi

    echo "Tasks for $day:"
    local uncompleted=$(grep ",$day,no$" "$TASK_FILE")
    local completed=$(grep ",$day,yes$" "$TASK_FILE")

    if [ -z "$uncompleted" ]; then
        echo "Uncompleted Tasks: None"
    else
        echo "Uncompleted Tasks:"
        echo "$uncompleted" | while IFS=',' read -r id title description location due_date completion; do
            echo "ID: $id"
            echo "Title: $title"
            echo "Description: $description"
            echo "Location: $location"
            echo "Due Date: $due_date"
            echo "Completed: $completion"
            echo ""
        done
    fi

    if [ -z "$completed" ]; then
        echo "Completed Tasks: None"
    else
        echo "Completed Tasks:"
        echo "$completed" | while IFS=',' read -r id title description location due_date completion; do
            echo "ID: $id"
            echo "Title: $title"
            echo "Description: $description"
            echo "Location: $location"
            echo "Due Date: $due_date"
            echo "Completed: $completion"
            echo ""
        done
    fi
}

# Function to list all tasks.
list_tasks() {
    echo "Listing all tasks:"
    while IFS=',' read -r id title description location due_date completion; do
        echo "ID: $id"
        echo "Title: $title"
        echo "Description: $description"
        echo "Location: $location"
        echo "Due Date: $due_date"
        echo "Completed: $completion"
        echo ""
    done < "$TASK_FILE"
}

# Function to create a new task with input validation.
create_task() {
    local title description location due_date completion

    while true; do
        echo "Enter the task title (mandatory):"
        read title
        if [[ -z "$title" ]]; then
            echo "Title cannot be empty." >&2
        else
            break
        fi
    done

    echo "Enter the task description (optional):"
    read description

    echo "Enter the task location (optional):"
    read location

    while true; do
        echo "Enter the task due date (format YYYY-MM-DD, mandatory):"
        read due_date
        if [[ $due_date =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] && date -d "$due_date" >/dev/null 2>&1; then
            break
        else
            echo "Invalid date format. Please use YYYY-MM-DD." >&2
        fi
    done

    echo "Enter the completion marker (yes/no, optional):"
    read completion

    echo "$CURRENT_ID,$title,$description,$location,$due_date,$completion" >> "$TASK_FILE"
    echo "Task successfully created with ID: $CURRENT_ID"
    ((CURRENT_ID++))
}

# Function to update an existing task.
update_task() {
    list_tasks

    local task_id
    echo "Enter the ID of the task to update:"
    read task_id
    local task_details=$(grep "^$task_id," "$TASK_FILE")
    if [[ -z "$task_details" ]]; then
        echo "Invalid task ID." >&2
        return
    fi

    IFS=',' read -r id title description location due_date completion <<< "$task_details"

    echo "Current title: $title. Enter new title or leave blank to retain current value:"
    read new_title
    new_title=${new_title:-$title}

    echo "Current description: $description. Enter new description or leave blank:"
    read new_description
    new_description=${new_description:-$description}

    echo "Current location: $location. Enter new location or leave blank:"
    read new_location
    new_location=${new_location:-$location}

    while true; do
        echo "Current due date: $due_date. Enter new due date or leave blank to retain current value:"
        read new_due_date
        new_due_date=${new_due_date:-$due_date}
        if [[ -z "$new_due_date" ]] || ([[ $new_due_date =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] && date -d "$new_due_date" >/dev/null 2>&1); then
            break
        else
            echo "Invalid date format. Please use YYYY-MM-DD." >&2
        fi
    done

    echo "Current completion: $completion. Enter new completion marker or leave blank:"
    read new_completion
    new_completion=${new_completion:-$completion}

    sed -i "/^$task_id,/c\\$task_id,$new_title,$new_description,$new_location,$new_due_date,$new_completion" "$TASK_FILE"
    echo "Task successfully updated."
}

# Function to delete a task.
delete_task() {
    list_tasks

    local task_id
    echo "Enter the ID of the task to delete:"
    read task_id
    if ! grep -q "^$task_id," "$TASK_FILE"; then
        echo "Invalid task ID." >&2
        return
    fi

    sed -i "/^$task_id,/d" "$TASK_FILE"
    echo "Task successfully deleted."
}

# Function to show task details.
show_task() {
    local task_id
    echo "Enter the ID of the task to display:"
    read task_id
    local task_details=$(grep "^$task_id," "$TASK_FILE")
    if [[ -z "$task_details" ]]; then
        echo "Invalid task ID." >&2
        return
    fi

    IFS=',' read -r id title description location due_date completion <<< "$task_details"
    echo "Task ID: $id"
    echo "Title: $title"
    echo "Description: $description"
    echo "Location: $location"
    echo "Due Date: $due_date"
    echo "Completed: $completion"
}

# Function to search for a task by title.
search_by_title() {
    echo "Enter the exact title to search for:"
    read search_title
    if [ -z "$search_title" ]; then
        echo "Title cannot be empty." >&2
        return
    fi

    echo "Searching for tasks with title '$search_title':"
    grep -i ",$search_title," "$TASK_FILE" | while IFS=',' read -r id title description location due_date completion; do
        echo "Task ID: $id - Title: $title - Description: $description - Location: $location - Due Date: $due_date - Completed: $completion"
    done
}

# Help function to provide manual for using the script
help() {
    echo "Usage: $0 [command]"
    echo "Commands:"
    echo "  create            Create a new task"
    echo "  update            Update an existing task"
    echo "  delete            Delete an existing task"
    echo "  show              Show details of a task"
    echo "  list              List all tasks"
    echo "  list_by_day       List tasks by a specific day"
    echo "  search_by_title   Search for a task by title"
    echo "  help              Display this help text"
    echo ""
    echo "For example, to create a task, type: $0 create"
    echo "To display today's tasks, execute the script without arguments"
}

# Main program logic to process commands
if [[ -z "$1" ]]; then
    display_today_tasks
else
    case "$1" in
        create)
            create_task ;;
        update)
            update_task ;;
        delete)
            delete_task ;;
        show)
            show_task ;;
        list)
            list_tasks ;;
        list_by_day)
            list_tasks_by_day ;;
        search_by_title)
            search_by_title ;;
        help)
            help ;;
        *)
            echo "Unknown command: $1"
            echo "Type '$0 help' for usage."
            exit 1 ;;
    esac
fi

