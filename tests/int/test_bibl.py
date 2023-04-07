import tests
import tests.int
import tests.resources.ids

CITATION = 'Preferred Citation'
FULL = 'Full Citation Information'
ABOUT = 'About this Online Entry'


def test_bibl_1():
    resource = tests.resources.ids.BIBL_1_ID
    result = tests.int.curl(f'/bibl/{resource}')
    assert tests.contains_hx('Bibliographic Record', result), result
    assert ABOUT in result
    assert CITATION in result
    assert FULL in result


NOT_FOUND = 'Could not locate Bibliography'


def test_bibl_failure():
    resource = tests.resources.ids.BIBL_INVALID_ID
    result = tests.int.curl(f'/bibl/{resource}')
    assert tests.contains_hx('Bibliographic Record', result), result
    assert NOT_FOUND in result
    assert ABOUT not in result
    assert CITATION not in result
    assert FULL not in result
