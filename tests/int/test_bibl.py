import tests.int


def test_bibl_1():
    expected = f'<h1>Bibliography</h1>'
    result = tests.int.curl('/bibl/1')
    assert expected in result
