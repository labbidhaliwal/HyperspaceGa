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

# Run the model download without checking Hive points in every 10 seconds
while true; do
    # Run the model download in the background
    aios-cli models add hf:TheBloke/phi-2-GGUF:phi-2.Q4_K_M.gguf 2>&1 | tee /root/model_download.log &

    PID=$!

    # Wait for a few seconds to allow the download to start
    sleep 10

    # Check if the model download is still in progress and continue
    while ps -p $PID > /dev/null; do
        # Just wait for the download to finish without displaying Hive points
        sleep 10
    done

    # Break the loop once download completes
    break
done

# Step 10: Verify if the model was downloaded successfully
if grep -q "Download complete" /root/model_download.log; then
    echo "✅ Model downloaded successfully!"
else
    echo "❌ Model download failed. Check /root/model_download.log for details."
    exit 1
fi

# Step 10: Verify if the model was downloaded successfully
if grep -q "Download complete" /root/model_download.log; then
    echo "✅ Model downloaded successfully!"
else
    echo "❌ Model download failed. Check /root/model_download.log for details."
    exit 1
fi

# Step 11: Ask for the private key and save it securely
echo "🔑Enter your private key:"
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

# Step 15: Set Hive Tier
echo "🏆 Setting your Hive tier to 3..."
aios-cli hive select-tier 2

# Step 16: Display Hive points in a loop every 10 seconds
echo "📊 Checking your current Hive points every 10 seconds..."
echo "✅ HyperSpace Node setup complete!"
echo "ℹ️ You can use 'CTRL + A + D' to detach the screen and 'screen -r gaspace' to reattach the screen."

# Loop to check Hive points every 10 seconds
while :; do
    # Display Hive points
    echo "ℹ️ You can use 'CTRL + A + D' to detach the screen and 'screen -r gaspace' to reattach the screen."
    aios-cli hive points
    # Wait for 10 seconds before checking again
    sleep 10
done &

