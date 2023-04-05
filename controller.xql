xquery version "3.0";

declare variable $exist:path external;
declare variable $exist:resource external;
declare variable $exist:controller external;
declare variable $exist:prefix external;
declare variable $exist:root external;

if ($exist:path eq '') then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <redirect url="{request:get-uri()}/"/>
    </dispatch>
else if ($exist:path eq "/" or $exist:path eq "index.html") then
    (: forward root path to index.xql :)
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="index.html"/>
        <view><forward url="{$exist:controller}/modules/template.xql"/></view>
    </dispatch>
else if ($exist:path eq "/impressum"
    or $exist:path eq "/contribution"
    or $exist:path eq "/search"
    or $exist:path eq "/validation"
    ) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="views/{$exist:path}.html"/>
        <view><forward url="{$exist:controller}/modules/template.xql"/></view>
    </dispatch>
else if ($exist:path eq "/bibl"
    or $exist:path eq "/editors"
    or $exist:path eq "/persons"
    ) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="views/{$exist:path}/index.html"/>
        <view><forward url="{$exist:controller}/modules/template.xql"/></view>
    </dispatch>
else if (matches($exist:path, '/(bibl|editors|authors|persons)/[a-zA-Z_0-9%]+')) then
    (: Require % to match encoded names like Řoutil2017 -> %C5%98outil2017
       % is required to match at the beginning like above.

       Hint: MaclerFr%C3%A9d%C3%A9ric works without %
    :)
    (: TODO: IMPROVE REGEX :)
    if(equals(lower-case(request:get-parameter('format', '')) ,'tei')) then
        <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
            <forward url="{$exist:controller}/modules/export.xql">
                <add-parameter name="format" value="tei"/>
                <add-parameter name="collection" value="{tokenize($exist:path, '/')[2]}"/>
            </forward>
        </dispatch>
    else
        <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
            (: THERE MUST BE A BETTER WAY :)
            <forward url="{$exist:controller}/views/{tokenize($exist:path, '/')[2]}/record.html"/>
            <view><forward url="{$exist:controller}/modules/template.xql"/></view>
        </dispatch>
else if (ends-with($exist:resource, ".html")) then
    (: the html page is run through template.xql to expand templates :)
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <view>
            <forward url="{$exist:controller}/modules/template.xql"/>
        </view>
        <error-handler>
            <forward url="{$exist:controller}/error-page.html" method="get"/>
            <forward url="{$exist:controller}/modules/template.xql"/>
        </error-handler>
    </dispatch>
(: Resource paths starting with $shared are loaded from the shared-resources app :)
else if (contains($exist:path, "/$shared/")) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="/shared-resources/{substring-after($exist:path, '/$shared/')}">
            <set-header name="Cache-Control" value="max-age=3600, must-revalidate"/>
        </forward>
    </dispatch>
else if (contains($exist:path, "/$resources/")) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="/cobdh-data/{substring-after($exist:path, '/$resources/')}">
            <set-header name="Cache-Control" value="max-age=3600, must-revalidate"/>
        </forward>
    </dispatch>
else
    (: everything else is passed through :)
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <cache-control cache="yes"/>
    </dispatch>
