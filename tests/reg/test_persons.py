import tests.int
import tests.resources.ids


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
