# Use the balena Conda image as a parent image
FROM ryanfobel/raspberrypi4-64-conda

# Set the working directory in the container
WORKDIR /home/projects/payme

# Copy the current directory contents into the container at /home/projects/payme
COPY . /home/projects/payme

# Assuming that the base image does not need these steps:
# RUN apt-get update -q && apt-get install -y wget
# RUN wget --progress=dot:giga https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh
# RUN bash Miniconda3-latest-Linux-aarch64.sh -b -u -p /opt/conda
# RUN rm Miniconda3-latest-Linux-aarch64.sh

# The PATH environment variable should already be set in the base image, but if it's not, you can uncomment and adjust the following line:
# ENV PATH /root/miniforge3/bin:$PATH

# Install dependencies from requirements.txt
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Make start.sh executable
RUN chmod +x start.sh

# Inform Docker that the container is listening on port 8501
EXPOSE 8501

# Run start.sh when the container launches
CMD ["./start.sh"]
