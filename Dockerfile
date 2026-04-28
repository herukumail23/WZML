FROM anasty17/mltb:latest

# Working directory
WORKDIR /usr/src/app

# System dependencies (important for your libs)
RUN apt update && apt install -y \
    ffmpeg \
    aria2 \
    mediainfo \
    && rm -rf /var/lib/apt/lists/*

# Create virtual environment
RUN python3 -m venv /venv

# Activate venv
ENV PATH="/venv/bin:$PATH"

# Upgrade pip inside venv
RUN pip install --upgrade pip

# Copy requirements
COPY requirements.txt .

# Install Python packages inside venv
RUN pip install --no-cache-dir -r requirements.txt

# Install playwright stuff
RUN playwright install chromium
RUN playwright install-deps

# Copy project files
COPY . .

# Run bot
CMD ["bash", "start.sh"]
