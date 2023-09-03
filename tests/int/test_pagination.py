import pytest

import tests.int

NEXT = '»'
PREV = '«'


@pytest.mark.parametrize('collection', (
    'bibl',
    'persons',
    'search?bibl_keyword=a',
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
    'search?bibl_keyword=a',
    'search?person_keyword=a*',
))
def test_nopaging(collection):
    """All elements are on the same page."""
    # use large number to hide
    result = tests.int.curl(f'/{collection}?perpage=30000')
    assert NEXT not in result
