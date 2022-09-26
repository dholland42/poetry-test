ARG POETRY_VERSION=1.2.1

from python:3.8-slim as base

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

RUN apt-get update && apt-get install -y --no-install-recommends curl

from base as tester

ARG POETRY_VERSION=1.2.1

RUN curl -sSL https://install.python-poetry.org | POETRY_HOME=/opt/poetry python3 - --version $POETRY_VERSION

ENV PATH /opt/poetry/bin:$PATH

WORKDIR /code

COPY ./ ./

RUN poetry install

ENTRYPOINT ["poetry", "run", "py.test", "--tb=line", "tests/"]