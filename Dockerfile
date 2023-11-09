# Using Miniconda as a base image
FROM frolvlad/alpine-miniconda3:latest

# Set the working directory in the container
WORKDIR /home/projects/payme

# Update conda itself to make sure we have the latest version
RUN conda update -n base -c defaults conda

# Create a new conda environment and install Python 3.8
# Combining these steps can reduce the number of layers and use cache more efficiently
RUN conda create -y --name payme_env python=3.8

# Activate the conda environment by setting the PATH environment variable
ENV PATH /opt/conda/envs/payme_env/bin:$PATH

# Install necessary system dependencies for compiling Python packages
RUN apt-get update && apt-get install -y build-essential

# Copy just the requirements.txt first, to cache the dependencies installation
# unless requirements.txt changes
COPY requirements.txt /home/projects/payme/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the current directory contents into the container at /home/projects/payme
# This is done after installing dependencies to avoid invalidating the cache when other files change
COPY . /home/projects/payme

# Make start_me.sh executable
# This can also be done outside the Dockerfile to avoid this layer if start_me.sh is executable in the source already
RUN chmod +x start_me.sh

# Inform Docker that the container is listening on port 8501
EXPOSE 8501

# Run start_me.sh when the container launches
CMD ["/bin/bash", "./start_me.sh"]
