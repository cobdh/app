import os

import tests

BIBL_1_PATH = os.path.join(tests.ROOT, 'data/bibl/1.xml')
BIBL_2_PATH = os.path.join(tests.ROOT, 'data/bibl/2.xml')

PERSONS_1_PATH = os.path.join(tests.ROOT, 'data/persons/1.xml')

REQUIRED = [
    BIBL_1_PATH,
    BIBL_2_PATH,
    PERSONS_1_PATH,
]

for item in REQUIRED:
    assert os.path.exists(item), str(item)