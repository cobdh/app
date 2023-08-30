import tests
import tests.int


def test_bibl_lang_en_de():
    result = tests.int.curl('/bibl')
    assert tests.contains_hx('Bibliography', result)
    assert not tests.contains_hx('Bibliographie', result)
    # translate it to German
    result = tests.int.curl('/bibl?lang=de')
    assert tests.contains_hx('Bibliographie', result)


def test_button_default():
    """Verify the function of the language select button at the bottom of
    the page. The default language is English."""
    result = tests.int.curl('/')
    assert 'aria-expanded="false">English</button>' in result
    assert 'href="?lang=en">English</a>' not in result
    # a change to German is possible
    assert 'href="?lang=de">German</a>' in result


def test_button_lang_de():
    result = tests.int.curl('/?lang=de')
    assert 'aria-expanded="false">German</button>' in result
    assert 'href="?lang=en">English</a>' in result
    assert 'href="?lang=de">German</a>' not in result
