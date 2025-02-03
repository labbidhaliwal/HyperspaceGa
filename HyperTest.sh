#!/bin/bash

# Step 1: Install HyperSpace CLI
echo "🚀 Installing HyperSpace CLI..."
curl https://download.hyper.space/api/install | bash

# Step 2: Reload .bashrc to apply environment changes
echo "🔄 Reloading .bashrc to apply environment changes..."
echo 'export PATH=$PATH:/root/.aios' >> ~/.bashrc
source ~/.bashrc

# Step 3: Start the Hyperspace node in the foreground
echo "🚀 Starting the Hyperspace node..."
aios-cli start &  # Runs in background but keeps the session open

# Step 4: Wait for the node to initialize
echo "⏳ Waiting for the node to start..."
sleep 10  # Adjust time if needed

# Step 5: Download the required model with real-time progress
echo "🔄 Downloading the required model..."
aios-cli models add hf:TheBloke/phi-2-GGUF:phi-2.Q4_K_M.gguf 2>&1 | tee /root/model_download.log

# Step 6: Verify if the model was downloaded successfully
if grep -q "Download complete" /root/model_download.log; then
    echo "✅ Model downloaded successfully!"
else
    echo "❌ Model download failed. Check /root/model_download.log for details."
    exit 1
fi

# Step 7: Ask for the private key and save it securely
echo "🔑 Please enter your private key (it will be saved to /root/my.pem):"
read -s PRIVATE_KEY
echo "$PRIVATE_KEY" > /root/my.pem
chmod 600 /root/my.pem
echo "✅ Private key saved to /root/my.pem"

# Step 8: Import private key
echo "🔑 Importing your private key..."
aios-cli hive import-keys /root/my.pem

# Step 9: Login to Hive
echo "🔐 Logging into Hive..."
aios-cli hive login

# Step 10: Connect to Hive
echo "🌐 Connecting to Hive..."
aios-cli hive connect

# Step 11: Set Hive Tier
echo "🏆 Setting your Hive tier to 3..."
aios-cli hive select-tier 3

# Step 12: Display Hive points
echo "📊 Checking your current Hive points..."
aios-cli hive points

# Final message
echo "✅ HyperSpace Node setup complete!"
