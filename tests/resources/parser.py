import cobdh
import cobdh.xmlx.parser

NS = {
    'tei': 'http://www.tei-c.org/ns/1.0',
}
XMLID = '{http://www.w3.org/XML/1998/namespace}id'


def bibl_id(path):
    """\
    >>> import tests.resources
    >>> bibl_id(tests.resources.BIBL_1_PATH)  # adjust test after changing data collection
    'BVCP1990'
    >>> bibl_id(tests.resources.BIBL_10_PATH)
    'Hovhanessian2013'
    """
    content = cobdh.file_read(path)
    data = cobdh.xmlx.parser.parse(content)
    parsed = data.find('.//tei:biblFull', namespaces=NS)
    if not parsed:
        # backup parser
        parsed = data.find('.//tei:biblStruct', namespaces=NS)
    value = parsed.get(XMLID)
    return value


def persons_id(path):
    """\
    >>> import tests.resources
    >>> persons_id(tests.resources.PERSONS_2_PATH)  # adjust test after changing data collection
    'HovhanessianVahan'
    """
    content = cobdh.file_read(path)
    data = cobdh.xmlx.parser.parse(content)
    parsed = data.find('.//tei:person', namespaces=NS)
    value = parsed.get(XMLID)
    return value
