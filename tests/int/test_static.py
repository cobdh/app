import pytest

import tests.int


@pytest.mark.parametrize('url, expected', [
    pytest.param('/bibs', 'Bibliography'),
    pytest.param('/persons', 'Persons'),
    pytest.param('/editors', 'Editors'),
    pytest.param('/impressum', 'Impressum'),
    pytest.param('/contribution', 'How To Contribute'),
    pytest.param('/validation', 'Validation'),
])
def test_static(url, expected):
    expected = f'<h1>{expected}</h1>'
    result = tests.int.curl(url)
    assert expected in result
