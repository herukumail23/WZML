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
RUN apt update && apt install -y \
    wget \
    curl \
    ca-certificates \
    fonts-liberation \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libdbus-1-3 \
    libdrm2 \
    libgbm1 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libx11-xcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxrandr2 \
    libxshmfence1 \
    libxss1 \
    libxtst6 \
    xdg-utils \
    && rm -rf /var/lib/apt/lists/*

# Copy project files
COPY . .

# Run bot
CMD ["python", "bot.py"]
