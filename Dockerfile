ARG POETRY_VERSION=1.2.1

from python:3.8-slim as base

from base as tester

RUN curl -sSL https://install.python-poetry.org | python3 - --version $POETRY_VERSION

COPY ./ ./

ENTRYPOINT ["poetry", "run", "py.test", "tests/"]