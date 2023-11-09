# Using Miniconda as a base image
FROM continuumio/miniconda3

# Set the working directory in the container
WORKDIR /home/projects/payme

# Copy the current directory contents into the container at /home/projects/payme
COPY . /home/projects/payme

# Create a new conda environment
RUN conda create -y --name payme_env

# Install Python 3.8 in the new environment
RUN conda install -y -c conda-forge python=3.8

# Activate the conda environment and install the Python dependencies
# Note: The --no-input option for pip install does not exist. It should be --no-input for pip and -y for conda.
RUN echo "source activate payme_env" > ~/.bashrc
ENV PATH /opt/conda/envs/payme_env/bin:$PATH
RUN pip install -r requirements.txt

# Make start.sh executable
RUN chmod +x start.sh

# Inform Docker that the container is listening on port 8501
EXPOSE 8501

# Run start.sh when the container launches
CMD ["./start.sh"]
