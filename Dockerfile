FROM python:3.9.21-slim
WORKDIR /usr/src/app
COPY requirements.txt requirements.txt
COPY . .
# Command below Installs Python dependencies
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt
EXPOSE 80
ENTRYPOINT [ "streamlit", "run", "app.py", \
    "--server.port", "80", \
    "--server.enableCORS", "true", \
    "--browser.serverAddress", "0.0.0.0", \
    "--browser.serverPort", "443"]