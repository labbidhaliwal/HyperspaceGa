#!/bin/bash

echo "==========================================="
echo "🚀 Starting HyperSpace CLI Setup Script..."
echo "==========================================="

# Step 1: Install HyperSpace CLI
echo "📥 Installing HyperSpace CLI..."
curl https://download.hyper.space/api/install | bash
if [ $? -ne 0 ]; then
    echo "❌ Installation failed! Exiting..."
    exit 1
fi
echo "✅ HyperSpace CLI installed successfully!"

echo "-------------------------------------------"

# Step 2: Add aios-cli to PATH & reload bashrc
echo "🔄 Updating PATH..."
echo 'export PATH=$PATH:/root/.aios' >> ~/.bashrc
source ~/.bashrc

echo "🔍 Checking if aios-cli is available..."
if ! command -v aios-cli &> /dev/null; then
    echo "❌ aios-cli not found after installation! Exiting..."
    exit 1
fi
echo "✅ aios-cli is available!"

echo "-------------------------------------------"

# Step 3: Install screen if missing
echo "🔍 Checking if screen is installed..."
if ! command -v screen &> /dev/null; then
    echo "📦 Installing screen..."
    apt update && apt install -y screen
    if [ $? -ne 0 ]; then
        echo "❌ Failed to install screen! Exiting..."
        exit 1
    fi
    echo "✅ screen installed successfully!"
else
    echo "✅ screen is already installed!"
fi

echo "-------------------------------------------"

# Step 4: Kill any old Hyperspace screen session
echo "🛑 Killing any old Hyperspace screen sessions..."
screen -ls | grep "hyperspace" | awk '{print $1}' | xargs -I{} screen -S {} -X quit
echo "✅ Old Hyperspace screen sessions terminated."

echo "-------------------------------------------"

# Step 5: Create a new screen session and start the node
echo "🎥 Creating a screen session for Hyperspace..."
screen -dmS hyperspace bash -c 'aios-cli start'
if [ $? -ne 0 ]; then
    echo "❌ Failed to start Hyperspace node inside screen! Exiting..."
    exit 1
fi
echo "✅ Hyperspace node started successfully in screen session!"

echo "-------------------------------------------"

# Step 6: Ensure the node starts before proceeding
echo "⏳ Waiting for the node to initialize..."
sleep 10
echo "✅ Node initialization wait time completed."

echo "-------------------------------------------"

# Step 7: Download the required model
echo "🔄 Downloading the required model..."
screen -S hyperspace -X stuff "aios-cli models add hf:TheBloke/phi-2-GGUF:phi-2.Q4_K_M.gguf > /root/model_download.log 2>&1\n"
if [ $? -ne 0 ]; then
    echo "❌ Failed to download the model! Exiting..."
    exit 1
fi
echo "✅ Model download initiated!"

echo "-------------------------------------------"

# Step 8: Show model download progress
echo "📊 Showing live download progress..."
sleep 3
tail -f /root/model_download.log &

echo "-------------------------------------------"

# Step 9: Ask for the private key and save it automatically
echo "🔑 Please enter your private key (it will be saved to /root/my.pem):"
read -p "Private Key: " private_key
echo $private_key > /root/my.pem
echo "✅ Private key saved to /root/my.pem"
echo "✅ Private key saved securely!"

echo "-------------------------------------------"

# Step 10: Import the private key
echo "🔑 Importing private key..."
screen -S hyperspace -X stuff "aios-cli hive import-keys /root/my.pem\n"
if [ $? -ne 0 ]; then
    echo "❌ Failed to import private key! Exiting..."
    exit 1
fi
echo "✅ Private key imported!"

echo "-------------------------------------------"

# Step 11: Log in to Hive
echo "🔐 Logging into Hive..."
screen -S hyperspace -X stuff "aios-cli hive login\n"
if [ $? -ne 0 ]; then
    echo "❌ Hive login failed! Exiting..."
    exit 1
fi
echo "✅ Successfully logged into Hive!"

echo "-------------------------------------------"

# Step 12: Connect to Hive
echo "🌐 Connecting to Hive..."
screen -S hyperspace -X stuff "aios-cli hive connect\n"
if [ $? -ne 0 ]; then
    echo "❌ Failed to connect to Hive! Exiting..."
    exit 1
fi
echo "✅ Successfully connected to Hive!"

echo "-------------------------------------------"

# Step 13: Set Hive tier to 3
echo "🏆 Setting Hive tier to 3..."
screen -S hyperspace -X stuff "aios-cli hive select-tier 3\n"
if [ $? -ne 0 ]; then
    echo "❌ Failed to set Hive tier! Exiting..."
    exit 1
fi
echo "✅ Hive tier set to 3!"

echo "-------------------------------------------"

# Step 14: Display Hive points
echo "📊 To check your current Hive points, use the following command:"
echo "   aios-cli hive points"

echo "-------------------------------------------"

# Final message
echo "==========================================="
echo "✅ 🎉 HyperSpace Node setup complete! 🎉 ✅"
echo "==========================================="
