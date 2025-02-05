#!/bin/bash

# Infinite loop to keep retrying the script if any part fails
while true; do
    printf "\n"
    cat <<EOF


░██████╗░░█████╗░  ░█████╗░██████╗░██╗░░░██╗██████╗░████████╗░█████╗░
██╔════╝░██╔══██╗  ██╔══██╗██╔══██╗╚██╗░██╔╝██╔══██╗╚══██╔══╝██╔══██╗
██║░░██╗░███████║  ██║░░╚═╝██████╔╝░╚████╔╝░██████╔╝░░░██║░░░██║░░██║
██║░░╚██╗██╔══██║  ██║░░██╗██╔══██╗░░╚██╔╝░░██╔═══╝░░░░██║░░░██║░░██║
╚██████╔╝██║░░██║  ╚█████╔╝██║░░██║░░░██║░░░██║░░░░░░░░██║░░░╚█████╔╝
░╚═════╝░╚═╝░░╚═╝  ░╚════╝░╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░░░░░░░╚═╝░░░░╚════╝░
EOF

    printf "\n\n"

    ##########################################################################################
    #                                                                                        
    #                🚀 THIS SCRIPT IS PROUDLY CREATED BY **GA CRYPTO**! 🚀                  
    #                                                                                        
    #   🌐 Join our revolution in decentralized networks and crypto innovation!               
    #                                                                                        
    # 📢 Stay updated:                                                                      
    #     • Follow us on Telegram: https://t.me/GaCryptOfficial                             
    #     • Follow us on X: https://x.com/GACryptoO                                         
    ##########################################################################################

    # Green color for advertisement
    GREEN="\033[0;32m"
    RESET="\033[0m"

    # Print the advertisement using printf
    printf "${GREEN}"
    printf "🚀 THIS SCRIPT IS PROUDLY CREATED BY **GA CRYPTO**! 🚀\n"
    printf "Stay connected for updates:\n"
    printf "   • Telegram: https://t.me/GaCryptOfficial\n"
    printf "   • X (formerly Twitter): https://x.com/GACryptoO\n"
    printf "${RESET}"


# Step 1: Install HyperSpace CLI
echo "🚀 Installing HyperSpace CLI..."

while true; do
    # Run the installation
    curl -s https://download.hyper.space/api/install | bash | tee /root/hyperspace_install.log

    # Check if installation was successful
    if ! grep -q "Failed to parse version from release data." /root/hyperspace_install.log; then
        echo "✅ HyperSpace CLI installed successfully!"
        break  # Exit loop if installation succeeds
    else
        echo "❌ Installation failed: 'Failed to parse version from release data.' Retrying in 10 seconds..."
        sleep 5  # Wait before retrying
    fi
done

# Step 2: Add the aios-cli path to .bashrc
echo "🔄 Adding aios-cli path to .bashrc..."
export PATH=$PATH:~/.aios

# Step 3: Reload .bashrc to apply environment changes
echo "🔄 Reloading .bashrc..."
source ~/.bashrc

# Step 4: Start the Hyperspace node in a screen session
echo "🚀 Starting the Hyperspace node in the background..."
screen -S hyperspace -d -m bash -c "/root/.aios/aios-cli start"

# Step 5: Wait for the node to start
echo "⏳ Waiting for the Hyperspace node to start..."
sleep 10  # Adjust time if needed

# Step 6: Check if aios-cli is available
echo "🔍 Checking if aios-cli is installed and available..."
which aios-cli

# Step 7: Check the node status
echo "🔍 Checking node status..."
/root/.aios/aios-cli status

# Step 8: Proceed with the next steps if the node is running
echo "✅ Hyperspace node is up and running, proceeding with next steps."

# Step 9: Download the required model with live progress
echo "🔄 Downloading the required model..."
aios-cli models add hf:TheBloke/Mistral-7B-Instruct-v0.1-GGUF:mistral-7b-instruct-v0.1.Q4_K_S.gguf | tee /root/model_download.log

echo "🔄 Downloading the required model..."

# Loop to retry the download if it fails
while true; do
    # Run the model download and show progress
    aios-cli models add hf:TheBloke/Mistral-7B-Instruct-v0.1-GGUF:mistral-7b-instruct-v0.1.Q4_K_S.gguf | tee /root/model_download.log

    # Check if download was successful
    if grep -q "Download complete" /root/model_download.log; then
        echo "✅ Model downloaded successfully!"
        break  # Exit loop since download succeeded
    else
        echo "❌ Model download failed. Retrying in 10 seconds..."
        sleep 5  # Wait before retrying
    fi
done

# Step 11: Ask for the private key and save it securely
echo "🔑 Enter your private key:"
read -p "Private Key: " private_key
echo $private_key > /root/my.pem
echo "✅ Private key saved to /root/my.pem"

# Step 12: Import private key
echo "🔑 Importing your private key..."
aios-cli hive import-keys /root/my.pem

# Step 13: Login to Hive
echo "🔐 Logging into Hive..."
aios-cli hive login

# Step 14: Connect to Hive
echo "🌐 Connecting to Hive..."
aios-cli hive connect

# Step 15: Display system info before selecting tier
echo "🖥️ Fetching system information..."
aios-cli system-info

# Step 16: Set Hive Tier
echo "🏆 Setting your Hive tier to 3..."
aios-cli hive select-tier 3 

# Step 17: Display Hive points in a loop every 10 seconds
echo "📊 Checking your current Hive points every 10 seconds..."
echo "✅ HyperSpace Node setup complete!"
echo "ℹ️ You can use 'CTRL + A + D' to detach the screen and 'screen -r gaspace' to reattach the screen."

# Loop to check Hive points every 10 seconds
while :; do
    echo "ℹ️ You can use 'CTRL + A + D' to detach the screen and 'screen -r gaspace' to reattach the screen."
    aios-cli hive points
    sleep 10
done &
