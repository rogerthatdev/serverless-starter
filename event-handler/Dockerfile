FROM python:3.9-slim as python

WORKDIR /app

RUN pip install poetry

COPY pyproject.toml poetry.lock ./

RUN poetry install --no-root --no-dev

COPY . .

RUN poetry config virtualenvs.create false 

RUN poetry install --no-dev


ENTRYPOINT ["poetry", "run", "gunicorn"]

CMD ["--bind", ":8080", "--workers", "1", "--threads", "8", "--timeout", "0", "event_handler:app"]