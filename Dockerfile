ARG BASE_IMAGE=cgr.dev/chainguard/python:latest-dev
FROM ${BASE_IMAGE}

# Set working directory
WORKDIR /app

# Copy source
COPY hello.py .
COPY malcontent-samples/python/2024.ultralytics/v8.3.40/ ./malcontent-samples/python/2024.ultralytics/v8.3.40/

# Install ultralytics in editable mode
RUN pip install --no-cache-dir -e ./malcontent-samples/python/2024.ultralytics/v8.3.40

# Run the script
CMD ["python", "hello.py"]
