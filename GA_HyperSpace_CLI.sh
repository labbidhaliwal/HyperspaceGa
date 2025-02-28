#!/bin/bash

# Infinite loop to retry if any part fails
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

    # Step 1: Fix permissions issue for the log file
    LOG_FILE="$HOME/hyperspace_install.log"  # Store log file in home directory to avoid permission issues
    touch "$LOG_FILE"
    chmod 666 "$LOG_FILE"

    echo "🚀 Installing HyperSpace CLI..."

    while true; do
        sudo curl -s https://download.hyper.space/api/install | sudo bash | tee "$LOG_FILE"

        if ! grep -q "Failed to parse version from release data." "$LOG_FILE"; then
            echo "✅ HyperSpace CLI installed successfully!"
            break
        else
            echo "❌ Installation failed. Retrying in 10 seconds..."
            sleep 10
        fi
    done

    # Step 2: Ensure aios-cli is in PATH
    echo "🔄 Adding aios-cli path to .bashrc..."
    echo 'export PATH=$HOME/.aios:$PATH' | tee -a ~/.bashrc > /dev/null
    export PATH=$HOME/.aios:$PATH
    source ~/.bashrc

    # Step 3: Verify if aios-cli is installed
    echo "🔍 Checking if aios-cli is installed..."
    if ! command -v aios-cli &> /dev/null; then
        echo "❌ aios-cli not found! Exiting script."
        exit 1
    fi

    # Step 4: Start the Hyperspace node in a screen session
    echo "🚀 Starting the Hyperspace node in the background..."
    sudo screen -S hyperspace -d -m bash -c "$HOME/.aios/aios-cli start"

    # Step 5: Wait for node startup
    echo "⏳ Waiting for the Hyperspace node to start..."
    sleep 10

    # Step 6: Check node status
    echo "🔍 Checking node status..."
    sudo aios-cli status

    # Step 7: Download the required model
    echo "🔄 Downloading the required model..."
    MODEL_LOG="$HOME/model_download.log"
    touch "$MODEL_LOG"
    chmod 666 "$MODEL_LOG"

    while true; do
        sudo aios-cli models add hf:second-state/Qwen1.5-1.8B-Chat-GGUF:Qwen1.5-1.8B-Chat-Q4_K_M.gguf | tee "$MODEL_LOG"

        if grep -q "Download complete" "$MODEL_LOG"; then
            echo "✅ Model downloaded successfully!"
            break
        else
            echo "❌ Model download failed. Retrying in 10 seconds..."
            sleep 10
        fi
    done

    # Step 8: Securely input private key
    echo "🔑 Enter your private key:"
    read -s -p "Private Key: " private_key
    echo
    echo "$private_key" | sudo tee /root/my.pem > /dev/null
    sudo chmod 600 /root/my.pem
    echo "✅ Private key saved to /root/my.pem"

    # Step 9: Import private key
    echo "🔑 Importing your private key..."
    sudo aios-cli hive import-keys /root/my.pem

    # Step 10: Login to Hive
    echo "🔐 Logging into Hive..."
    sudo aios-cli hive login

    # Step 11: Connect to Hive
    echo "🌐 Connecting to Hive..."
    sudo aios-cli hive connect

    # Step 12: Display system info
    echo "🖥️ Fetching system information..."
    sudo aios-cli system-info

    # Step 13: Set Hive Tier
    echo "🏆 Setting your Hive tier to 3..."
    sudo aios-cli hive select-tier 3 

    # Step 14: Check Hive points in a loop every 10 seconds
    echo "📊 Checking your Hive points every 10 seconds..."
    echo "✅ HyperSpace Node setup complete!"
    echo "ℹ️ Use 'CTRL + A + D' to detach the screen and 'screen -r hyperspace' to reattach."

    while true; do
        echo "ℹ️ Press 'CTRL + A + D' to detach the screen, 'screen -r hyperspace' to reattach."
        sudo aios-cli hive points
        sleep 10
    done

done
