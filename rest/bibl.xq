xquery version "3.0";

module namespace bibl="https://cobdh.org/rest/bibl";

import module namespace config="https://cobdh.org/config" at "../modules/config.xqm";

import module namespace bibl_data="https://cobdh.org/bibl" at "../modules/bibl.xql";

(: Namespaces :)
declare namespace rest="http://exquery.org/ns/restxq";
declare namespace output="http://www.w3.org/2010/xslt-xquery-serialization";
declare namespace tei="http://www.tei-c.org/ns/1.0";

declare
    %rest:GET
    %rest:path("/bibl")
    %output:method("xml")
function bibl:index_xml(){
    bibl_data:list-items()
};
