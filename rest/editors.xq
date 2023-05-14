xquery version "3.0";

(:
 : Defines all the RestXQ endpoints used by the XForms.
 :)
module namespace editors="https://cobdh.org/rest/editors";

import module namespace config="https://cobdh.org/config" at "../modules/config.xqm";

import module namespace editor="https://cobdh.org/editors" at "../modules/editor.xql";

(: Namespaces :)
declare namespace rest="http://exquery.org/ns/restxq";
declare namespace output="http://www.w3.org/2010/xslt-xquery-serialization";
declare namespace tei="http://www.tei-c.org/ns/1.0";

declare
    %rest:GET
    %rest:path("/editors")
    %rest:produces("application/xml", "text/xml")
    %output:media-type("application/xml")
    %output:method("xhtml")
function editors:index(){
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
function editors:index_xml(){
    editor:list-items()
};

declare
    %rest:GET
    %rest:path("/editors/{$index}")
function editors:view-item($index as xs:string*){
    let $result := collection($config:data-editors)/tei:TEI/tei:person[@xml:id eq $index]
    return $result
};
