(:~
    Author: Helmut Konrad Schewe <helmutus@outlook.com>

    This is an example module to describe how unit testing in xqsuite test
    framework works.
 :)

xquery version "3.0";

module namespace m="https://data.cobdh.org/sample/unittests";

declare namespace test="http://exist-db.org/xquery/xqsuite";

declare
    %test:arg("n", 1)
    %test:assertEquals(1)

    %test:arg("n", 5)
    %test:assertEquals(120)
function m:factorial($n as xs:int) as xs:int {
    if ($n = 1) then
        1
    else
        $n * m:factorial($n - 1)
};
