xquery version "3.0";

module namespace editor="http://cobdh.org/cobdh-data/editor";

import module namespace config="http://cobdh.org/cobdh-data/config" at "config.xqm";

declare function editor:index($node as node(), $model as map(*)){
    let $input := config:resolve("data/editor.xml")
    let $xsl := config:resolve("views/editor/editor.xsl")
    return
        transform:transform($input, $xsl, ())
};
