xquery version "3.0";

(:
 : Defines all the RestXQ endpoints used by the XForms.
 :)
module namespace editors="https://data.cobdh.org/rest/editors";

import module namespace config="https://data.cobdh.org/config" at "../modules/config.xqm";

(: Namespaces :)
declare namespace rest="http://exquery.org/ns/restxq";
declare namespace output="http://www.w3.org/2010/xslt-xquery-serialization";
declare namespace tei="http://www.tei-c.org/ns/1.0";

(: Global Variables:)
declare variable $editors:data := $config:app-root || "/data/editors";

declare
    %rest:GET
    %rest:path("/editors")
    %rest:produces("application/xml", "text/xml")
    %output:media-type("application/xml")
    %output:method("xhtml")
function editors:index() {
  <html xmlns="http://www.w3.org/1999/xhtml">
    <body>
        <h1>Editors</h1>
    </body>
  </html>
};

declare
    %rest:GET
    %rest:path("/editors")
    %output:method("xml")
function editors:index_xml() {
    editors:list-items()
};

declare
    %rest:GET
    %rest:path("/editors/{$index}")
function editors:view-item($index as xs:string*){
    let $result := collection($editors:data)/tei:TEI/tei:person[@xml:id eq $index]
    return $result
};

declare function editors:list-items(){
    <tei:listPerson>
    {
        for $editor in collection($editors:data)/tei:TEI
        return
            $editor
    }
    </tei:listPerson>
};
