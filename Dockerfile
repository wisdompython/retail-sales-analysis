FROM python:3.12.9-slim
WORKDIR /usr/src/app

COPY requirements.txt requirements.txt

# Command below Installs Python dependencies
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

COPY ./dashboards .
COPY .env .

EXPOSE 8501

ENTRYPOINT [ "streamlit", "run", "app.py", \
    "--server.port", "8501", \
    "--server.enableCORS", "true"]

    # "--browser.serverAddress", "0.0.0.0", \
    # "--browser.serverPort", "443"