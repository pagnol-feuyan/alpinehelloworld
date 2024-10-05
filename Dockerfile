# Grab the latest alpine image
FROM alpine:latest

# Install Python, pip, bash, and other required packages
RUN apk add --no-cache --update python3 py3-pip bash

# Create a Python virtual environment
RUN python3 -m venv /opt/venv

# Set the environment variables to use the virtual environment by default
ENV PATH="/opt/venv/bin:$PATH"

# Copy the requirements file into the container
ADD ./webapp/requirements.txt /tmp/requirements.txt

# Install the dependencies inside the virtual environment
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Add the application code to the container
ADD ./webapp /opt/webapp/
WORKDIR /opt/webapp

# Run the image as a non-root user
RUN adduser -D myuser
USER myuser

# Run the app. CMD is required to run on Heroku
CMD gunicorn --bind 0.0.0.0:$PORT wsgi
