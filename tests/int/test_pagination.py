import pytest

import tests.int

NEXT = '»'
PREV = '«'


@pytest.mark.parametrize('collection', (
    'bibl',
    'persons',
    'search?bibl_keyword=a*',
    'search?person_keyword=a*',
))
def test_paging(collection):
    """Ensure that forward and backward button, e.g. pagination is rendered."""
    # use small number to show pagination
    quote = '?' if '?' not in collection else '&'
    result = tests.int.curl(f'/{collection}{quote}perpage=3')
    assert NEXT in result
    assert PREV not in result
    result = tests.int.curl(f'/{collection}{quote}start=3&perpage=3')
    assert PREV in result


@pytest.mark.parametrize('collection', (
    'bibl',
    'persons',
    'search?bibl_keyword=a*',
    'search?person_keyword=a*',
))
def test_nopaging(collection):
    """All elements are on the same page."""
    # use large number to hide
    char = '&' if '?' in collection else '?'
    result = tests.int.curl(f'/{collection}{char}perpage=30000')
    # class="alert alert-danger"
    # operation does not work, therefore the test is false negative
    assert 'alert' not in result
    assert 'danger' not in result
    assert NEXT not in result
