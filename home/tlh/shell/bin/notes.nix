{pkgs}:
with pkgs;
  writeScriptBin "notes" ''
    #!/usr/bin/env bash
    NOTES_DIR="./.notes"

    # Create the .notes directory if it doesn't exist
    mkdir -p "$NOTES_DIR"

    # Function to create a new note or open an existing note
    create_or_open_note() {
        echo -n "Enter the title of the note: "
        read title

        # Remove spaces from the title to form the filename
        filename=$(echo "$title" | tr -d '[:space:]').md

        # Check if the note already exists
        if [ -e "$NOTES_DIR/$filename" ]; then
            echo -e "Note with the same title already exists. Opening the note..."
            "$EDITOR" "$NOTES_DIR/$filename"
        else
            # Create the note file
            echo "# $title" > "$NOTES_DIR/$filename"
            echo -e "Note '%s' created successfully!" "$title"
            "$EDITOR" "$NOTES_DIR/$filename"
        fi
    }

    # Function to list all existing notes
    list_notes() {
        printf "List of existing notes:\n"
        for note in "$NOTES_DIR"/*.md; do
            echo -e "- $(basename "$note" .md)"
        done
    }

    # Function to view a specific notehome/tlh/shared/shell/bin/notes.nix
    view_note() {
        echo -n "Enter the title of the note you want to view: "
        read title

        # Remove spaces from the title to find the filename
        filename=$(echo "$title" | tr -d '[:space:]').md

        # Check if the note exists
        if [ -e "$NOTES_DIR/$filename" ]; then
            "$EDITOR" "$NOTES_DIR/$filename"
        else
            echo "Note '%s' not found." "$title"
            exit 1
        fi
    }

    # Function to delete a note
    delete_note() {
        echo -n "Enter the title of the note you want to delete: "
        read title

        # Remove spaces from the title to find the filename
        filename=$(echo "$title" | tr -d '[:space:]').md

        # Check if the note exists
        if [ -e "$NOTES_DIR/$filename" ]; then
            rm "$NOTES_DIR/$filename"
            echo -e "Note '%s' deleted successfully!" "$title"
        else
            echo "Note '%s' not found." "$title"
            exit 1
        fi
    }

    # Main menu
    echo "     Local Markdown Notes Manager"
    echo "+---------------------------------------+"

    while true; do
        echo   "Select an option:"
        echo   "1. Create or Open a note"
        echo   "2. List all existing notes"
        echo   "3. View a specific note"
        echo   "4. Delete a note"
        echo   "5. Exit"

        read choice

        case $choice in
        1)
            create_or_open_note
            ;;
        2)
            list_notes
            ;;
        3)
            view_note
            ;;
        4)
            delete_note
            ;;
        5)
            printf "Exiting. Have a great day!\n"
            exit 0
            ;;
        *)
            printf "Invalid choice. Please try again.\n"
            ;;
        esac

        printf "\n"
    done

  ''
