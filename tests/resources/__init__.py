import os

import cobdh
import cobdh.xml.parser

import tests

BIBL_1_PATH = os.path.join(tests.ROOT, 'data/bibl/1.xml')
BIBL_2_PATH = os.path.join(tests.ROOT, 'data/bibl/2.xml')

REQUIRED = [
    BIBL_1_PATH,
    BIBL_2_PATH,
]

for item in REQUIRED:
    assert os.path.exists(item), str(item)

NS = {
    'tei': 'http://www.tei-c.org/ns/1.0',
}


def bibl_id(path):
    """\
    >>> bibl_id(BIBL_1_PATH)  # adjust test after changing data collection
    'BVCP1990'
    >>> bibl_id(BIBL_2_PATH)
    'BVCP1995'
    """
    content = cobdh.file_read(path)
    data = cobdh.xml.parser.parse(content)
    parsed = data.find('.//tei:biblFull', namespaces=NS)
    # TODO: FIX LATER
    value = parsed.get('{http://www.w3.org/XML/1998/namespace}id')
    return value


BIBL_1_ID = bibl_id(BIBL_1_PATH)
BIBL_2_ID = bibl_id(BIBL_2_PATH)
BIBL_INVALID_ID = '0'
