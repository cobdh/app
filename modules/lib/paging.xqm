xquery version "3.0";
(:~
 : Adds page numbers to large collections.
 :)
module namespace page="https://data.cobdh.org/page";

(:~
 : Build paging menu for search results, includes search string
 : $param @hits hits as nodes
 : $param @start start number passed from url
 : $param @perpage number of hits to show
:)
declare function page:pages(
    $hits as node()*,
    $collection as xs:string?,
    $start as xs:integer?,
    $perpage as xs:integer?
){
let $perpage := if($perpage) then xs:integer($perpage) else 20
let $start := if($start) then $start else 1
let $total-result-count := count($hits)
let $end :=
    if ($total-result-count lt $perpage) then
        $total-result-count
    else
        $start + $perpage
let $number-of-pages :=  xs:integer(ceiling($total-result-count div $perpage))
let $current-page := xs:integer(($start + $perpage) div $perpage)
(: get all parameters to pass to paging function, strip start parameter :)
let $url-params := replace(replace(request:get-query-string(), '&amp;start=\d+', ''),'start=\d+','')
let $param-string := if($url-params != '') then concat('?',$url-params,'&amp;start=') else '?start='
let $pagination-links :=
    (<div class="row alpha-pages" xmlns="http://www.w3.org/1999/xhtml">
        <div>
            {
            if($total-result-count gt $perpage) then
            <ul class="pagination pull-right">
                {(: Show 'Previous' for all but the 1st page of results :)
                    if ($current-page = 1) then ()
                    else <li><a href="{concat($param-string, $perpage * ($current-page - 2)) }">Prev</a></li>,
                    (: Show links to each page of results :)
                    let $max-pages-to-show := 8
                    let $padding := xs:integer(round($max-pages-to-show div 2))
                    let $start-page :=
                                  if ($current-page le ($padding + 1)) then
                                      1
                                  else $current-page - $padding
                    let $end-page :=
                                  if ($number-of-pages le ($current-page + $padding)) then
                                      $number-of-pages
                                  else $current-page + $padding - 1
                    for $page in ($start-page to $end-page)
                    let $newstart :=
                                  if($page = 1) then 1
                                  else $perpage * ($page - 1)
                    return
                        if ($newstart eq $start) then <li class="active"><a href="#" >{$page}</a></li>
                         else <li><a href="{concat($param-string, $newstart)}">{$page}</a></li>,
                    (: Shows 'Next' for all but the last page of results :)
                    if ($start + $perpage ge $total-result-count) then ()
                    else <li><a href="{concat($param-string, $start + $perpage)}">Next</a></li>
                }
            </ul>
            else
            ()
            }
        </div>
    </div>
    )
    return $pagination-links
};
