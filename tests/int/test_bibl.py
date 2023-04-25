import re

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


def test_export_tei_bibl():
    resource = tests.resources.ids.BIBL_1_ID
    result = tests.int.curl(f'/bibl/{resource}?format=tei')
    assert '<TEI xmlns="http://www.tei-c.org/ns/1.0" xml:lang="en">' in result
    assert '<biblFull xml:id="BVCP1990">' in result
    assert '</body></TEI>' in result


def test_bibl_sortedby_year():
    """Ensure that bibl is sorted by date."""
    result = tests.int.curl('/bibl')
    numbers = re.findall(r'(\d{4}):', result)
    numbers = [int(item) for item in numbers]
    assert numbers == sorted(numbers, reverse=True)
