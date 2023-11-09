# Use an official lightweight Python image as a parent image
FROM arm64v8/python:3.8-slim-buster

# Set the working directory in the container
WORKDIR /home/projects/payme

# Copy the current directory contents into the container at /home/projects/payme
COPY . /home/projects/payme

# Install required system packages
RUN apt-get update -q && apt-get install -y wget curl build-essential

# Download and install Miniforge
RUN curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh" && \
    bash Miniforge3-$(uname)-$(uname -m).sh -b -u -p /opt/conda && \
    rm Miniforge3-$(uname)-$(uname -m).sh

# Add Conda to PATH
ENV PATH /opt/conda/bin:$PATH

# Update Conda and install Mamba, a fast, drop-in replacement for conda
RUN conda update -n base -c defaults conda && \
    conda install mamba -n base -c conda-forge

# Create a new conda environment with Python 3.8
RUN conda create -y --name payme_env python=3.8

# Activate the conda environment and install the Python dependencies
SHELL ["conda", "run", "-n", "payme_env", "/bin/bash", "-c"]

# Install dependencies from requirements.txt
COPY requirements.txt .
RUN mamba install --file requirements.txt --yes

# Make start.sh executable
RUN chmod +x start.sh

# Inform Docker that the container is listening on port 8501
EXPOSE 8501

# Run start.sh when the container launches
CMD ["./start.sh"]
