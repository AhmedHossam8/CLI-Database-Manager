#!/bin/bash


if [ $# -eq 0 ]; then
    zenity --error --text="Error: No database path provided!\nUsage: $0 <database_path>"
    exit 1
fi

DB_PATH=$1 # database directory passed from dbms.sh

# Verify the database directory exists
if [ ! -d "$DB_PATH" ]; then
    zenity --error --text="Error: Database directory '$DB_PATH' does not exist!"
    exit 1
fi

while true; do
    choice=$(zenity --list --title="Database: $(basename "$DB_PATH")" \
        --column="Option" \
        "Create Table" \
        "List Tables" \
        "Drop Table" \
        "Insert into Table" \
        "Select From Table" \
        "Delete From Table" \
        "Update Table" \
        "Back to Main Menu" \
        --height=350 --width=400)
    
    case $choice in
        "Create Table")
            tname=$(zenity --entry --title="Create Table" --text="Enter table name:")
            if [ -z "$tname" ]; then
                zenity --error --text="No table name entered!"
            elif [ -f "$DB_PATH/$tname" ]; then
                zenity --error --text="Table '$tname' already exists!"
            else
                schema=$(zenity --entry --title="Table Schema" --text="Enter columns (e.g. id,name,age):")
                echo "$schema" > "$DB_PATH/$tname"
                zenity --info --text="Table '$tname' created with schema: $schema"
            fi
            ;;
        "List Tables")
            if [ "$(ls -A "$DB_PATH" 2>/dev/null)" ]; then
                ls -1 "$DB_PATH" | zenity --text-info --title="Tables in $(basename "$DB_PATH")" --width=300 --height=200
            else
                zenity --warning --text="No tables found."
            fi
            ;;
        "Drop Table")
            tname=$(zenity --entry --title="Drop Table" --text="Enter table name:")
            if [ -f "$DB_PATH/$tname" ]; then
                if zenity --question --text="Are you sure you want to delete '$tname'?"; then
                    rm "$DB_PATH/$tname"
                    zenity --info --text="Table '$tname' deleted."
                fi
            else
                zenity --error --text="Table '$tname' does not exist."
            fi
            ;;
        "Insert into Table")
            tname=$(zenity --entry --title="Insert into Table" --text="Enter table name:")
            if [ -f "$DB_PATH/$tname" ]; then
                schema=$(head -n 1 "$DB_PATH/$tname")
                values=$(zenity --entry --title="Insert into $tname" --text="Schema: $schema\nEnter values (comma-separated):")
                echo "$values" >> "$DB_PATH/$tname"
                zenity --info --text="Data inserted successfully."
            else
                zenity --error --text="Table '$tname' does not exist."
            fi
            ;;
        "Select From Table")
            tname=$(zenity --entry --title="Select From Table" --text="Enter table name:")
            if [ -f "$DB_PATH/$tname" ]; then
                data=$(tail -n +2 "$DB_PATH/$tname" | nl -s ") ")
                zenity --text-info --title="Table: $tname" --width=400 --height=300 \
                    --filename=<(echo -e "Schema: $(head -n 1 "$DB_PATH/$tname")\n\n$data")
            else
                zenity --error --text="Table '$tname' does not exist."
            fi
            ;;
        "Delete From Table")
            tname=$(zenity --entry --title="Delete From Table" --text="Enter table name:")
            if [ -f "$DB_PATH/$tname" ]; then
                data=$(tail -n +2 "$DB_PATH/$tname" | nl -s ") ")
                rownum=$(zenity --entry --title="Delete From $tname" --text="Data:\n$data\n\nEnter row number to delete:")
                if [ "$rownum" -gt 0 ] 2>/dev/null; then
                    actual_line=$((rownum + 1))
                    sed -i "${actual_line}d" "$DB_PATH/$tname"
                    zenity --info --text="Row deleted successfully."
                else
                    zenity --error --text="Invalid row number."
                fi
            else
                zenity --error --text="Table '$tname' does not exist."
            fi
            ;;
        "Update Table")
            tname=$(zenity --entry --title="Update Table" --text="Enter table name:")
            if [ -f "$DB_PATH/$tname" ]; then
                schema=$(head -n 1 "$DB_PATH/$tname")
                data=$(tail -n +2 "$DB_PATH/$tname" | nl -s ") ")
                rownum=$(zenity --entry --title="Update $tname" --text="Schema: $schema\n\nData:\n$data\n\nEnter row number to update:")
                if [ "$rownum" -gt 0 ] 2>/dev/null; then
                    newvalues=$(zenity --entry --title="New Values" --text="Enter new values (comma-separated):")
                    actual_line=$((rownum + 1))
                    sed -i "${actual_line}s/.*/$newvalues/" "$DB_PATH/$tname"
                    zenity --info --text="Row updated successfully."
                else
                    zenity --error --text="Invalid row number."
                fi
            else
                zenity --error --text="Table '$tname' does not exist."
            fi
            ;;
        "Back to Main Menu")
            exit 0
            ;;
    esac
done