#!/bin/bash

# Check if database path was provided
if [ $# -eq 0 ]; then
    echo "Error: No database path provided!"
    echo "Usage: $0 <database_path>"
    exit 1
fi

DB_PATH=$1 # database directory passed from dbms.sh

# Verify the database directory exists
if [ ! -d "$DB_PATH" ]; then
    echo "Error: Database directory '$DB_PATH' does not exist!"
    exit 1
fi

while true; do
    clear
    echo "=========================="
    echo " Database: $(basename "$DB_PATH")"
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
        1) # Create Table
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
        2) # List Tables
            echo "Tables in $(basename "$DB_PATH"):"
            if [ "$(ls -A "$DB_PATH" 2>/dev/null)" ]; then
                ls -1 "$DB_PATH"
            else
                echo "No tables found."
            fi
            read -p "Press Enter to continue..."
            ;;
        3) # Drop Table
            read -p "Enter table name to drop: " tname
            if [ -f "$DB_PATH/$tname" ]; then
                read -p "Are you sure you want to delete table '$tname'? Type 'yes' to confirm: " confirm
                if [ "$confirm" = "yes" ]; then
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
        4) # Insert into Table
            read -p "Enter table name: " tname
            if [ -f "$DB_PATH/$tname" ]; then
                schema=$(head -n 1 "$DB_PATH/$tname")
                echo "Table schema: $schema"
                read -p "Enter values (comma-separated): " values
                echo "$values" >> "$DB_PATH/$tname"
                echo "Data inserted successfully."
            else
                echo "Table '$tname' does not exist."
            fi
            read -p "Press Enter to continue..."
            ;;
        5) # Select From Table
            read -p "Enter table name: " tname
            if [ -f "$DB_PATH/$tname" ]; then
                echo "Table: $tname"
                echo "Schema: $(head -n 1 "$DB_PATH/$tname")"
                echo "=========================="
                echo "Data:"
                tail -n +2 "$DB_PATH/$tname" | nl -s ") "
            else
                echo "Table '$tname' does not exist."
            fi
            read -p "Press Enter to continue..."
            ;;
        6) # Delete From Table
            read -p "Enter table name: " tname
            if [ -f "$DB_PATH/$tname" ]; then
                echo "Table: $tname"
                echo "Data:"
                tail -n +2 "$DB_PATH/$tname" | nl -s ") "
                read -p "Enter row number to delete: " rownum
                if [ "$rownum" -gt 0 ] 2>/dev/null; then
                    # Add 1 to rownum to account for header
                    actual_line=$((rownum + 1))
                    sed -i "${actual_line}d" "$DB_PATH/$tname"
                    echo "Row deleted successfully."
                else
                    echo "Invalid row number."
                fi
            else
                echo "Table '$tname' does not exist."
            fi
            read -p "Press Enter to continue..."
            ;;
        7) # Update Table
            read -p "Enter table name: " tname
            if [ -f "$DB_PATH/$tname" ]; then
                echo "Table: $tname"
                echo "Schema: $(head -n 1 "$DB_PATH/$tname")"
                echo "Data:"
                tail -n +2 "$DB_PATH/$tname" | nl -s ") "
                read -p "Enter row number to update: " rownum
                if [ "$rownum" -gt 0 ] 2>/dev/null; then
                    read -p "Enter new values (comma-separated): " newvalues
                    # Add 1 to rownum to account for header
                    actual_line=$((rownum + 1))
                    sed -i "${actual_line}s/.*/$newvalues/" "$DB_PATH/$tname"
                    echo "Row updated successfully."
                else
                    echo "Invalid row number."
                fi
            else
                echo "Table '$tname' does not exist."
            fi
            read -p "Press Enter to continue..."
            ;;
        8) # Back to Main Menu
            echo "Returning to main menu..."
            exit 0
            ;;
        *)
            echo "Invalid choice."
            read -p "Press Enter to continue..."
            ;;
    esac
done