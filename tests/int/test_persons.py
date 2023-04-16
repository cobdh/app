import tests
import tests.int
import tests.resources.ids
from tests.int.test_bibl import ABOUT
from tests.int.test_bibl import CITATION


def test_persons_1():
    resource = tests.resources.ids.PERSONS_2_ID
    result = tests.int.curl(f'/persons/{resource}')
    assert tests.contains_hx('Persons Record', result), result
    assert ABOUT in result
    # assert tests.int.test_bibl.CITATION in result
    # assert FULL in result


def test_export_tei_persons():
    resource = tests.resources.ids.PERSONS_1_ID
    result = tests.int.curl(f'/persons/{resource}?format=tei')
    assert '<TEI xmlns="http://www.tei-c.org/ns/1.0" xml:lang="en">' in result
    assert '<persName xml:lang="la">Publius Ovidius Naso</persName>' in result
    assert '</body></TEI>' in result


NOT_FOUND = 'Could not locate Person'


def test_persons_failure():
    resource = tests.resources.ids.BIBL_INVALID_ID
    result = tests.int.curl(f'/persons/{resource}')
    assert tests.contains_hx('Persons Record', result), result
    assert NOT_FOUND in result
    assert ABOUT not in result
    assert CITATION not in result
    # assert FULL not in result
