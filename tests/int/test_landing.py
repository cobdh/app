import tests.int


def test_landing_without_cookie():
    result = tests.int.curl('/landing')
    assert 'Armenia' in result
    assert 'Georgia' in result
    assert 'All' in result
