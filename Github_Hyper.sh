#!/bin/bash

# Step 0: Creating the GaHyperSpace Screen and running the script inside it
echo "🚀 Starting the Initial Screen and executing all steps inside it..."
screen -S GaHyperSpace -dm bash

# Attach to the screen and run the script interactively
screen -S GaHyperSpace -X stuff $'#!/bin/bash\n'

# Step 1: Install HyperSpace CLI
screen -S GaHyperSpace -X stuff $'echo "🚀 Installing HyperSpace CLI..."\n'
screen -S GaHyperSpace -X stuff $'curl https://download.hyper.space/api/install | bash\n'

# Step 2: Add the aios-cli path to .bashrc
screen -S GaHyperSpace -X stuff $'echo "🔄 Adding aios-cli path to .bashrc..."\n'
screen -S GaHyperSpace -X stuff $'export PATH=$PATH:~/.aios\n'

# Step 3: Reload .bashrc to apply environment changes
screen -S GaHyperSpace -X stuff $'echo "🔄 Reloading .bashrc..."\n'
screen -S GaHyperSpace -X stuff $'source ~/.bashrc\n'

# Step 5: Start Hyperspace node
screen -S GaHyperSpace -X stuff $'echo "🚀 Starting the Hyperspace node..."\n'
screen -S GaHyperSpace -X stuff $'/root/.aios/aios-cli start\n'

# Step 6: Wait for the node to start
screen -S GaHyperSpace -X stuff $'echo "⏳ Waiting for the Hyperspace node to start..."\n'
screen -S GaHyperSpace -X stuff $'sleep 10\n'

# Step 7: Check the node status
screen -S GaHyperSpace -X stuff $'echo "🔍 Checking node status..."\n'
screen -S GaHyperSpace -X stuff $'/root/.aios/aios-cli status\n'

# Step 8: Proceed with downloading the required model
screen -S GaHyperSpace -X stuff $'echo "🔄 Downloading the required model..."\n'
screen -S GaHyperSpace -X stuff $'aios-cli models add hf:TheBloke/phi-2-GGUF:phi-2.Q4_K_M.gguf 2>&1 | tee /root/model_download.log\n'

# Step 9: Verify if the model was downloaded successfully
screen -S GaHyperSpace -X stuff $'if grep -q "Download complete" /root/model_download.log; then\n'
screen -S GaHyperSpace -X stuff $'    echo "✅ Model downloaded successfully!"\n'
screen -S GaHyperSpace -X stuff $'else\n'
screen -S GaHyperSpace -X stuff $'    echo "❌ Model download failed. Check /root/model_download.log for details."\n'
screen -S GaHyperSpace -X stuff $'    exit 1\n'
screen -S GaHyperSpace -X stuff $'fi\n'

# Step 10: Import the private key
screen -S GaHyperSpace -X stuff $'echo "🔑 Enter your private key:"\n'
screen -S GaHyperSpace -X stuff $'read -p "Private Key: " private_key\n'
screen -S GaHyperSpace -X stuff $'echo $private_key > /root/my.pem\n'
screen -S GaHyperSpace -X stuff $'echo "✅ Private key saved to /root/my.pem"\n'

# Step 11: Import the private key into Hive
screen -S GaHyperSpace -X stuff $'aios-cli hive import-keys /root/my.pem\n'

# Step 12: Log in to Hive
screen -S GaHyperSpace -X stuff $'echo "🔐 Logging into Hive..."\n'
screen -S GaHyperSpace -X stuff $'aios-cli hive login\n'

# Step 13: Connect to Hive
screen -S GaHyperSpace -X stuff $'echo "🌐 Connecting to Hive..."\n'
screen -S GaHyperSpace -X stuff $'aios-cli hive connect\n'

# Step 14: Set Hive Tier
screen -S GaHyperSpace -X stuff $'echo "🏆 Setting your Hive tier to 3..."\n'
screen -S GaHyperSpace -X stuff $'aios-cli hive select-tier 3\n'

# Step 15: Start checking Hive points every 10 seconds
screen -S GaHyperSpace -X stuff $'echo "📊 Checking your current Hive points every 10 seconds..."\n'
screen -S GaHyperSpace -X stuff $'while :; do\n'
screen -S GaHyperSpace -X stuff $'    aios-cli hive points\n'
screen -S GaHyperSpace -X stuff $'    sleep 10\n'
screen -S GaHyperSpace -X stuff $'done\n'

# Attach the screen to show live output
screen -r GaHyperSpace
