FROM python:3.9-slim as python
WORKDIR /app

RUN pip install poetry

COPY pyproject.toml poetry.lock ./

RUN poetry install --no-root --no-dev

COPY . .
RUN poetry config virtualenvs.create false 
RUN poetry install --no-dev
# Copy local code to the container image.

EXPOSE 8000
# Run the web service on container startup. Here we use the gunicorn
# webserver, with one worker process and 8 threads.
# For environments with multiple CPU cores, increase the number of workers
# to be equal to the cores available.
# Timeout is set to 0 to disable the timeouts of the workers to allow Cloud Run to handle instance scaling.

# ENV FLASK_APP="event_handler"
# RUN ls -alh
# CMD exec poetry run flask run 
CMD exec poetry run gunicorn event_handler:app