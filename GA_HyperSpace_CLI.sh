#!/bin/bash

# Step 1: Install HyperSpace CLI
echo "🚀 Installing HyperSpace CLI..."
curl https://download.hyper.space/api/install | bash

# Step 2: Reload bashrc to make sure the environment is updated
echo "🔄 Reloading .bashrc to apply environment changes..."
source /root/.bashrc

# Step 3: Start the node
echo "🟢 Starting the HyperSpace Node..."
screen -dmS hyperspace aios-cli start
echo "🖥️ Node started in background. You can re-attach using 'screen -r hyperspace'."

# Step 4: Download the required model
echo "🔽 Downloading the required model (phi-2.Q4_K_M.gguf)..."
aios-cli models add hf:TheBloke/phi-2-GGUF:phi-2.Q4_K_M.gguf

# Step 5: Import private key from a file (ensure the private key file exists at './my.pem')
echo "🔑 Importing private key..."
aios-cli hive import-keys ./my.pem

# Step 6: Log in with the imported keys
echo "🔒 Logging into Hive with the imported keys..."
aios-cli hive login

# Step 7: Ensure Hive connection and model registration
echo "🔗 Connecting to Hive and checking model registration..."
aios-cli hive connect

# Step 8: Set Hive Tier to 5 for standard rewards (can be upgraded)
echo "💎 Setting Hive tier to 5..."
aios-cli hive select-tier 5

# Step 9: Optionally upgrade to Tier-3 for better rewards
echo "💡 You can upgrade to Tier-3 for 2x points."
aios-cli hive select-tier 3

# Step 10: Check current points and multiplier
echo "📊 Checking current points and multiplier..."
aios-cli hive points

# Final message
echo "✅ HyperSpace Node setup complete!"
