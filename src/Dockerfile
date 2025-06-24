ARG BASE_IMAGE=cgr.dev/chainguard/python:latest-dev
FROM ${BASE_IMAGE}

COPY --chown=65532:65532 ultralytics/ ultralytics/
COPY --chown=65532:65532 main.py .

CMD ["python", "main.py"]
