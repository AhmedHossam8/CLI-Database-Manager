#!/bin/bash

DB_DIR="./databases"

mkdir -p "DB_DIR"

while true; do
    clear
    echo "=========================="
    echo "     Database Manager"
    echo "=========================="
    echo "1) Create Database"
    echo "2) List Databases"
    echo "3) Exit"
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
