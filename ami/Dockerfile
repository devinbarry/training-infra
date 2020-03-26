FROM python:3.7.6-buster

ENV PYTHONUNBUFFERED 1

COPY requirements.txt /requirements.txt
RUN pip install --upgrade pip

# Don't cache installers to reduce image size
RUN pip install --no-cache-dir -r /requirements.txt

WORKDIR /app
