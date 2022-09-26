# Poetry Namespace Package Error

This repo provides a reproducible example of the possible regression of
[issue #109](https://github.com/python-poetry/poetry/issues/109) in version
1.2.1.

The regression is shown in the [`test_version`](tests/test_mynamespace.py#L10)
test. The name of the package is `testdots.cooltest`, but in poetry version
1.2.1 this for some reason gets translated to `testdots-cooltest`, with the dot
being replaced with a dash somewhere in the installation process.

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

It can also be seen that the name is changed in the wheel file when performing a
`poetry build`:

```sh
root@b6dc891939b0:/code# poetry build
Building mynamespace.mypackage (0.1.0)
  - Building sdist
  - Built mynamespace.mypackage-0.1.0.tar.gz
  - Building wheel
  - Built mynamespace_mypackage-0.1.0-py3-none-any.whl
root@b6dc891939b0:/code# pip install -q dist/mynamespace_mypackage-0.1.0-py3-none-any.whl 
WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv
WARNING: You are using pip version 22.0.4; however, version 22.2.2 is available.
You should consider upgrading via the '/usr/local/bin/python -m pip install --upgrade pip' command.
root@b6dc891939b0:/code# pip show mynamespace.mypackage
Name: mynamespace-mypackage
Version: 0.1.0
Summary: 
Home-page: 
Author: Your Name
Author-email: you@example.com
License: 
Location: /usr/local/lib/python3.8/site-packages
Requires: flake8, pytest
Required-by: 
```