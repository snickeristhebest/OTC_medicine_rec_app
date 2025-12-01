FROM python:3.10-slim

WORKDIR /app

# Install OS deps
RUN apt-get update && apt-get install -y build-essential git && rm -rf /var/lib/apt/lists/*

# Install Python deps
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

# Copy server code
COPY . .

ENV PORT 8080
CMD ["gunicorn", "-b", "0.0.0.0:8080", "app:app"]
