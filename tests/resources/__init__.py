import os

import tests

BIBL_1_PATH = os.path.join(tests.ROOT, 'tests/mini/bibl/1.xml')
BIBL_2_PATH = os.path.join(tests.ROOT, 'tests/mini/bibl/10.xml')

PERSONS_1_PATH = os.path.join(tests.ROOT, 'tests/mini/persons/2.xml')

REQUIRED = [
    BIBL_1_PATH,
    BIBL_2_PATH,
    PERSONS_1_PATH,
]

for item in REQUIRED:
    assert os.path.exists(item), str(item)
