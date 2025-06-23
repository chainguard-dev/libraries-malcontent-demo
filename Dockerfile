ARG BASE_IMAGE=cgr.dev/chainguard/python:latest-dev
FROM ${BASE_IMAGE}

# Set working directory
WORKDIR /app/src

COPY src/ /app/src/
COPY malcontent-samples/python/2024.ultralytics/v8.3.40/ ultralytics/

# Install Python project and dependencies using Poetry metadata
RUN pip install --no-cache-dir -e .

CMD ["python", "__init__.py"]
