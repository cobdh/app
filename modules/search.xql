xquery version "3.0";

module namespace search="https://cobdh.org/search";

import module namespace config="https://cobdh.org/config" at "config.xqm";

import module namespace i18n="http://exist-db.org/xquery/i18n/templates" at "lib/i18n-templates.xql";

import module namespace app="https://cobdh.org/app" at "app.xql";

(: Namespaces :)
declare namespace tei="http://www.tei-c.org/ns/1.0";

declare namespace templates="http://exist-db.org/xquery/templates";

declare function search:search($node as node(), $model as map(*)){
    let $person_keyword := request:get-parameter('person_keyword', '')
    let $person_person := request:get-parameter('person_person', '')

    let $bibl_keyword := request:get-parameter('bibl_keyword', '')
    let $bibl_person := request:get-parameter('bibl_person', '')
    let $bibl_title := request:get-parameter('bibl_title', '')

    let $searched := if ($person_keyword or $person_person) then "person"
        else if ($bibl_keyword or $bibl_person or $bibl_title) then "bibl"
        else 'none'

    return
        if ($searched eq "bibl") then
            map{
                "hits": collection($config:data-bibl)
                    [
                        (
                            $bibl_title and fn:contains
                            (
                                lower-case(string-join(.//tei:title)),
                                search:build-ft-query($bibl_title)
                            )
                        )
                            or
                        (
                            $bibl_person and fn:contains
                            (
                                lower-case(string-join(.//
                                (
                                    tei:author|
                                    (:Skip document header:)
                                    tei:editor[not(ancestor::tei:teiHeader)]
                                ))),
                                search:build-ft-query($bibl_person)
                            )
                        )
                            or
                        (
                            $bibl_keyword and fn:contains
                            (
                                lower-case(.),
                                search:build-ft-query($bibl_keyword)
                            )
                        )
                    ],
                "searched": "bibl"
            }
        else if ($searched eq "person") then
            map{
                "hits": collection($config:data-persons)
                    [
                        (
                            $person_person and fn:contains
                            (
                                lower-case(string-join(.//tei:persName)),
                                search:build-ft-query($person_person)
                            )
                        )
                            or
                        (
                            $person_keyword and fn:contains
                            (
                                lower-case(.),
                                search:build-ft-query($person_keyword)
                            )
                        )
                    ],
                "searched": "person"
            }
        else
            map{
                "hits" : (),
                "searched" : "none"
            }
};

declare
    %templates:wrap
function search:view_persons($node as node(), $model as map(*)){
    let $persons := if ($model("searched") eq "person") then $model("hits") else ()
    (: Select current search result for pagination :)
    let $perpage := $app:perpage
    let $pagination := app:pageination(
            $node,
            $model,
            $persons,
            $perpage
        )
    let $start := $app:start
    let $persons := subsequence($persons, $start, $perpage)
    let $persons := if ($persons) then <tei:listPerson>{$persons}</tei:listPerson> else ()
    let $xsl := config:resolve("views/persons/list-items.xsl")
    return
        $pagination|
        transform:transform($persons, $xsl, $config:parameters)
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
    return
        $pagination|
        transform:transform($bibls, $xsl, $config:parameters)
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
    let $person_person := request:get-parameter('person_person', '')

    let $bibl_keyword := request:get-parameter('bibl_keyword', '')
    let $bibl_person := request:get-parameter('bibl_person', '')
    let $bibl_title := request:get-parameter('bibl_title', '')

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
            <div class="tab-content">
                <!--Keyword-->
                <div class="form-group">
                    <label
                        class="col-sm-2 col-md-3 control-label"
                        for="keyword"
                    >
                        <i18n:text key="search_keyword">Keyword</i18n:text>:
                    </label>
                    <div class="col-sm-10 col-md-9 ">
                        <div class="input-group">
                            <input
                                class="form-control keyboard"
                                id="keyword"
                                name="bibl_keyword"
                                type="text"
                                value="{$bibl_keyword}"
                            />
                            <div class="input-group-btn">
                                <!--<span data-template="app:keyboard-select-menu" data-template-input-id="keyword"/>-->
                            </div>
                        </div>
                    </div>
                </div>
                <!--author-->
                <div class="form-group">
                    <label
                        class="col-sm-2 col-md-3 control-label"
                        for="author"
                    >
                        <i18n:text key="search_person">Person</i18n:text>:
                    </label>
                    <div class="col-sm-10 col-md-9 ">
                        <div class="input-group">
                            <input
                                class="form-control keyboard"
                                id="author"
                                name="bibl_person"
                                type="text"
                                value="{$bibl_person}"
                            />
                            <div class="input-group-btn">
                                <!--<span data-template="app:keyboard-select-menu" data-template-input-id="author"/>-->
                            </div>
                        </div>
                    </div>
                </div>
                <!--Title-->
                <div class="form-group">
                    <label
                        class="col-sm-2 col-md-3 control-label"
                        for="title"
                    >
                        <i18n:text key="search_title">Title</i18n:text>:
                    </label>
                    <div class="col-sm-10 col-md-9 ">
                        <div class="input-group">
                            <input
                                class="form-control keyboard"
                                id="title"
                                name="bibl_title"
                                type="text"
                                value="{$bibl_title}"
                            />
                            <div class="input-group-btn">
                                <!--<span data-template="app:keyboard-select-menu" data-template-input-id="title"/>-->
                            </div>
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
            <div class="tab-content">
                <!--Keyword-->
                <div class="form-group">
                    <label
                        class="col-sm-2 col-md-3 control-label"
                        for="keyword"
                    >
                        <i18n:text key="search_keyword">Keyword</i18n:text>:
                    </label>
                    <div class="col-sm-10 col-md-9 ">
                        <div class="input-group">
                            <input
                                class="form-control keyboard"
                                id="keyword"
                                name="person_keyword"
                                type="text"
                                value="{$person_keyword}"
                            />
                            <div class="input-group-btn">
                                <!--<span data-template="app:keyboard-select-menu" data-template-input-id="keyword"/>-->
                            </div>
                        </div>
                    </div>
                </div>
                <!--person-->
                <div class="form-group">
                    <label
                        class="col-sm-2 col-md-3 control-label"
                        for="author"
                    >
                        <i18n:text key="search_person">Person</i18n:text>:
                    </label>
                    <div class="col-sm-10 col-md-9 ">
                        <div class="input-group">
                            <input
                                class="form-control keyboard"
                                id="author"
                                name="person_person"
                                type="text"
                                value="{$person_person}"
                            />
                            <div class="input-group-btn">
                                <!--<span data-template="app:keyboard-select-menu" data-template-input-id="author"/>-->
                            </div>
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

declare function search:build-ft-query($token){
    let $mode:='any'
    let $token:=lower-case($token)
    return
        <query>
            {
                if ($mode eq 'any') then
                    for $term in tokenize($token, '\s')
                    return
                        <term occur="should">{$term}</term>
                else if ($mode eq 'all') then
                    for $term in tokenize($token, '\s')
                    return
                        <term occur="must">{$term}</term>
                else if ($mode eq 'phrase') then
                    <phrase>{$token}</phrase>
                else
                    <near>{$token}</near>
            }
        </query>
};
