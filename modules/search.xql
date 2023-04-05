xquery version "3.0";

module namespace search="https://data.cobdh.org/search";

import module namespace config="https://data.cobdh.org/config" at "config.xqm";

import module namespace bibl="https://data.cobdh.org/bibl" at "bibl.xqm";

import module namespace persons="https://data.cobdh.org/persons" at "persons.xqm";

import module namespace i18n="http://exist-db.org/xquery/i18n/templates" at "lib/i18n-templates.xql";

(: Namespaces :)
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace templates="http://exist-db.org/xquery/templates";

declare function search:search($node as node(), $model as map(*)){
    let $keyword := request:get-parameter('keyword', '')
    let $title := request:get-parameter('title', '')
    let $person := request:get-parameter('person', '')
    let $persons := ()
    let $bibls := ()
    let $persons := if ($keyword or $person) then
            collection($persons:data)[fn:contains(.//tei:persName, $person)][fn:contains(., $keyword)]
        else ()
    let $bibls := if ($keyword or $title) then
            collection($bibl:data)[fn:contains(.//tei:title, $title)][fn:contains(., $keyword)]
        else ()
    return
        map {
            "hits_persons": $persons,
            "hits_bibls": $bibls,
            "hits_searched": $keyword or $title or $person
        }
};

declare
    %templates:wrap
function search:view_persons($node as node(), $model as map(*)) {
    let $persons := $model("hits_persons")
    let $headline := if ($persons) then <h2>Persons</h2> else ()
    let $persons := if ($persons) then <tei:listPerson>{$persons}</tei:listPerson> else ()
    let $xsl := config:resolve("views/persons/list-items.xsl")
    return
        $headline|
        transform:transform($persons, $xsl, ())
};

declare
    %templates:wrap
function search:view_bibls($node as node(), $model as map(*)) {
    let $bibls := $model("hits_bibls")
    let $headline := if ($bibls) then <h2>Bibliography</h2> else ()
    let $bibls := if ($bibls) then <tei:listBibl>{$bibls}</tei:listBibl> else ()
    let $xsl := config:resolve("views/bibl/list-items.xsl")
    return
        $headline|
        transform:transform($bibls, $xsl, ())
};

declare
    %templates:wrap
function search:no_result($node as node(), $model as map(*)) {
    let $searched := $model("hits_searched")
    let $persons := $model("hits_persons")
    let $nopersons := empty($persons)
    let $bibls := $model("hits_bibls")
    let $nobibls := empty($bibls)
    return
        if ($searched and $nopersons and $nobibls) then
            <p class="alert alert-danger">
                Could not find any results!
            </p>
        else
            ()
};

declare
    %templates:wrap
function search:formular($node as node(), $model as map(*)) {
    let $keyword := request:get-parameter('keyword', '')
    let $title := request:get-parameter('title', '')
    let $person := request:get-parameter('person', '')
    return
    <form
        class="form-horizontal indent"
        method="post"
        role="form"
    >
        <div class="well well-small search-box">
            <div class="row">
                <div class="col-md-8">
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
                                    name="keyword"
                                    type="text"
                                    value="{$keyword}"
                                />
                                <div class="input-group-btn">
                                    <!--<span data-template="app:keyboard-select-menu" data-template-input-id="keyword"/>-->
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
                                    name="title"
                                    type="text"
                                    value="{$title}"
                                />
                                <div class="input-group-btn">
                                    <!--<span data-template="app:keyboard-select-menu" data-template-input-id="title"/>-->
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
                                    name="person"
                                    type="text"
                                    value="{$person}"
                                />
                                <div class="input-group-btn">
                                    <!--<span data-template="app:keyboard-select-menu" data-template-input-id="author"/>-->
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--Collection-->
                    <div class="form-group">
                        <label
                            class="col-sm-2 col-md-3 control-label"
                            for="collection"
                        >
                            <i18n:text key="search_collection">Collection</i18n:text>:
                        </label>
                        <div class="col-sm-10 col-md-9">
                            <fieldset data-role="controlgroup">
                                <input type="checkbox" name="checkbox-bibl" id="checkbox-bibl" checked="True"/>
                                <label for="checkbox-bibl">
                                    <i18n:text key="search_bibliography">Bibliography</i18n:text>
                                </label>
                                <br/>
                                <input type="checkbox" name="checkbox-persons" id="checkbox-persons" checked="True"/>
                                <label for="checkbox-persons">
                                    <i18n:text key="search_person">Persons</i18n:text>
                                </label>
                            </fieldset>
                        </div>
                    </div>
                    <!--end col-->
                </div>
                <!--end row-->
            </div>
            <div class="pull-right">
                <button
                    class="btn btn-info"
                    type="submit"
                >
                    <i18n:text key="search_doit">Search</i18n:text>
                </button>
                <button
                    class="btn"
                    type="reset"
                >
                    <i18n:text key="search_clear">Clear</i18n:text>
                </button>
            </div>
            <br class="clearfix"/>
            <br/>
        </div>
    </form>
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
