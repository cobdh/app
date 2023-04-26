import tests
import tests.int


def test_editors_schewe_helmut_kornad():
    result = tests.int.curl('/editors/schewe_helmut_konrad')
    assert tests.contains_hx('Editor Record', result), result
    assert 'Schewe' in result, result
    assert tests.contains_hx('Edited', result, 3), result
    assert tests.contains_hx('XML coded', result, 3), result


def test_editors_phenix():
    result = tests.int.curl('/editors/phenix_robert')
    assert tests.contains_hx('Editor Record', result), result
    assert 'Phenix' in result, result
