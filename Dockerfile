# base python with curl so we can get poetry
from python:3.8-slim as base

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

RUN apt-get update && apt-get install -y --no-install-recommends curl

# define image to run our tests in
from base as tester

# install the requisite version of poetry
ARG POETRY_VERSION=1.2.1
RUN curl -sSL https://install.python-poetry.org | POETRY_HOME=/opt/poetry python3 - --version $POETRY_VERSION
ENV PATH /opt/poetry/bin:$PATH

WORKDIR /code

# install dependencies
COPY pyproject.toml poetry.lock poetry.toml ./
RUN poetry install --no-root

# install our code
COPY mynamespace/ ./mynamespace/
COPY tests/ ./tests/
COPY README.md .
RUN poetry install

# run the tests
ENTRYPOINT ["poetry", "run", "py.test", "--tb=line", "tests/"]