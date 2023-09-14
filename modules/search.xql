xquery version "3.0";

module namespace search="https://cobdh.org/search";

import module namespace config="https://cobdh.org/config" at "config.xqm";

import module namespace persons="https://cobdh.org/persons" at "persons.xql";

import module namespace i18n="http://exist-db.org/xquery/i18n/templates" at "lib/i18n-templates.xql";

import module namespace app="https://cobdh.org/app" at "app.xql";

(: Namespaces :)
declare namespace tei="http://www.tei-c.org/ns/1.0";

declare namespace templates="http://exist-db.org/xquery/templates";

declare function local:search-options(){
    <options>
        <default-operator>and</default-operator>
        <phrase-slop>1</phrase-slop>
        <leading-wildcard>yes</leading-wildcard>
        <filter-rewrite>yes</filter-rewrite>
    </options>
};

declare function search:search($node as node(), $model as map(*)){
    let $person_keyword := request:get-parameter('person_keyword', '')
    let $person_person := request:get-parameter('person_person', '')

    let $bibl_keyword := request:get-parameter('bibl_keyword', '')
    let $bibl_person := request:get-parameter('bibl_person', '')
    let $bibl_title := request:get-parameter('bibl_title', '')

    let $person_keyword := local:prepare_keyword($person_keyword)
    let $person_person := local:prepare_keyword($person_person)
    let $bibl_keyword := local:prepare_keyword($bibl_keyword)
    let $bibl_person := local:prepare_keyword($bibl_person)
    let $bibl_title := local:prepare_keyword($bibl_title)

    let $searched := if ($person_keyword or $person_person) then "person"
        else if ($bibl_keyword or $bibl_person or $bibl_title) then "bibl"
        else 'none'

    return
        if ($searched eq "bibl") then
            map{
                "hits": local:search_bibl($bibl_person, $bibl_title, $bibl_keyword),
                "searched": "bibl"
            }
        else if ($searched eq "person") then
            map{
                "hits": local:search_person($person_person, $person_keyword),
                "searched": "person"
            }
        else
            map{
                "hits" : (),
                "searched" : "none"
            }
};

declare function local:prepare_keyword($keyword as xs:string){
    (: Remove invalid character :)
    let $keyword := local:clean($keyword)
    (: Strip spaces :)
    let $keyword := normalize-space($keyword)
    return $keyword
};

(:~
 : See srophe:modules/content-negotiation/bib2html.xqm
 : GNU GENERAL PUBLIC LICENSE
 : Cleans search parameters to replace bad/undesirable data in strings
 : @param-string parameter string to be cleaned
:)
declare function local:clean($value){
    let $value :=
        if (local:number-of-matches($value, '"') mod 2) then
            replace($value, '"', ' ') (:if there is an uneven number of quotation marks, delete all quotation marks.:)
        else
            $value
    let $value :=
        if ((local:number-of-matches($value, '\(') + local:number-of-matches($value, '\)')) mod 2) then
            translate($value, '()', ' ') (:if there is an uneven number of parentheses, delete all parentheses.:)
        else
            $value
    let $value :=
        if ((local:number-of-matches($value, '\[') + local:number-of-matches($value, '\]')) mod 2) then
            translate($value, '[]', ' ') (:if there is an uneven number of brackets, delete all brackets.:)
        else
            $value
    let $value := replace($value,"'","''")
    return
        replace(replace($value,'<|>|@|&amp;',''), '(\.|\[|\]|\\|\||\-|\^|\$|\+|\{|\}|\(|\)|(/))','\\$1')
};

declare function local:number-of-matches( $arg as xs:string? , $pattern as xs:string ) as xs:integer{
    if ($arg != '') then
        count(tokenize($arg,$pattern)) - 1
    else
        0
};

declare function local:search_bibl($person as xs:string, $title as xs:string, $keyword as xs:string){
    let $keyword_logic := local:prepare_keyword(request:get-parameter('bibl_keyword_logic', 'AND'))
    let $person_logic := local:prepare_keyword(request:get-parameter('bibl_person_logic', 'AND'))
    let $title_logic := local:prepare_keyword(request:get-parameter('bibl_title_logic', 'AND'))

    let $data := collection($config:data-bibl)

    let $expand := $data[
        (if ($keyword_logic eq 'OR') then search:search(.//tei:body, $keyword, $keyword_logic) else ()) or
        (if ($person_logic eq 'OR') then search:search(
            .//(tei:author|
            (:Skip document header:)
            tei:editor[not(ancestor::tei:teiHeader)]),
            $person, $person_logic) else ()) or
        (if ($title_logic eq 'OR') then search:search(.//tei:title, $title, $title_logic) else ())
    ]
    let $minimize := $data
    let $minimize := if($keyword and $keyword_logic ne 'OR') then $minimize[search:search(.//tei:body, $keyword, $keyword_logic)] else $minimize
    let $minimize := if($person and $person_logic ne 'OR') then $minimize[search:search(
        .//(tei:author|
        (:Skip document header:)
        tei:editor[not(ancestor::tei:teiHeader)]
        ), $person, $person_logic)] else $minimize
    let $minimize := if($title and $title_logic ne 'OR') then $minimize[search:search(.//tei:title, $title, $title_logic)] else $minimize

    return
        $expand | $minimize
};

declare function search:search($path, $value, $logic){
    if($value eq '') then
        ()
    else if($logic eq 'NOT') then
        not(ft:query($path, $value, local:search-options()))
    else
        ft:query($path, $value, local:search-options())
    };

declare function local:search_person($person as xs:string, $keyword as xs:string){
    let $person_logic := local:prepare_keyword(request:get-parameter('person_person_logic', 'AND'))
    let $keyword_logic := local:prepare_keyword(request:get-parameter('person_keyword_logic', 'AND'))

    let $data := collection($config:data-persons)

    let $expand := $data[
        (if ($person_logic eq 'OR') then search:search(.//tei:persName, $person, $person_logic) else ()) or
        (if ($keyword_logic eq 'OR') then search:search(.//tei:body, $keyword, $keyword_logic) else ())
    ]
    let $minimize := $data
    let $minimize := if($person and $person_logic ne 'OR') then $minimize[search:search(.//tei:persName, $person, $person_logic)] else $minimize
    let $minimize := if($keyword and $keyword_logic ne 'OR') then $minimize[search:search(.//tei:body, $keyword, $keyword_logic)] else $minimize

    return
        $expand | $minimize
};

declare
    %templates:wrap
function search:view_persons($node as node(), $model as map(*)){
    let $persons_ := if ($model("searched") eq "person") then $model("hits") else ()
    (: Select current search result for pagination :)
    let $perpage := $app:perpage
    let $pagination := app:pageination(
            $node,
            $model,
            $persons_,
            $perpage
        )
    let $start := $app:start
    let $persons_ := subsequence($persons_, $start, $perpage)
    let $persons_ := if ($persons_) then <tei:listPerson>{
        for $item in $persons_
        order by persons:orderby_name($item)
        return $item
    }</tei:listPerson> else ()
    let $export := <parameters>
        <param name="mode" value="plain"/>
    </parameters>
    let $xsl := config:resolve("views/persons/list-items.xsl")
    return
        $pagination
        |
        transform:transform($persons_, $xsl, $config:parameters)
        |
        transform:transform($persons_, $xsl, $export)
};

declare
    %templates:wrap
function search:view_bibls($node as node(), $model as map(*)){
    let $bibls := if ($model("searched") eq "bibl") then $model("hits") else ()
    (: Select current search result for pagination :)
    let $perpage := $app:perpage
    let $pagination := app:pageination(
            $node,
            $model,
            $bibls,
            $perpage
        )
    let $start := $app:start
    let $bibls := subsequence($bibls, $start, $perpage)
    let $bibls := if ($bibls) then <tei:listBibl>{$bibls}</tei:listBibl> else ()
    let $xsl := config:resolve("views/bibl/list-items.xsl")
    let $parameters := <parameters>
        <param name="style" value="citation"/>
        <param name="web-root" value="{$config:web-root}"/>
    </parameters>
     let $export := <parameters>
        <param name="style" value="citation"/>
        <param name="mode" value="plain"/>
        <param name="web-root" value="{$config:web-root}"/>
    </parameters>
    return
        $pagination|
        transform:transform($bibls, $xsl, $parameters)|
        transform:transform($bibls, $xsl, $export)
};

declare
    %templates:wrap
function search:no_result($node as node(), $model as map(*)){
    let $searched := $model("searched")
    let $result := $model("hits")
    return
        if ($searched != 'none' and empty($result)) then
            <p class="alert alert-danger">
                Could not find any results!
            </p>
        else
            ()
};

declare
    %templates:wrap
function search:formular($node as node(), $model as map(*)){
    let $person_keyword := request:get-parameter('person_keyword', '')
    let $person_keyword_logic := request:get-parameter('person_keyword_logic', 'AND')
    let $person_person := request:get-parameter('person_person', '')
    let $person_person_logic := request:get-parameter('person_person_logic', 'AND')

    let $bibl_keyword := request:get-parameter('bibl_keyword', '')
    let $bibl_keyword_logic := request:get-parameter('bibl_keyword_logic', 'AND')
    let $bibl_person := request:get-parameter('bibl_person', '')
    let $bibl_person_logic := request:get-parameter('bibl_person_logic', 'AND')
    let $bibl_title := request:get-parameter('bibl_title', '')
    let $bibl_title_logic := request:get-parameter('bibl_title_logic', 'AND')

    let $person_active :=  if($model("searched") eq "person") then 'active' else ''
    let $bibl_active :=  if ($person_active eq '') then 'active' else ''
    return
    <div class="well well-small search-box">
        <nav>
          <div class="nav nav-tabs mb-2" id="nav-tab" role="tablist">
            <button class="nav-link {$bibl_active}" id="nav-bibliography-tab"
                role="tab" aria-selected="true" aria-controls="nav-bibliography"
                type="button" data-bs-toggle="tab"
                data-bs-target="#nav-bibliography">
                Bibliography
            </button>
            <button class="nav-link {$person_active}" id="nav-persons-tab"
                role="tab" aria-selected="false" aria-controls="nav-persons"
                type="button" data-bs-toggle="tab"
                data-bs-target="#nav-persons">
                Persons
            </button>
          </div>
        </nav>
        <div class="tab-pane {$bibl_active}" id="nav-bibliography" role="tabpanel" aria-labelledby="nav-bibliography-tab">
            <form
                class="form-horizontal indent"
                method="get"
                role="form"
            >
            <div class="tab-content col-sm-10 col-md-9">
                <!--Keyword-->
                <div class="form-group">
                    <div class="input-group">
                        <label
                            class="input-group-text col-2"
                            for="keyword"
                        >
                            <i18n:text key="search_keyword">Keyword</i18n:text>
                        </label>
                        <input
                            class="form-control keyboard"
                            id="keyword"
                            name="bibl_keyword"
                            type="text"
                            value="{$bibl_keyword}"
                        />
                        <select name="bibl_keyword_logic" class="input-group-text">
                            {if ($bibl_keyword_logic eq 'AND') then <option value="AND" selected="">AND</option> else <option value="AND">AND</option>}
                            {if ($bibl_keyword_logic eq 'OR') then <option value="OR" selected="">OR</option> else <option value="OR">OR</option>}
                            {if ($bibl_keyword_logic eq 'NOT') then <option value="NOT" selected="">NOT</option> else <option value="NOT">NOT</option>}
                        </select>
                        <div class="input-group-btn">
                            <!--<span data-template="app:keyboard-select-menu" data-template-input-id="keyword"/>-->
                        </div>
                    </div>
                </div>
                <!--author-->
                <div class="form-group">
                    <div class="input-group mt-2">
                        <label
                            class="input-group-text col-2"
                            for="author"
                        >
                            <i18n:text key="search_person">Person</i18n:text>
                        </label>
                        <input
                            class="form-control keyboard"
                            id="author"
                            name="bibl_person"
                            type="text"
                            value="{$bibl_person}"
                        />
                        <select name="bibl_person_logic" class="input-group-text">
                            {if ($bibl_person_logic eq 'AND') then <option value="AND" selected="">AND</option> else <option value="AND">AND</option>}
                            {if ($bibl_person_logic eq 'OR') then <option value="OR" selected="">OR</option> else <option value="OR">OR</option>}
                            {if ($bibl_person_logic eq 'NOT') then <option value="NOT" selected="">NOT</option> else <option value="NOT">NOT</option>}
                        </select>
                        <div class="input-group-btn">
                            <!--<span data-template="app:keyboard-select-menu" data-template-input-id="author"/>-->
                        </div>
                    </div>
                </div>
                <!--Title-->
                <div class="form-group">
                    <div class="input-group mt-2">
                        <label
                            class="input-group-text col-2"
                            for="title"
                        >
                            <i18n:text key="search_title">Title</i18n:text>
                        </label>
                        <input
                            class="form-control keyboard"
                            id="title"
                            name="bibl_title"
                            type="text"
                            value="{$bibl_title}"
                        />
                        <select name="bibl_title_logic" class="input-group-text">
                            {if ($bibl_title_logic eq 'AND') then <option value="AND" selected="">AND</option> else <option value="AND">AND</option>}
                            {if ($bibl_title_logic eq 'OR') then <option value="OR" selected="">OR</option> else <option value="OR">OR</option>}
                            {if ($bibl_title_logic eq 'NOT') then <option value="NOT" selected="">NOT</option> else <option value="NOT">NOT</option>}
                        </select>
                        <div class="input-group-btn">
                            <!--<span data-template="app:keyboard-select-menu" data-template-input-id="title"/>-->
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <div class="pull-right">
                        <button
                            class="btn btn-primary mt-2"
                            type="submit"
                        >
                            <i18n:text key="search_doit">Search</i18n:text>
                        </button>
                    </div>
                </div>
                <!--end col-->
            </div>
            </form>
        </div>
        <div class="tab-pane {$person_active}" id="nav-persons" role="tabpanel" aria-labelledby="nav-persons-tab">
            <form
                class="form-horizontal indent"
                method="get"
                role="form"
            >
            <div class="tab-content col-sm-10 col-md-9">
                <!--Keyword-->
                <div class="form-group">
                    <div class="input-group">
                        <label
                            class="input-group-text col-2"
                            for="keyword"
                        >
                            <i18n:text key="search_keyword">Keyword</i18n:text>
                        </label>
                        <input
                            class="form-control keyboard"
                            id="keyword"
                            name="person_keyword"
                            type="text"
                            value="{$person_keyword}"
                        />
                        <select name="person_keyword_logic" class="input-group-text">
                            {if ($person_keyword_logic eq 'AND') then <option value="AND" selected="">AND</option> else <option value="AND">AND</option>}
                            {if ($person_keyword_logic eq 'OR') then <option value="OR" selected="">OR</option> else <option value="OR">OR</option>}
                            {if ($person_keyword_logic eq 'NOT') then <option value="NOT" selected="">NOT</option> else <option value="NOT">NOT</option>}
                        </select>
                        <div class="input-group-btn">
                            <!--<span data-template="app:keyboard-select-menu" data-template-input-id="keyword"/>-->
                        </div>
                    </div>
                </div>
                <!--person-->
                <div class="form-group">
                    <div class="input-group mt-2">
                        <label
                            class="input-group-text col-2"
                            for="author"
                        >
                            <i18n:text key="search_person">Person</i18n:text>
                        </label>
                        <input
                            class="form-control keyboard"
                            id="author"
                            name="person_person"
                            type="text"
                            value="{$person_person}"
                        />
                        <select name="person_person_logic" class="input-group-text">
                            {if ($person_person_logic eq 'AND') then <option value="AND" selected="">AND</option> else <option value="AND">AND</option>}
                            {if ($person_person_logic eq 'OR') then <option value="OR" selected="">OR</option> else <option value="OR">OR</option>}
                            {if ($person_person_logic eq 'NOT') then <option value="NOT" selected="">NOT</option> else <option value="NOT">NOT</option>}
                        </select>
                        <div class="input-group-btn">
                            <!--<span data-template="app:keyboard-select-menu" data-template-input-id="author"/>-->
                        </div>
                    </div>
                </div>
                <div class="form-group">
                    <div class="pull-right">
                        <button
                            class="btn btn-primary mt-2"
                            type="submit"
                        >
                            <i18n:text key="search_doit">Search</i18n:text>
                        </button>
                    </div>
                </div>
                <!--end col-->
            </div>
            </form>
    </div>
</div>
};
