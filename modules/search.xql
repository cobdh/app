xquery version "3.0";

module namespace search="https://data.cobdh.org/search";

import module namespace config="https://data.cobdh.org/config" at "config.xqm";

import module namespace bibl="https://data.cobdh.org/bibl" at "bibl.xqm";

import module namespace persons="https://data.cobdh.org/persons" at "persons.xqm";

import module namespace i18n="http://exist-db.org/xquery/i18n/templates" at "lib/i18n-templates.xql";

import module namespace app="https://data.cobdh.org/app" at "app.xql";

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
                "hits": collection($bibl:data)[fn:contains(.//tei:title, $bibl_title)][fn:contains(., $bibl_keyword)],
                "searched": "bibl"
            }
        else if ($searched eq "person") then
            map{
                "hits": collection($persons:data)[fn:contains(.//tei:persName, $person_person)][fn:contains(., $person_keyword)],
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
function search:view_persons($node as node(), $model as map(*)) {
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
        transform:transform($persons, $xsl, ())
};

declare
    %templates:wrap
function search:view_bibls($node as node(), $model as map(*)) {
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
        transform:transform($bibls, $xsl, ())
};

declare
    %templates:wrap
function search:no_result($node as node(), $model as map(*)) {
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
function search:formular($node as node(), $model as map(*)) {
    let $person_keyword := request:get-parameter('person_keyword', '')
    let $person_person := request:get-parameter('person_person', '')

    let $bibl_keyword := request:get-parameter('bibl_keyword', '')
    let $bibl_person := request:get-parameter('bibl_person', '')
    let $bibl_title := request:get-parameter('bibl_title', '')

    let $person_active :=  if($model("searched") eq "person") then 'active' else ''
    let $bibl_active :=  if ($person_active eq '') then 'active' else ''
    return
    <div class="well well-small search-box">
        <div class="top-pad">
        <ul class="nav nav-tabs">
            <li class="{$bibl_active}"><a href="#bibliography" data-toggle="tab" aria-expanded="true">Bibliography</a></li>
            <li class="{$person_active}"><a href="#persons" data-toggle="tab" aria-expanded="false">Persons</a></li>
        </ul>
        <div class="tab-pane {$bibl_active}" id="bibliography">
            <form
                class="form-horizontal indent"
                method="get"
                role="form"
            >
            <div class="tab-content col-md-8">
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
                            class="btn btn-info"
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
        <div class="tab-pane {$person_active}" id="persons">
            <form
                class="form-horizontal indent"
                method="get"
                role="form"
            >
            <div class="tab-content col-md-8">
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
                            class="btn btn-info"
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
</div>
};

declare function search:build-ft-query(){
    <query>
        {
            if ($search:mode eq 'any') then
                for $term in tokenize($search:q, '\s')
                return
                    <term occur="should">{$term}</term>
            else if ($search:mode eq 'all') then
                for $term in tokenize($search:q, '\s')
                return
                    <term occur="must">{$term}</term>
            else if ($search:mode eq 'phrase') then
                <phrase>{$search:q}</phrase>
            else
                <near>{$search:q}</near>
        }
        </query>
};
