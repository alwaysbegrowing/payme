# Use the balena Conda image as a parent image
FROM ryanfobel/raspberrypi4-64-conda

# Set the working directory in the container
WORKDIR /home/projects/payme

# Install dependencies from requirements.txt first to leverage Docker cache
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Install Node.js (if not already installed) and nodemon
# Uncomment and modify the following lines if Node.js is not present in the base image
# RUN apt-get update -q && apt-get install -y nodejs npm
RUN npm install -g nodemon

# Copy the rest of the project files
COPY . /home/projects/payme

# Make start.sh executable
RUN chmod +x start.sh

# Inform Docker that the container is listening on port 8501
EXPOSE 8501

# Run start.sh using nodemon when the container launches
CMD ["nodemon", "--exec", "bash", "start.sh"]
