import os

import tests
import tests.resources.parser

BIBL_1_PATH = os.path.join(tests.ROOT, 'data/bibl/1.xml')
BIBL_2_PATH = os.path.join(tests.ROOT, 'data/bibl/2.xml')

REQUIRED = [
    BIBL_1_PATH,
    BIBL_2_PATH,
]

for item in REQUIRED:
    assert os.path.exists(item), str(item)

BIBL_1_ID = tests.resources.parser.bibl_id(BIBL_1_PATH)
BIBL_2_ID = tests.resources.parser.bibl_id(BIBL_2_PATH)
BIBL_INVALID_ID = '0'
