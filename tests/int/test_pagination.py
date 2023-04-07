import pytest

import tests.int


@pytest.mark.parametrize('collection', (
    'bibl',
    'persons',
    'search?bibl_keyword=a',
))
def test_paging(collection):
    """Ensure that forward and backward button, e.g. pagination is rendered."""
    # use small number to show pagination
    quote = '?' if '?' not in collection else '&'
    result = tests.int.curl(f'/{collection}{quote}perpage=3')
    assert 'Next' in result
    assert 'Prev' not in result
    result = tests.int.curl(f'/{collection}{quote}start=3&perpage=3')
    assert 'Prev' in result


@pytest.mark.parametrize('collection', (
    'bibl',
    'persons',
    'search?bibl_keyword=a',
))
def test_nopaging(collection):
    """All elements are on the same page."""
    # use large number to hide
    result = tests.int.curl(f'/{collection}?perpage=30000')
    assert 'Next' not in result
