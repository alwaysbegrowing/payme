# Use an official lightweight Python image as a parent image
FROM arm64v8/python:3.8-slim-buster

# Set the working directory in the container
WORKDIR /home/projects/payme

# Copy the current directory contents into the container at /home/projects/payme
COPY . /home/projects/payme

# Install Miniconda
RUN apt-get update -q && apt-get install -y wget

RUN wget --progress=dot:giga https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh

RUN bash Miniconda3-latest-Linux-aarch64.sh -b -u -p /opt/conda
RUN rm Miniconda3-latest-Linux-aarch64.sh

# Add Conda to PATH
ENV PATH /opt/conda/bin:$PATH

RUN apt-get update -q && apt-get install -y build-essential

# Update Conda
RUN conda update -n base -c defaults conda

# Create a new conda environment with Python 3.8
RUN conda create -y --name payme_env python=3.8

# Activate the conda environment and install the Python dependencies
SHELL ["conda", "run", "-n", "payme_env", "/bin/bash", "-c"]

# Install dependencies from requirements.txt
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Make start.sh executable
RUN chmod +x start.sh

# Inform Docker that the container is listening on port 8501
EXPOSE 8501

# Run start.sh when the container launches
CMD ["./start.sh"]
