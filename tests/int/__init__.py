import os
import urllib.request

# front end
SERVER = os.environ['SERVER_TEST'].rstrip('/')
# REST API
REST = os.environ['SERVER_REST'].rstrip('/')


def curl(path: str):
    """\
    >>> curl('/')
    '...<h1 data-template="config:app-title">cobdh.org data</h1>...'
    """
    url = SERVER + path
    with urllib.request.urlopen(url) as response:
        html = response.read()
    html: str = html.decode('utf8')
    return html


def rest(path: str):
    """\
    >>> rest('/editors')
    '<tei:listPerson...horn_cornelia...</tei:listPerson>'
    """
    url = REST + path
    with urllib.request.urlopen(url) as response:
        html = response.read()
    html: str = html.decode('utf8')
    return html
