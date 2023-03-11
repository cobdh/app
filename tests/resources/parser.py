import cobdh
import cobdh.xml.parser

NS = {
    'tei': 'http://www.tei-c.org/ns/1.0',
}


def bibl_id(path):
    """\
    >>> import tests.resources
    >>> bibl_id(tests.resources.BIBL_1_PATH)  # adjust test after changing data collection
    'BVCP1990'
    >>> bibl_id(tests.resources.BIBL_2_PATH)
    'BVCP1995'
    """
    content = cobdh.file_read(path)
    data = cobdh.xml.parser.parse(content)
    parsed = data.find('.//tei:biblFull', namespaces=NS)
    # TODO: FIX LATER
    value = parsed.get('{http://www.w3.org/XML/1998/namespace}id')
    return value
