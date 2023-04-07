import tests.int


def test_persons_paging():
    # use small number to show pagination
    result = tests.int.curl(f'/persons?perpage=3')
    assert 'Next' in result
    assert 'Prev' not in result
    result = tests.int.curl(f'/persons?start=3&perpage=3')
    assert 'Prev' in result


def test_persons_nopaging():
    # use large number to hide
    result = tests.int.curl(f'/persons?perpage=30000')
    assert 'Next' not in result
