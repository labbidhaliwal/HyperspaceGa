#!/bin/bash

# Step 1: Install HyperSpace CLI
echo "🚀 Installing HyperSpace CLI..."
curl https://download.hyper.space/api/install | bash

# Step 2: Add the correct path for aios-cli to .bashrc
echo "🔄 Adding aios-cli path to .bashrc..."
echo 'export PATH=$PATH:/home/codespace/.aios' >> ~/.bashrc

# Step 3: Reload .bashrc to apply environment changes
echo "🔄 Reloading .bashrc..."
source ~/.bashrc

# Step 4: Start the Hyperspace node (use full path to aios-cli)
echo "🚀 Starting the Hyperspace node..."
/home/codespace/.aios/aios-cli start &  # Runs in background but keeps the session open

# Step 5: Wait for the node to start
echo "⏳ Waiting for the Hyperspace node to start..."
sleep 10  # Adjust the time if needed to wait for the node to initialize

# Step 6: Check if the node is running
echo "🔍 Checking node status..."
/home/codespace/.aios/aios-cli status

# Step 7: Download the required model with real-time progress
echo "🔄 Downloading the required model..."
/home/codespace/.aios/aios-cli models add hf:TheBloke/phi-2-GGUF:phi-2.Q4_K_M.gguf 2>&1 | tee /home/codespace/model_download.log

# Step 8: Verify if the model was downloaded successfully
if grep -q "Download complete" /home/codespace/model_download.log; then
    echo "✅ Model downloaded successfully!"
else
    echo "❌ Model download failed. Check /home/codespace/model_download.log for details."
    exit 1
fi

# Step 9: Ask for the private key and save it securely
echo "🔑 Please enter your private key (it will be saved to /home/codespace/my.pem):"
read -s PRIVATE_KEY
echo "$PRIVATE_KEY" > /home/codespace/my.pem
chmod 600 /home/codespace/my.pem
echo "✅ Private key saved to /home/codespace/my.pem"

# Step 10: Import private key
echo "🔑 Importing your private key..."
/home/codespace/.aios/aios-cli hive import-keys /home/codespace/my.pem

# Step 11: Login to Hive
echo "🔐 Logging into Hive..."
/home/codespace/.aios/aios-cli hive login

# Step 12: Connect to Hive
echo "🌐 Connecting to Hive..."
/home/codespace/.aios/aios-cli hive connect

# Step 13: Set Hive Tier
echo "🏆 Setting your Hive tier to 3..."
/home/codespace/.aios/aios-cli hive select-tier 3

# Step 14: Display Hive points
echo "📊 Checking your current Hive points..."
/home/codespace/.aios/aios-cli hive points

# Final message
echo "✅ HyperSpace Node setup complete!"
