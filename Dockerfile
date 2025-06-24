ARG BASE_IMAGE=cgr.dev/chainguard/python:latest-dev
FROM ${BASE_IMAGE}

WORKDIR /app/
COPY --chown=65532:65532 2024.ultralytics/v8.3.40/ ultralytics/
COPY --chown=65532:65532 main.py .

CMD ["python", "main.py"]
