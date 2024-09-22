# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set environment variables to prevent Python from writing pyc files and enable buffering
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set the working directory inside the container
WORKDIR /app

# Copy the requirements.txt to the container
COPY requirements.txt /app/

# Install the required dependencies
RUN pip install -r requirements.txt

# Copy the rest of the application code to the container
COPY . /app/

# Expose the port the app runs on (optional, if the app runs on a specific port)
EXPOSE 8000

# Command to run the application using gunicorn
CMD ["gunicorn", "quickstartproject.wsgi:application", "--bind", "0.0.0.0:8000"]
