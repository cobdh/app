import os
import re

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))


def contains_hx(title: str, content: str, level: int = 1) -> bool:
    """\
    >>> contains_hx('ueberschrift', 'Before <h1 class="...">  ueberschrift </h1>More text')
    True
    """
    # add optional white spaces \s* to make check more robust against white
    # spaces which are introduced by translation module.
    expected = rf'<h{level}( class=\".+\")?>\s*{title}\s*</h{level}>'
    if re.search(expected, content):
        return True
    return False
