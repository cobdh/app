xquery version "3.0";

module namespace bibl="https://data.cobdh.org/bibl";

import module namespace config="https://data.cobdh.org/config" at "../modules/config.xqm";

(: Namespaces :)
declare namespace rest="http://exquery.org/ns/restxq";
declare namespace output="http://www.w3.org/2010/xslt-xquery-serialization";
declare namespace tei="http://www.tei-c.org/ns/1.0";

(: Global Variables:)
declare variable $bibl:data := $config:app-root || "/data/bibl";

declare
    %rest:GET
    %rest:path("/bibl")
    %output:method("xml")
function bibl:index_xml() {
    bibl:list-items()
};

declare function bibl:list-items(){
    <tei:listBibl>
    {
        for $item in collection($bibl:data)/tei:TEI
        return
            $item
    }
    </tei:listBibl>
};
