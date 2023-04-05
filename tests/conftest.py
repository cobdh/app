import urllib.error

import cobdh
import pytest

import tests.int


@pytest.mark.usefixtures('session')
def pytest_sessionstart():
    # ensure that server is reachable
    try:
        tests.int.curl('/', timeout=1.0)
    except urllib.error.URLError as error:
        cobdh.error('Could not reach test-server')
        raise SystemExit(cobdh.FAILURE) from error
