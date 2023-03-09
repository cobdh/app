import tests
import tests.int
import tests.resources


def test_bibl_1():
    resource = tests.resources.BIBL_1_ID
    result = tests.int.curl(f'/bibl/{resource}')
    assert tests.contains_hx('Bibliography Record', result), result
