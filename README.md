# Poetry Namespace Package Error

This repo provides a reproducible example of the possible regression of
[issue #109](https://github.com/python-poetry/poetry/issues/109) in version
1.2.1.

The regression is shown in the [`test_version`](tests/test_cooltest.py#L10)
test. The name of the package is `testdots.cooltest`, but in poetry version
1.2.1 this for some reason gets translated to `testdots-cooltest`.

Example:


```sh
docker build --build-arg POETRY_VERSION=1.1.13 -t poetry-test:1.1.13 .
docker build --build-arg POETRY_VERSION=1.2.1 -t poetry-test:1.2.1 .

$ docker run poetry-test:1.1.13
============================= test session starts ==============================
platform linux -- Python 3.8.14, pytest-7.1.3, pluggy-1.0.0
rootdir: /code
collected 3 items

tests/test_mynamespace.py ...                                            [100%]

============================== 3 passed in 0.04s ===============================

$ docker run poetry-test:1.2.1
============================= test session starts ==============================
platform linux -- Python 3.8.14, pytest-7.1.3, pluggy-1.0.0
rootdir: /code
collected 3 items

tests/test_mynamespace.py .F.                                            [100%]

=================================== FAILURES ===================================
/code/.venv/lib/python3.8/site-packages/pkg_resources/__init__.py:795: pkg_resources.DistributionNotFound: The 'mynamespace.mypackage' distribution was not found and is required by the application
=========================== short test summary info ============================
FAILED tests/test_mynamespace.py::test_version - pkg_resources.DistributionNo...
========================= 1 failed, 2 passed in 0.11s ==========================
```