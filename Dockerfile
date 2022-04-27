# Use an official Python runtime as a parent image
FROM python:3.6-alpine

RUN apk add gcc musl-dev python3-dev libffi-dev openssl-dev cargo

# Set the working directory to /app
WORKDIR /hover-dns-updater

ADD requirements.txt /hover-dns-updater/

# Install any needed packages specified in requirements.txt
RUN pip install --trusted-host pypi.python.org -r requirements.txt && \
    pip install --upgrade flake8 && \
    flake8 --max-line-length 120 . && \
    pip uninstall -y flake8

# Copy the current directory contents into the container at /app
ADD hover-dns-updater.py hover-update.cfg /hover-dns-updater/

RUN apk del gcc musl-dev python3-dev libffi-dev openssl-dev cargo

# Define environment variable
ENV NAME hover-dns-updater

# Run app.py when the container launches
CMD ["python", "hover-dns-updater.py", "--service", "--verbose"]


