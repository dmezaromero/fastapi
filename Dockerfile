FROM python:3.11-slim

# Install wkhtmltopdf system dependency (use buster package for compatibility)
RUN apt-get update && \
# Install wkhtmltopdf from source for ARM64/AMD64 compatibility
    apt-get install -y wget build-essential xorg libssl-dev libxrender-dev libjpeg-dev libpng-dev libfreetype6-dev && \
    wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.6/wkhtmltox-0.12.6.tar.xz && \
    tar xf wkhtmltox-0.12.6.tar.xz && \
    cp wkhtmltox-0.12.6/bin/wkhtmltopdf /usr/local/bin/ && \
    rm -rf wkhtmltox-0.12.6* && \
    rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set work directory
WORKDIR /app

# Install dependencies
COPY requirements.txt /app/
RUN pip install --upgrade pip && pip install -r requirements.txt

# Copy project
COPY . /app/

# Expose the port FastAPI will run on
EXPOSE 8000

# Run the FastAPI app with uvicorn
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
