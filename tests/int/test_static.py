import re

import pytest

import tests.int


@pytest.mark.parametrize('url, expected', [
    pytest.param('/bibl', 'Bibliography'),
    pytest.param('/persons', 'Persons'),
    pytest.param('/editors', 'Editors'),
    pytest.param('/impressum', 'Impressum'),
    pytest.param('/contribution', 'How To Contribute'),
    pytest.param('/validation', 'Validation'),
])
def test_static(url, expected):
    # add optional white spaces \s* to make check more robust against white
    # spaces which are introduced by translation module.
    expected = rf'<h1>\s*{expected}\s*</h1>'
    result = tests.int.curl(url)
    assert re.search(expected, result), result
