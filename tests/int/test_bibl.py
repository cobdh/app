import tests
import tests.int
import tests.resources

CITATION = 'Preferred Citation'
FULL = 'Full Citation Information'
ABOUT = 'About this Online Entry'


def test_bibl_1():
    resource = tests.resources.BIBL_1_ID
    result = tests.int.curl(f'/bibl/{resource}')
    assert tests.contains_hx('Bibliography Record', result), result
    assert ABOUT in result
    assert CITATION in result
    assert FULL in result
