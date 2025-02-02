#!/bin/bash

# Step 1: Install HyperSpace CLI
echo "🚀 Installing HyperSpace CLI..."
curl https://download.hyper.space/api/install | bash

# Step 2: Reload bashrc to make sure the environment is updated
echo "🔄 Reloading .bashrc to apply environment changes..."
source /root/.bashrc

# Step 3: Create a screen session to run the node in the background
echo "🎥 Creating a screen session for Hyperspace..."
screen -S hyperspace -d -m

# Step 4: Start the Hyperspace node inside the screen session
echo "🚀 Starting the Hyperspace node in the screen session..."
screen -S hyperspace -X stuff "aios-cli start\n"

# Step 5: Wait for the node to initialize and be ready (you can adjust the sleep time if necessary)
echo "⏳ Waiting for the node to start..."
sleep 10 # Adjust time if needed to give the node enough time to start

# Step 6: Download the model (this will run in the same screen session)
echo "🔄 Downloading the required model..."
screen -S hyperspace -X stuff "aios-cli models add hf:TheBloke/phi-2-GGUF:phi-2.Q4_K_M.gguf\n"

# Step 7: Display the status of the screen session
echo "✅ Model download command sent to the screen session."

# Step 8: Ask for the private key to import and save it automatically
echo "🔑 Please provide your private key. It will be saved in the 'my.pem' file."

# Prompt user to enter the private key
echo "Enter your private key below:"

# Save the private key entered by the user directly to the my.pem file
cat > /root/my.pem

echo "✅ Private key saved to /root/my.pem"

# Step 9: Import the private key and login to Hive
echo "🔑 Importing your private key..."
aios-cli hive import-keys ./my.pem

echo "🔐 Logging into Hive..."
aios-cli hive login

echo "🌐 Connecting to Hive..."
aios-cli hive connect

# Step 10: Set the tier level
echo "🏆 Setting your Hive tier to 3..."
aios-cli hive select-tier 3

# Step 11: Check points (optional)
echo "📊 To check your current Hive points, use the following command:"
echo "aios-cli hive points"

# Step 12: Final message
echo "✅ HyperSpace Node setup complete!"
