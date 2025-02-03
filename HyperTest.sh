#!/bin/bash

# Enable debug mode to print each command as it's executed
set -x

# Step 1: Install HyperSpace CLI
echo "🚀 Installing HyperSpace CLI..."
curl https://download.hyper.space/api/install | bash

# Step 2: Add the aios-cli path to .bashrc
echo "🔄 Adding aios-cli path to .bashrc..."
export PATH=$PATH:~/.aios

# Step 3: Reload .bashrc to apply environment changes
echo "🔄 Reloading .bashrc..."
source ~/.bashrc

# Step 4: Kill all existing screen sessions (if any)
echo "🔴 Killing all existing screen sessions..."
screen -ls | awk '/[0-9]+\./ {print $1}' | xargs -I {} screen -S {} -X quit
echo "✅ All existing screen sessions have been terminated."

# Step 5: Create a screen session and run aios-cli start in the background
echo "🚀 Starting the Hyperspace node in the background..."
screen -S hyperspace -d -m bash -c "/root/.aios/aios-cli start"

# Step 6: Wait for the node to start
echo "⏳ Waiting for the Hyperspace node to start..."
sleep 10 # Wait for node initialization, adjust time if needed

# Step 7: Check if aios-cli is installed and available
echo "🔍 Checking if aios-cli is installed and available..."
which aios-cli

# Step 8: Run aios-cli start directly
echo "🚀 Starting the Hyperspace node..."
/root/.aios/aios-cli start

# Step 9: Wait for the node to start
echo "⏳ Waiting for the Hyperspace node to start..."
sleep 10  # Adjust the time if needed

# Step 10: Check the node status
echo "🔍 Checking node status..."
/root/.aios/aios-cli status

# Step 11: Proceed with the next steps if the node is running
echo "✅ Hyperspace node is up and running, proceeding with next steps."

# Step 12: Download the required model with real-time progress
echo "🔄 Downloading the required model..."
aios-cli models add hf:TheBloke/phi-2-GGUF:phi-2.Q4_K_M.gguf 2>&1 | tee /root/model_download.log

# Step 13: Display Hive points every 10 seconds during download
while :; do
    echo "📊 Checking your current Hive points..."
    aios-cli hive points
    sleep 10
done &

# Step 14: Verify if the model was downloaded successfully
if grep -q "Download complete" /root/model_download.log; then
    echo "✅ Model downloaded successfully!"
else
    echo "❌ Model download failed. Check /root/model_download.log for details."
    exit 1
fi

# Step 15: Ask for the private key and save it securely
echo "🔑Enter your private key:"
read -p "Private Key: " private_key
echo $private_key > /root/my.pem
echo "✅ Private key saved to /root/my.pem"

# Step 16: Import the private key
echo "🔑 Importing your private key..."
aios-cli hive import-keys /root/my.pem

# Step 17: Login to Hive
echo "🔐 Logging into Hive..."
aios-cli hive login

# Step 18: Connect to Hive
echo "🌐 Connecting to Hive..."
aios-cli hive connect

# Step 19: Set Hive Tier
echo "🏆 Setting your Hive tier to 3..."
aios-cli hive select-tier 3

# Step 20: Display Hive points
echo "📊 Checking your current Hive points..."
aios-cli hive points

# Final message
echo "✅ HyperSpace Node setup complete!"
echo "ℹ️ You can use 'alt + A + D' to detach the screen and 'screen -r hyperspace' to reattach the screen."
