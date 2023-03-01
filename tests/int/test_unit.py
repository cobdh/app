import tests.int

EXPECTED = 2


def test_xql():
    result = tests.int.curl('/validation')
    assert 'ERROR' not in result, result
    # increase after adding more unit tests
    assert result.count('OK') == EXPECTED
