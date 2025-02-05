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

# Step 9: Download the required model with real-time progress
echo "🔄 Downloading the required model..."
while true; do
    # Run the model download in the background
    aios-cli models add hf:TheBloke/Mistral-7B-Instruct-v0.1-GGUF:mistral-7b-instruct-v0.1.Q4_K_S.gguf 2>&1 | tee /root/model_download.log &
    PID=$!
    sleep 10
    while ps -p $PID > /dev/null; do
        sleep 10
    done
    break
done

# Step 10: Verify model download
if grep -q "Download complete" /root/model_download.log; then
    echo "✅ Model downloaded successfully!"
else
    echo "❌ Model download failed. Check /root/model_download.log for details."
    exit 1
fi

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
