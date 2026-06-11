#!/bin/bash

SECRETS_DIR="./secrets"
WP_DIR="$SECRETS_DIR/wordpress"
DB_DIR="$SECRETS_DIR/mariadb"
FTP_DIR="$SECRETS_DIR/ftp"

mkdir -p "$SECRETS_DIR" "$WP_DIR" "$DB_DIR" "$FTP_DIR"

declare -A SECRETS=(
    ["$DB_DIR/mariadb_wp_user_password.txt"]="MariaDB WordPress User Password (Secret)"
    ["$FTP_DIR/ftp_password.txt"]="FTP User Password (Secret)"
    ["$WP_DIR/wp_admin_name.txt"]="WordPress Admin Username"
    ["$WP_DIR/wp_admin_mail.txt"]="WordPress Admin Email"
    ["$WP_DIR/wp_admin_password.txt"]="WordPress Admin Password (Secret)"
    ["$WP_DIR/wp_user_name.txt"]="WordPress Default Author Username"
    ["$WP_DIR/wp_user_mail.txt"]="WordPress Default Author Email"
    ["$WP_DIR/wp_user_password.txt"]="WordPress Default Author Password (Secret)"
)

NEEDS_INPUT=false
for file in "${!SECRETS[@]}"; do
    if [ ! -f "$file" ] || [ ! -s "$file" ]; then
        NEEDS_INPUT=true
        break
    fi
done

if [ "$NEEDS_INPUT" = false ]; then
    echo "--------------------------------------------------"
    echo "✅ Secrets are already present and configured!"
    echo "--------------------------------------------------"
    exit 0
fi

echo "--------------------------------------------------"
echo "🔐 Setup needed. Please enter missing credentials:"
echo "--------------------------------------------------"

ask_password() {
    local prompt=$1
    local file_path=$2
    local password=""
    
    while [ -z "$password" ]; do
        read -rs -p "$prompt: " password
        echo ""
        if [ -z "$password" ]; then
            echo "❌ Password cannot be empty. Please try again."
        fi
    done
    echo -n "$password" > "$file_path"
}

ask_text() {
    local prompt=$1
    local file_path=$2
    local value=""
    
    while [ -z "$value" ]; do
        read -r -p "$prompt: " value
        if [ -z "$value" ]; then
            echo "❌ This field cannot be empty. Please try again."
        fi
    done
    echo -n "$value" > "$file_path"
}

for file in "${!SECRETS[@]}"; do
    if [ ! -f "$file" ] || [ ! -s "$file" ]; then
        description="${SECRETS[$file]}"
        
        if [[ "$description" == *"(Secret)"* ]]; then
            clean_prompt=$(echo "$description" | sed 's/ (Secret)//')
            ask_password "Enter $clean_prompt" "$file"
        else
            ask_text "Enter $description" "$file"
        fi
    else
        echo "ℹ️  $(basename "$file") is already set. Skipping..."
    fi
done

echo "--------------------------------------------------"
echo "✨ All secret files are now successfully set up!"
echo "--------------------------------------------------"