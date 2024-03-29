xquery version "3.0";

module namespace persons="https://cobdh.org/persons";

import module namespace config="https://cobdh.org/config" at "config.xqm";

import module namespace templates="http://exist-db.org/xquery/templates" at "template.xql";

import module namespace bibl="https://cobdh.org/bibl" at "bibl.xql";

import module namespace app="https://cobdh.org/app" at "app.xql";

import module namespace search="https://cobdh.org/search" at "search.xql";

import module namespace landing="https://cobdh.org/landing" at "landing.xql";

(: Namespaces :)
declare namespace tei="http://www.tei-c.org/ns/1.0";

(: Display list of persons. Use pagination to display huge amount of data. :)
declare function persons:index($node as node(), $model as map(*)){
    let $start := $app:start
    let $perpage := $app:perpage
    let $persons := persons:list-items-current()
    (: Select current data for pagination :)
    let $persons := subsequence($persons, $start, $perpage)
    let $persons := <tei:listPerson>{$persons}</tei:listPerson>
    let $xsl := config:resolve("views/persons/list-items.xsl")
    return
        transform:transform($persons, $xsl, $config:parameters)
};

declare function persons:view-item($node as node(), $model as map(*), $index as xs:string){
    let $data := collection($config:data-persons)//tei:person[@xml:id eq $index]
    (: select root node to render header information :)
    let $data := root($data)
    (: select template :)
    let $xsl := config:resolve("views/persons/view-item.xsl")
    return
        transform:transform($data, $xsl, $config:parameters)
};

declare function persons:view-item-request($node as node(), $model as map(*)){
    (: TODO: SIMPLFIY LATER :)
    (: `selected` is determined in app:determine_resource :)
    let $index := $model("selected")
    return
        persons:view-item($node, $model, $index)
};

declare function persons:list-items(){
    for $item in collection($config:data-persons)/tei:TEI
    order by persons:orderby_name($item)
    return
        $item
};

declare function persons:list-items-current(){
    let $persons := landing:select_category(persons:list-items())
    let $persons := if ($app:alpha eq 'ALL' or $app:alpha eq '') then
        $persons
    else
        $persons[search:search(.//tei:surname, concat($app:alpha, "*"), "AND")]
    return $persons
};

declare function persons:orderby_name($item){
    (:Sorting persons depends on local differences.

    The English speaking World integrates titles such German 'von' inside
    the name.
    ==> von Schuler Einar < Thomson Robert W.

    The Germans ignore such prefixes.
    ==> Thomson Robert W. < von Schuler Einar
    :)
    if($config:lang eq $config:ENGLISH and $item//tei:nameLink) then
        lower-case(string-join($item//tei:nameLink))
    else if($item//tei:surname) then
        lower-case(string-join($item//tei:surname))
    else if($item//tei:persName) then
        lower-case(string-join($item//tei:persName))
    else
    (: sort item without naming to the end :)
        'zzz'
};

declare
    %templates:wrap
function persons:missing-item($node as node(), $model as map(*)){
    let $index := $model("selected")
    let $data := collection($config:data-persons)//tei:person[@xml:id eq $index]
    return
        if (empty($data)) then
            <p class="alert alert-danger">
                Could not locate Person
                <b>{$index}</b>
            </p>
        else
            ()
};

(: Provide persons pagination :)
declare
    %templates:wrap
function persons:paging($node as node(), $model as map(*)){
    let $hits := persons:list-items-current()
    let $perpage := $app:perpage
    return
        app:pageination(
            $node,
            $model,
            $hits,
            $perpage
        )
};

declare
    %templates:wrap
function persons:countby_region($node as node(), $model as map(*), $region as xs:string) as xs:int{
    if ($region eq 'ar') then
        count(persons:list-items()//tei:category[@xml:id eq "ARMENIA"])
    else if ($region eq 'ge') then
        count(persons:list-items()//tei:category[@xml:id eq "GEORGIA"])
    else if ($region eq '') then
        count(persons:list-items())
    else
        -1
};

(: Display bibliography elements where editor contributed some changes. :)
declare function persons:edited-request($node as node(), $model as map(*)){
    (: `selected` is determined in app:determine_resource :)
    let $editor := $model("selected")
    (: TODO: THERE MUST BE A BETTER WAY :)
    let $data := <tei:listBibl>{bibl:list-items()}</tei:listBibl>
    let $data := $data//tei:TEI[contains(.//tei:author/@ref, $editor) or contains(.//tei:editor/@ref, $editor)]
    let $data := <tei:listBibl>{$data}</tei:listBibl>
    let $xsl := config:resolve("views/bibl/list-items.xsl")
    let $parameters := <parameters>
        <param name="headline" value="Work"/>
        <param name="web-root" value="{$config:web-root}"/>
    </parameters>
    return
        transform:transform($data, $xsl, $parameters)
};

(:~
 : Select persons presentation by starting letter of the surname. To view
   all persons select ALL.
:)
declare
    %templates:wrap
function persons:abc-menu($node as node(), $model as map(*)){
    (: TODO: SUPPORT FURTHER CHARACTER SYSTEMS :)
    let $data := persons:list-items()
    return
        <ul class="pagination pagination-sm flex-wrap" style="display:inline-flex;">
        {
            for $letter in tokenize('A B C D E F G H I J K L M N O P Q R S T U V W X Y Z ALL', ' ')
            let $active := ($app:alpha eq $letter) or ($letter eq 'ALL' and $app:alpha eq '')
            (: Default case, no letter is selected :)
            let $hasdata := ($letter eq 'ALL')
            (: Is a person with surname of $letter present :)
            let $hasdata := $hasdata or (count($data[starts-with(.//tei:surname, $letter)]) gt 0)
            return
                <li class="page-item {if ($active) then 'active' else ''}" style="margin: 5px;">
                    {
                        <a class="page-link {if (not($hasdata)) then 'disabled' else ''}" href="?alpha={$letter}">
                            {$letter}
                        </a>
                    }
                </li>
        }
        </ul>
};
