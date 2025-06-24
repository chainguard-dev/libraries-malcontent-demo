ARG BASE_IMAGE=cgr.dev/chainguard/python:latest-dev
FROM ${BASE_IMAGE}

# Set working directory
WORKDIR /app/src

COPY src/ .

# Install Python project and dependencies using Poetry metadata
RUN pip install --no-cache-dir -e .

CMD ["python", "__init__.py"]
