import tests
import tests.int


def test_bibl_1():
    result = tests.int.curl('/bibl/1')
    assert tests.contains_hx('Bibliography Record', result), result
