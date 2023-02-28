xquery version "3.0";

module namespace bibl="https://data.cobdh.org/bibl/";

import module namespace config="https://data.cobdh.org/config" at "config.xqm";

import module namespace editors="https://data.cobdh.org/editors" at "../rest/editors.xq";

declare function bibl:index($node as node(), $model as map(*)){
    let $input := editors:list-items()
    let $xsl := config:resolve("views/editors/list-items.xsl")
    return
        transform:transform($input, $xsl, ())
};
