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
