xquery version "3.0";

module namespace news="https://cobdh.org/news";

import module namespace config="https://cobdh.org/config" at "config.xqm";

import module namespace templates="http://exist-db.org/xquery/templates" at "template.xql";

import module namespace i18n="http://exist-db.org/xquery/i18n/templates" at "lib/i18n-templates.xql";

import module namespace app="https://cobdh.org/app" at "app.xql";

(: Namespaces :)
declare namespace tei="http://www.tei-c.org/ns/1.0";

declare function news:list-items(){
    (: Determine list of bibl, sort newest items first. :)
    for $item in collection($config:data-news)/tei:TEI
    return
        $item
};

declare function news:view($node as node(), $model as map(*)){
    let $data := news:list-items()
    (: select template :)
    let $xsl := config:resolve("views/news/list-items.xsl")
    return
        transform:transform($data, $xsl, $config:parameters)
};
