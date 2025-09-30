#!/bin/bash

# Set the databases directory
DB_DIR="./databases"

# Create the databases directory if it doesn't exist
if [ ! -d "$DB_DIR" ]; then
    echo "Creating databases directory..."
    mkdir -p "$DB_DIR"
fi

while true; do
    clear
    echo "=========================="
    echo "     Database Manager"
    echo "=========================="
    echo "1) Create Database"
    echo "2) List Databases"
    echo "3) Connect To Database"
    echo "4) Drop Database"
    echo "5) Exit"
    echo "=========================="
    read -p "Enter your choice: " choice
    
    case $choice in
        1)
            read -p "Enter database name: " dbname
            if [ -d "$DB_DIR/$dbname" ]; then
                echo "Database '$dbname' already exists!"
            else
                mkdir "$DB_DIR/$dbname"
                echo "Database '$dbname' created."
            fi
            read -p "Press Enter to continue..."
            ;;
        2)
            echo "Available Databases:"
            if [ -d "$DB_DIR" ] && [ "$(ls -A $DB_DIR 2>/dev/null)" ]; then
                ls -1 "$DB_DIR"
            else
                echo "No databases found."
            fi
            read -p "Press Enter to continue..."
            ;;
        3)
            read -p "Enter database name to connect: " dbname
            if [ -d "$DB_DIR/$dbname" ]; then
                echo "Connecting to database '$dbname'..."
                echo "Debug: Checking for database_menu.sh..."
                
                # Check if database_menu.sh exists in current directory
                if [ -f "./database_menu.sh" ]; then
                    echo "Debug: Found database_menu.sh"
                    # Make it executable if it's not
                    chmod +x ./database_menu.sh
                    echo "Debug: Running: ./database_menu.sh $DB_DIR/$dbname"
                    ./database_menu.sh "$DB_DIR/$dbname"
                else
                    echo "Error: database_menu.sh not found in current directory!"
                    echo "Current directory: $(pwd)"
                    echo "Files in current directory:"
                    ls -la
                fi
            else
                echo "Database '$dbname' does not exist."
            fi
            read -p "Press Enter to continue..."
            ;;
        4)
            read -p "Enter database name to drop: " dbname
            if [ -d "$DB_DIR/$dbname" ]; then
                read -p "Are you sure you want to delete '$dbname'? Type 'yes' to confirm: " confirm
                if [ "$confirm" = "yes" ]; then
                    rm -rf "$DB_DIR/$dbname"
                    echo "Database '$dbname' deleted."
                else
                    echo "Canceled."
                fi
            else
                echo "Database '$dbname' does not exist."
            fi
            read -p "Press Enter to continue..."
            ;;
        5)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid choice."
            read -p "Press Enter to continue..."
            ;;
    esac
done