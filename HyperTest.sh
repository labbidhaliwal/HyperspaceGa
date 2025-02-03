#!/bin/bash

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

# Step 3: Check if aios-cli is available
echo "🔍 Checking if aios-cli is installed and available..."
which aios-cli

# Step 4: Run aios-cli start directly
echo "🚀 Starting the Hyperspace node..."
/root/.aios/aios-cli start

# Step 5: Wait for the node to start
echo "⏳ Waiting for the Hyperspace node to start..."
sleep 10  # Adjust the time if needed

# Step 6: Check the node status
echo "🔍 Checking node status..."
/root/.aios/aios-cli status

# Step 8: Proceed with the next steps if the node is running
echo "✅ Hyperspace node is up and running, proceeding with next steps."

# Step 9: Download the required model with real-time progress
echo "🔄 Downloading the required model..."
aios-cli models add hf:TheBloke/phi-2-GGUF:phi-2.Q4_K_M.gguf 2>&1 | tee /root/model_download.log

# Step 10: Verify if the model was downloaded successfully
if grep -q "Download complete" /root/model_download.log; then
    echo "✅ Model downloaded successfully!"
else
    echo "❌ Model download failed. Check /root/model_download.log for details."
    exit 1
fi

# Step 11: Ask for the private key and save it securely
echo "🔑 Please enter your private key (it will be saved to /root/my.pem):"
read -s PRIVATE_KEY
echo "$PRIVATE_KEY" > /root/my.pem
chmod 600 /root/my.pem
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

# Step 15: Set Hive Tier
echo "🏆 Setting your Hive tier to 3..."
aios-cli hive select-tier 3

# Step 16: Display Hive points
echo "📊 Checking your current Hive points..."
aios-cli hive points

# Final message
echo "✅ HyperSpace Node setup complete!"
