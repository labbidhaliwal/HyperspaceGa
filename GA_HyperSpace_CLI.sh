#!/bin/bash

# Infinite loop to keep retrying the script if any part fails
while true; do
    printf "\n"

    # Labbi Banner
    GREEN="\033[0;32m"
    RESET="\033[0m"
    printf "${GREEN}"
    printf "🚀 THIS SCRIPT IS PROUDLY CREATED BY **Labbi**! 🚀\n"
    printf "Stay connected for updates:\n"
    printf "   • Telegram: https://t.me/LabbiOfficial\n"
    printf "   • X (formerly Twitter): https://x.com/LabbiCrypto\n"
    printf "${RESET}"

    # Step 1: Install HyperSpace CLI
    echo "🚀 Installing HyperSpace CLI..."

    # Ensure log file is created with the right permissions
    LOG_FILE="/tmp/hyperspace_install.log"
    sudo touch "$LOG_FILE"
    sudo chmod 666 "$LOG_FILE"

    while true; do
        sudo curl -s https://download.hyper.space/api/install | sudo bash | tee "$LOG_FILE"

        if ! grep -q "Failed to parse version from release data." "$LOG_FILE"; then
            echo "✅ HyperSpace CLI installed successfully!"
            break
        else
            echo "❌ Installation failed. Retrying in 10 seconds..."
            sleep 5
        fi
    done

    # Step 2: Add aios-cli to PATH and persist it
    echo "🔄 Adding aios-cli path to .bashrc..."
    echo 'export PATH=$PATH:$HOME/.aios' | sudo tee -a /etc/profile > /dev/null
    export PATH=$PATH:$HOME/.aios
    source /etc/profile

    # Step 3: Start the Hyperspace node in a screen session
    echo "🚀 Starting the Hyperspace node in the background..."
    sudo screen -S hyperspace -d -m bash -c "$HOME/.aios/aios-cli start"

    # Step 4: Wait for node startup
    echo "⏳ Waiting for the Hyperspace node to start..."
    sleep 10

    # Step 5: Check if aios-cli is available
    echo "🔍 Checking if aios-cli is installed..."
    if ! command -v aios-cli &> /dev/null; then
        echo "❌ aios-cli not found. Retrying..."
        continue
    fi

    # Step 6: Check node status
    echo "🔍 Checking node status..."
    sudo aios-cli status

    echo "✅ Setup complete!"
    break  # Exit the loop after successful execution

done
