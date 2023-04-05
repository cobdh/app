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
):
    """\
    >>> curl('/')
    '...<h1 data-template="config:app-title">cobdh.org data</h1>...'
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
    return html


def rest(path: str):
    """\
    >>> rest('/editors')
    '<tei:listPerson...horn_cornelia...</tei:listPerson>'
    """
    url = REST + path
    with urllib.request.urlopen(url) as response:  # nosec
        html = response.read()
    html: str = html.decode('utf8')
    return html
