#!/bin/bash

DB_PATH=$1   # database directory passed from dbms.sh

while true; do
    clear
    echo "=========================="
    echo "   Database: $(basename "$DB_PATH")"
    echo "=========================="
    echo "1) Create Table"
    echo "2) List Tables"
    echo "3) Drop Table"
    echo "4) Insert into Table"
    echo "5) Select From Table"
    echo "6) Delete From Table"
    echo "7) Update Table"
    echo "8) Back to Main Menu"
    echo "=========================="
    read -p "Enter your choice: " choice

    case $choice in
        1)  # Create Table
            read -p "Enter table name: " tname
            if [ -f "$DB_PATH/$tname" ]; then
                echo "Table '$tname' already exists!"
            else
                read -p "Enter columns (e.g. id:int,name:string,age:int): " schema
                echo "$schema" > "$DB_PATH/$tname"
                echo "Table '$tname' created with schema: $schema"
            fi
            read -p "Press Enter to continue..."
            ;;

        2)  # List Tables
            echo "Tables in $(basename "$DB_PATH"):"
            if [ "$(ls -A "$DB_PATH")" ]; then
                ls -1 "$DB_PATH"
            else
                echo "No tables found."
            fi
            read -p "Press Enter to continue..."
            ;;
         3)  # Drop Table
            read -p "Enter table name to drop: " tname
            if [ -f "$DB_PATH/$tname" ]; then
                read -p "Are you sure you want to delete table '$tname'? Type 'yes' to confirm: " confirm
                if [ "$confirm" == "yes" ]; then
                    rm "$DB_PATH/$tname"
                    echo "Table '$tname' deleted."
                else
                    echo "Delete operation canceled."
                fi
            else
                echo "Table '$tname' does not exist."
            fi
            read -p "Press Enter to continue..."
            ;;

