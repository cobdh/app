xquery version "3.0";

(:~
 : A set of helper functions to access the application context from
 : within a module.
 :)
module namespace config="https://cobdh.org/config";

(: namespaces :)
declare namespace expath="http://expath.org/ns/pkg";
declare namespace repo="http://exist-db.org/xquery/repo";
declare namespace req="http://exquery.org/ns/request";
declare namespace templates="http://exist-db.org/xquery/templates";
declare namespace xmldb="http://exist-db.org/xquery/xmldb";

(:
    Determine the application root collection from the current module load path.
:)
declare variable $config:app-root :=
    let $rawPath := system:get-module-load-path()
    let $modulePath :=
        (: strip the xmldb: part :)
        if (starts-with($rawPath, "xmldb:exist://")) then
            if (starts-with($rawPath, "xmldb:exist://embedded-eXist-server")) then
                substring($rawPath, 36)
            else
                substring($rawPath, 15)
        else
            $rawPath
    return
        substring-before($modulePath, "/modules")
;

declare variable $config:data-root :=
    if (xmldb:collection-available($config:app-root || '/../collection/data')) then
        $config:app-root || '/../collection/data'
    else
        $config:app-root || "/data"
;

declare variable $config:repo-descriptor := doc(concat($config:app-root, "/repo.xml"))/repo:meta;

declare variable $config:expath-descriptor := doc(concat($config:app-root, "/expath-pkg.xml"))/expath:package;

declare variable $config:data-bibl := $config:data-root || "/bibl";

declare variable $config:data-persons := $config:data-root || "/persons";

declare variable $config:data-editors := $config:data-root || "/editors";

declare variable $config:data-news := $config:data-root || "/news";

declare variable $config:ENGLISH := "en";

declare variable $config:GERMAN := "de";

declare variable $config:lang_default := $config:ENGLISH;

declare variable $config:lang :=
    (:Prefere url parameter over cookie. If cookie and parameter is not
    set, use default lang  :)
    let $lang := request:get-parameter('lang', '')
    let $lang := if (string-length($lang) eq 0) then request:get-cookie-value('lang') else $lang
    let $lang := if (string-length($lang) eq 0) then $config:lang_default else $lang
    return $lang
;

declare variable $config:demo :=
    let $demo := request:get-parameter('demo', '')
    let $demo := if (string-length($demo) eq 0) then request:get-cookie-value('demo') else $demo
        return $demo
;

(: TODO: UNITE WITH APP-ROOT :)
declare variable $config:web-root :=
    (: TODO: FIX EQ :)
    if($config:repo-descriptor/repo:live/text() eq 'true') then
        ''
    else
        '/exist/apps/cobdh'
;

declare variable $config:parameters := (
    <parameters>
        <param name="web-root" value="{$config:web-root}"/>
    </parameters>
);

(:~
 : Resolve the given path using the current application context.
 : If the app resides in the file system,
 :)
declare function config:resolve($relPath as xs:string){
    if (starts-with($config:app-root, "/db")) then
        doc(concat($config:app-root, "/", $relPath))
    else
        doc(concat("file://", $config:app-root, "/", $relPath))
};

(:~
 : Returns the repo.xml descriptor for the current application.
 :)
declare function config:repo-descriptor() as element(repo:meta){
    $config:repo-descriptor
};

(:~
 : Returns the expath-pkg.xml descriptor for the current application.
 :)
declare function config:expath-descriptor() as element(expath:package){
    $config:expath-descriptor
};

declare %templates:wrap function config:app-title($node as node(), $model as map(*)) as text(){
    $config:expath-descriptor/expath:title/text()
};

declare function config:app-meta($node as node(), $model as map(*)) as element()* {
    <meta xmlns="http://www.w3.org/1999/xhtml" name="description" content="{$config:repo-descriptor/repo:description/text()}"/>,
    for $author in $config:repo-descriptor/repo:author
    return
        <meta xmlns="http://www.w3.org/1999/xhtml" name="creator" content="{$author/text()}"/>
};

declare function config:lang-selector($node as node(), $model as map(*)){
    <div class="dropup">
        <button
            class="nav-link dropdown-toggle"
            type="button"
            data-bs-toggle="dropdown"
            aria-expanded="false"
        >
            {if ($config:lang eq $config:ENGLISH) then 'English' else ''}
            {if ($config:lang eq $config:GERMAN) then 'German' else ''}
        </button>
        <ul class="dropdown-menu">
            {if ($config:lang ne $config:ENGLISH) then <li><a class="dropdown-item" href="?lang={$config:ENGLISH}">English</a></li> else ''}
            {if ($config:lang ne $config:GERMAN) then <li><a class="dropdown-item" href="?lang={$config:GERMAN}">German</a></li> else ''}
        </ul>
    </div>
};

declare
    %templates:wrap
function config:lang_set_cookie($node as node(), $model as map(*)){
    let $age := xs:dayTimeDuration("PT72H")
    (: TODO: ENABLE BEFORE RELEASE :)
    let $secure := false()
    let $lang := request:get-parameter("lang", "")
    return
        if ($lang eq "") then
            ()
        else
            response:set-cookie(
                "lang",
                $lang,
                $age,
                $secure
            )
};

declare
    %templates:wrap
function config:demo_set_cookie($node as node(), $model as map(*)){
    let $age := xs:dayTimeDuration("PT72H")
    (: TODO: ENABLE BEFORE RELEASE :)
    let $secure := false()
    let $demo := request:get-parameter("demo", "")
    return
        if ($demo eq "") then
            ()
        else
            response:set-cookie(
                "demo",
                "1",
                $age,
                $secure
            )
};
