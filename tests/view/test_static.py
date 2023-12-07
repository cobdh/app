import pytest

import tests
import tests.int


@pytest.mark.parametrize('url, expected', [
    pytest.param('/bibl', 'Bibliography'),
    pytest.param('/persons', 'Persons'),
    pytest.param('/editors', 'Editors'),
    pytest.param('/impressum', 'Imprint'),
    pytest.param('/contribution', 'How To Contribute'),
    pytest.param('/validation', 'Validation'),
])
def test_static(url, expected):
    result = tests.int.curl(url)
    assert tests.contains_hx(title=expected, content=result), result


def test_contribution():
    result = tests.int.curl('/contribution')
    assert 'templates/bookSection' in result
