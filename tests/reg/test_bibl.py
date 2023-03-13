import pytest

import tests
import tests.int
import tests.resources.ids

CITATION = 'Preferred Citation'
FULL = 'Full Citation Information'
ABOUT = 'About this Online Entry'


def test_bibl_biblfull():
    resource = tests.resources.ids.BIBL_1_ID
    result = tests.int.curl(f'/bibl/{resource}')
    assert tests.contains_hx('Bibliography Record', result), result
    assert ABOUT in result
    assert CITATION in result
    assert FULL in result
    # a single hyperlink in the header of the bib item
    expected = 1
    counted = result.count('https://cobdh.org/bibl/BVCP1990')
    assert counted == expected


@pytest.mark.parametrize('pattern, expected', [
    ('https://cobdh.org/bibl/Hovhanessian2013', 2),
    ('Editor:', 3),
    ('Author:', 1),
    ('Date of Publication: 2013', 1),
    ('Pages: 326-345', 1),
    ('Publisher: William B. Eerdmans', 1),
    ('Zotero:', 1),
])
def test_bibl_struct(pattern, expected):
    resource = tests.resources.ids.BIBL_2_ID
    result = tests.int.curl(f'/bibl/{resource}')
    assert tests.contains_hx('Bibliography Record', result), result
    assert ABOUT in result
    assert CITATION in result
    assert FULL in result
    counted = result.count(pattern)
    assert counted == expected
