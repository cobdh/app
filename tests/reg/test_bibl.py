import re

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
    assert_bibl_record(result)
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
    resource = tests.resources.ids.BIBL_10_ID
    result = tests.int.curl(f'/bibl/{resource}')
    assert_bibl_record(result)
    counted = result.count(pattern)
    assert counted == expected


def assert_bibl_record(content: str):
    assert tests.contains_hx('Bibliographic Record', content), content
    assert ABOUT in content
    assert CITATION in content
    assert FULL in content


def test_bibl_list():
    result = tests.int.curl('/bibl')
    assert tests.contains_hx('Bibliography', result), result
    assert 'More Noncanonical Scriptures. Volume 1' not in result


def test_bibl_list_latin_title():
    """Ensure that Latin/Transcribed title is used instead of arabic one."""
    result = tests.int.curl('/bibl')
    expected = '1987: al-Luʼluʼ al-manthūr fī tārīkh al-ʻulūm wa-al-ādāb al-Suryāniyyah'
    assert expected in result


def test_bibl_title_order():
    result = tests.int.curl('/bibl/Thomson1995')
    assert_bibl_record(result)
    expected = 3
    monogr = result.count('A Bibliography of Classical Armenian Literature')
    assert monogr == expected
    # # TODO: ADD SERIES INFORMATION
    # series = result.find('Corpus Christianorum')
    # # display monograph headline before series headline
    # assert monogr < series


def test_bibl_item_headline():
    """Bibl item starts with transcribed headline."""
    result = tests.int.curl('/bibl/Barsoum1987')
    assert_bibl_record(result)
    expected = 'al-Luʼluʼ al-manthūr fī tārīkh al-ʻulūm wa-al-ādāb al-Suryāniyyah'
    assert tests.contains_hx(expected, result, level=2), result


def test_bibl_editor_link():
    """Ensure that clickable link of editors is displayed."""
    result = tests.int.curl('/bibl/Hovhanessian2013')
    assert '/persons/BauckhamRichard">' in result
    assert '/persons/DavilaJamesR">' in result
    assert '/persons/PanayotovAlexander">' in result


def test_bibl_editor_names():
    """Ensure that clickable link of editors is displayed."""
    result = tests.int.curl('/bibl/Hovhanessian2013')
    assert 'Richard Bauckham' in result
    assert 'James R. Davila' in result
    assert 'Alexander Panayotov' in result


def test_collection_sortedby_year():
    """Ensure that bibl is sorted by date when collection is selected."""
    result = tests.int.curl('/bibl?collection=ar')
    numbers = re.findall(r'(\d{4}):', result)
    numbers = [int(item) for item in numbers]
    assert numbers == sorted(numbers, reverse=True)


@pytest.mark.parametrize('source, expected', [
    ('Muyldermans1946', 'Joseph Muyldermans, "Sur les Séraphins'),
    ('Muyldermans1946', ', vol. 59 (1946), 367-379.'),
    (
        'Hovhanessian2013',
        'edited by Richard Bauckham, James R. Davila and Alexander Panayotov',
    ),
    ('Hovhanessian2013', 'Panayotov (Grand Rapids, Michigan:'),
    (
        'Hovhanessian2013',
        'Publisher: William B. Eerdmans (Grand Rapids, Michigan)',
    ),
    ('Barsoum1991', '(Holland: Bar Hebraeus Verlag, 1991).'),
    ('Barsoum1991', 'Ignatius Afram Barsoum,'),
])
def test_bibl_view_fix_spaces(source, expected):
    result = tests.int.curl(
        f'/bibl/{source}',
        plain=True,
    )
    assert expected in result
