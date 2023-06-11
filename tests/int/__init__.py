import os
import re
import urllib.request

import werkzeug.urls

# front end
SERVER = os.environ['SERVER_TEST'].rstrip('/')
# REST API
REST = os.environ['SERVER_REST'].rstrip('/')


def curl(
    path: str,
    optimize: bool = True,
    timeout=5.0,
    plain: bool = False,
):
    """\
    >>> curl('/')
    '...<h1 class="..."> Christian Orient and Byzantine - Digital Humanities </h1>...'
    """
    url = SERVER + path
    url = werkzeug.urls.url_fix(url)
    with urllib.request.urlopen(url, timeout=timeout) as response:  # nosec
        html = response.read()
    html: str = html.decode('utf8')
    if optimize:
        # reduce useless white spaces to ease testing
        html = html.replace('\n', '')
        # reduce multiple white spaces
        html = re.sub(r'[ ]+', ' ', html)
    if plain:
        html = plainme(html)
    return html


REMOVE_FORMATTING = re.compile(r'\</?[ibu]\>')


def plainme(raw: str) -> str:
    """Remove text formatting elements to ease testing.

    >>> plainme('<i>Removed')
    'Removed'
    """
    raw = REMOVE_FORMATTING.sub(
        '',
        raw,
    )
    return raw


def rest(path: str):
    """\
    # TODO: ENABLE LATER
    # >>> rest('/editors')
    # '<tei:listPerson...horn_cornelia...</tei:listPerson>'
    """
    url = REST + path
    with urllib.request.urlopen(url) as response:  # nosec
        html = response.read()
    html: str = html.decode('utf8')
    return html
