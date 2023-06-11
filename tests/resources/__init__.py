import os

import tests

BIBL_1_PATH = os.path.join(tests.ROOT, 'tests/mini/bibl/1.xml')
BIBL_10_PATH = os.path.join(tests.ROOT, 'tests/mini/bibl/10.xml')

PERSONS_1_PATH = os.path.join(tests.ROOT, 'tests/mini/persons/1.xml')
PERSONS_2_PATH = os.path.join(tests.ROOT, 'tests/mini/persons/2.xml')
PERSONS_4_PATH = os.path.join(tests.ROOT, 'tests/mini/persons/4.xml')
PERSONS_13_PATH = os.path.join(tests.ROOT, 'tests/mini/persons/13.xml')

REQUIRED = [
    BIBL_1_PATH,
    BIBL_10_PATH,
    PERSONS_1_PATH,
    PERSONS_2_PATH,
    PERSONS_4_PATH,
    PERSONS_13_PATH,
]

for item in REQUIRED:
    assert os.path.exists(item), str(item)
