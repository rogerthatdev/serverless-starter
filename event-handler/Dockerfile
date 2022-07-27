FROM python:3.9-slim as python

WORKDIR /app

RUN pip install poetry

RUN poetry config virtualenvs.create false 

COPY pyproject.toml poetry.lock ./

COPY . .

RUN poetry install --no-dev

ENTRYPOINT ["poetry", "run", "gunicorn"]

CMD ["--bind", ":8080", "--workers", "1", "--threads", "8", "--timeout", "0", "event_handler:app"]