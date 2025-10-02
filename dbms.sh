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
    choice=$(zenity --list --title="Database Manager" --column="Option" \
    "Create Database" "List Databases" "Connect To Database" "Drop Database" "Exit")
    
    case $choice in
        "Create Database")
            dbname=$(zenity --entry --title="Create Database" --text="Enter database name:")
            if [ -z "$dbname" ]; then
                zenity --error --text="No name entered!"
            elif [ -d "$DB_DIR/$dbname" ]; then
                zenity --error --text="Database '$dbname' already exists!"
            else
                mkdir "$DB_DIR/$dbname"
                zenity --info --text="Database '$dbname' created successfully."
            fi
            ;;
        "List Databases")
            echo "Available Databases:"
            if [ -d "$DB_DIR" ] && [ "$(ls -A $DB_DIR 2>/dev/null)" ]; then
                ls -1 "$DB_DIR" | zenity --text-info --title="Available Databases" --width=300 --height=200
            else
                zenity --warning --text="No databases found."
            fi
            ;;
        "Connect To Database")
            dbname=$(zenity --entry --title="Connect to Database" --text="Enter database name:")
            if [ -d "$DB_DIR/$dbname" ]; then
                ./database_menu.sh "$DB_DIR/$dbname"
            else
                zenity --error --text="Database '$dbname' does not exist."
            fi
            ;;
        "Drop Database")
            dbname=$(zenity --entry --title="Drop Database" --text="Enter database name:")
            if [ -d "$DB_DIR/$dbname" ]; then
                if zenity --question --text="Are you sure you want to delete '$dbname'?"; then
                    rm -rf "$DB_DIR/$dbname"
                    zenity --info --text="Database '$dbname' deleted."
                fi
            else
                zenity --error --text="Database '$dbname' does not exist."
            fi
            ;;
        "Exit")
            exit 0
            ;;
    esac
done