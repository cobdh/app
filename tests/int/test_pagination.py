import pytest

import tests.int


@pytest.mark.parametrize('collection', (
    'bibl',
    'persons',
))
def test_paging(collection):
    """Ensure that forward and backward button, e.g. pagination is rendered."""
    # use small number to show pagination
    result = tests.int.curl(f'/{collection}?perpage=3')
    assert 'Next' in result
    assert 'Prev' not in result
    result = tests.int.curl(f'/{collection}?start=3&perpage=3')
    assert 'Prev' in result


@pytest.mark.parametrize('collection', (
    'bibl',
    'persons',
))
def test_nopaging(collection):
    """All elements are on the same page."""
    # use large number to hide
    result = tests.int.curl(f'/{collection}?perpage=30000')
    assert 'Next' not in result
