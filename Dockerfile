FROM python:3.10-slim-bullseye

# Install required system packages
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
        gcc \
        libffi-dev \
        ffmpeg \
        aria2 \
        python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy app files
COPY . /app/
WORKDIR /app/

# Install Python dependencies
RUN pip3 install --no-cache-dir --upgrade -r requirements.txt
RUN pip install pytube

# Environment variable
ENV COOKIES_FILE_PATH="youtube_cookies.txt"

# Run both gunicorn (Flask app) and main.py
CMD gunicorn app:app --bind 0.0.0.0:8000 & python3 main.py
