ARG BASE_IMAGE=cgr.dev/chainguard/python:latest-dev
FROM ${BASE_IMAGE}

COPY src/ /app/src/
COPY malcontent-samples/python/2024.ultralytics/v8.3.40/ /app/src/malcontent-samples/python/2024.ultralytics/v8.3.40/
WORKDIR /app/src

# # Install ultralytics in editable mode
# RUN pip install --no-cache-dir -e ./malcontent-samples/python/2024.ultralytics/v8.3.40

RUN pip install --no-cache-dir -e .

CMD ["python", "init-ultralytics.py"]
