#!/bin/bash

DB_DIR="./databases"

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
            read -p "Press Enter to continue."
            ;;
        2)
            echo "Available Databases:"
            if [ "$(ls -A $DB_DIR)" ]; then
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
                ./database_menu.sh "$DB_DIR/$dbname"
            else
                echo "Database '$dbname' does not exist."
                read -p "Press Enter to continue..."
            fi
            ;;
        4)
            read -p "Enter database name to drop: " dbname
            if [ -d "$DB_DIR/$dbname" ]; then
                read -p "Are you sure you want to delete '$dbname'? Type 'yes' to confirm: " confirm
                if [ "$confirm" == "yes" ]; then
                    rm -r "$DB_DIR/$dbname"
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
