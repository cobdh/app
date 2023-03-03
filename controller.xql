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
    or $exist:path eq "/validation"
    or $exist:path eq "/contribution"
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
else if (matches($exist:path, '/bibl/\d+')) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/views/bibl/record.html"/>
        <view><forward url="{$exist:controller}/modules/template.xql"/></view>
    </dispatch>
else if (matches($exist:path, '/editors/[a-zA-Z_]+')) then
    <dispatch xmlns="http://exist.sourceforge.net/NS/exist">
        <forward url="{$exist:controller}/views/editors/record.html"/>
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
