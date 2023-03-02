import tests
import tests.int


def test_bibl_lang_en_de():
    result = tests.int.curl('/bibl')
    assert tests.contains_hx('Bibliography', result)
    assert not tests.contains_hx('Bibliographie', result)
    # translate it to German
    result = tests.int.curl('/bibl?lang=de')
    assert tests.contains_hx('Bibliographie', result)
