import tests.int

EXPECTED = 3
FAILURE = 'failed. Expected:'


def test_xql():
    result = tests.int.curl('/validation')
    assert 'ERROR' not in result, result
    # increase after adding more unit tests
    assert result.count('OK') >= EXPECTED
    assert not result.count(FAILURE), result
