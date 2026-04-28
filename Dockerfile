# -------- BASE IMAGE --------
FROM python:3.10-slim

# -------- ENV SETTINGS --------
ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    DEBIAN_FRONTEND=noninteractive

# -------- WORKDIR --------
WORKDIR /app

# -------- SYSTEM DEPENDENCIES --------
RUN apt update && apt install -y --no-install-recommends \
    ffmpeg \
    aria2 \
    mediainfo \
    git \
    curl \
    wget \
    ca-certificates \
    libnss3 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libx11-xcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libgbm1 \
    libasound2 \
    libxshmfence1 \
    libxss1 \
    fonts-liberation \
    && rm -rf /var/lib/apt/lists/*

# -------- CREATE VENV --------
RUN python -m venv /venv
ENV PATH="/venv/bin:$PATH"

# -------- FIX PIP + SETUPTOOLS (pkg_resources fix) --------
RUN python -m ensurepip --upgrade \
 && pip install --upgrade pip wheel \
 && pip install --force-reinstall setuptools

# -------- INSTALL REQUIREMENTS --------
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# -------- PLAYWRIGHT (SAFE INSTALL) --------
RUN pip install playwright \
 && playwright install chromium

# -------- COPY PROJECT FILES --------
COPY . .

# -------- RUN BOT (FORCE VENV PYTHON) --------
CMD ["/venv/bin/python", "-m", "bot"]
