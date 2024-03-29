import tests.int
import tests.resources.ids
from tests.int.test_persons import NOT_FOUND


def test_persons_list_role():
    result = tests.int.curl('/persons')
    # ovid
    expected = 1
    counted = result.count('(poet)')
    assert counted == expected
    # authors of the current age
    expected = 3
    counted = result.count('(author)')
    assert counted >= expected


def test_persons_works_listed():
    person = tests.resources.ids.PERSONS_2_ID
    result = tests.int.curl(f'/persons/{person}')
    # the author has connected works
    assert '>Work<' in result


def test_persons_noworks_listed():
    ovid = tests.resources.ids.PERSONS_1_ID
    result = tests.int.curl(f'/persons/{ovid}')
    # no works inserted
    assert '>Work<' not in result


def test_persons_unicode_xml_id():
    unicode = tests.resources.ids.PERSONS_4_ID
    result = tests.int.curl(f'/persons/{unicode}')
    # no works inserted
    assert '/persons/MaclerFrédéric' in result
    assert NOT_FOUND not in result


def test_persons_no_spaces():
    result = tests.int.curl(f'/persons')
    expected = 'Barsoum Ignatius Afram;'
    assert expected in result


def test_sorting_german():
    """Sort Persons by name and not by "title" if German language is used."""
    result = tests.int.curl(f'/persons?lang=de')
    # sort by name and not by von
    first = 'von Schuler Einar'
    second = 'Thomson Robert W.'
    assert result.find(first) > 0
    assert result.find(second) > 0
    assert result.find(first) < result.find(second)


def test_sorting_english():
    """Sort Persons by title before name if English language is used."""
    result = tests.int.curl(f'/persons?lang=en')
    # sort by name and not by von
    first = 'Thomson Robert W.'
    second = 'von Schuler Einar'
    assert result.find(first) > 0
    assert result.find(second) > 0
    assert result.find(first) < result.find(second)


def test_sorting_forename():
    result = tests.int.curl(f'/persons')
    first = 'von Schuler Albert'
    second = 'von Schuler Einar'
    third = 'von Schuler Ferdinand'
    assert result.find(first) > 0
    assert result.find(second) > 0
    assert result.find(third) > 0
    assert result.find(first) < result.find(second) < result.find(third)
