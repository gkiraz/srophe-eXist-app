(:~
 : This is the main XQuery which will (by default) be called by controller.xql
 : to process any URI ending with ".html". It receives the HTML from
 : the controller and passes it to the templating system.
 :)
xquery version "3.0";

module namespace namespace templates="http://exist-db.org/xquery/templates" ;

(: 
 : The following modules provide functions which will be called by the 
 : templating.
 :)
import module namespace config="http://syriaca.org//config" at "config.xqm";
import module namespace app="http://syriaca.org//templates" at "app.xql";
import module namespace place="http://syriaca.org//place" at "place.xqm";
import module namespace person="http://syriaca.org//person" at "person.xqm";
import module namespace browse="http://syriaca.org//browse" at "browse.xqm";
import module namespace search="http://syriaca.org//search" at "search.xqm";
import module namespace metadata="http://syriaca.org//metadata" at "metadata.xqm";
import module namespace admin="http://syriaca.org//admin" at "admin.xqm";
import module namespace geo="http://syriaca.org//geojson" at "geojson.xqm";
import module namespace search-form="http://syriaca.org//search-form" at "search-form.xqm";
import module namespace nav="http://syriaca.org//nav" at "nav.xqm";

declare option exist:serialize "method=html5 media-type=text/html enforce-xhtml=yes";

declare function templates:do-templates($data){
let $config := map {
    $templates:CONFIG_APP_ROOT := $config:app-root,
    $templates:CONFIG_STOP_ON_ERROR := true()
}
(:
 : We have to provide a lookup function to templates:apply to help it
 : find functions in the imported application modules. The templates
 : module cannot see the application modules, but the inline function
 : below does see them.
 :)
let $lookup := function($functionName as xs:string, $arity as xs:int) {
    try {
        function-lookup(xs:QName($functionName), $arity)
    } catch * {
        ()
    }
}
(:
 : The HTML is passed in the request from the controller.
 : Run it through the templating system and return the result.
 :)
let $content := $data
return
    templates:apply($content, $lookup, (), $config)
};