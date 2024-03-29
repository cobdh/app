module namespace intl="http://exist-db.org/xquery/i18n/templates";

(:~
 : i18n template functions. Integrates the i18n library module. Called from the templating framework.
 :)
import module namespace i18n="http://exist-db.org/xquery/i18n" at "i18n.xql";

import module namespace templates="http://exist-db.org/xquery/templates";

import module namespace config="https://cobdh.org/config" at "../config.xqm";

(:~
 : Template function: calls i18n:process on the child nodes of $node.
 : Template parameters:
 :      lang=de Language selection
 :      catalogues=relative path    Path to the i18n catalogue XML files inside database
 :)
declare
    %templates:wrap %templates:default("lang", "en")
    %templates:wrap %templates:default("catalogues", "data/i18n")
function intl:translate($node as node(), $model as map(*), $lang as xs:string?, $catalogues as xs:string?){
    let $cpath :=
        (: if path to catalogues is relative, resolve it relative to the app root :)
        if (starts-with($catalogues, "/")) then
            $catalogues
        else
            concat($config:app-root, "/", $catalogues)
    let $translated :=
        i18n:process($node/*, $lang, $cpath, ())
    return
        element { node-name($node) } {
            $node/@*,
            templates:process($translated, $model)
        }
};
