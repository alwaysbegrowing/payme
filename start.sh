#!/bin/bash

# Ensure that the conda command is available
source /root/miniforge3/etc/profile.d/conda.sh

# Activate the conda environment. You may need to adjust the name of your conda environment.
conda activate payme_env

# Assuming your code is in the /home/projects/payme directory based on your Dockerfile.
cd /home/projects/payme || exit

streamlit run apps/main.py --server.port 8501

echo "Running apps/main.py on port 8501!"
