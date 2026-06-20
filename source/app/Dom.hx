package app;

import js.Browser.document;
import js.html.Element;
import js.html.InputElement;

/**
 * Attributes accepted by `Dom.el`. Every field is optional so call sites only
 * specify what they need. Event handlers receive plain values, not DOM events.
 */
typedef Attr = {
    ?cls:String,
    ?style:String,
    ?text:String,
    ?html:String,
    ?type:String,
    ?placeholder:String,
    ?value:String,
    ?rows:Int,
    ?disabled:Bool,
    ?title:String,
    ?ariaLive:String,
    ?onClick:Void->Void,
    ?onInput:String->Void,
    ?onStop:Bool, // stop click propagation on this element
};

/**
 * Tiny hyperscript-style DOM builder. Keeps the renderer modules declarative
 * without pulling in a framework — `el("div", {cls: "..."}, [child, "text"])`.
 */
class Dom {
    public static function el(tag:String, ?a:Attr, ?kids:Array<Dynamic>):Element {
        var e = document.createElement(tag);

        if (a != null) {
            if (a.cls != null) e.className = a.cls;
            if (a.style != null) e.setAttribute("style", a.style);
            if (a.text != null) e.textContent = a.text;
            if (a.html != null) e.innerHTML = a.html;
            if (a.type != null) e.setAttribute("type", a.type);
            if (a.placeholder != null) e.setAttribute("placeholder", a.placeholder);
            if (a.value != null) (cast e : InputElement).value = a.value;
            if (a.rows != null) e.setAttribute("rows", Std.string(a.rows));
            if (a.disabled == true) e.setAttribute("disabled", "");
            if (a.title != null) e.setAttribute("title", a.title);
            if (a.ariaLive != null) e.setAttribute("aria-live", a.ariaLive);
            if (a.onClick != null) {
                e.addEventListener("click", function(ev) {
                    ev.stopPropagation();
                    a.onClick();
                });
            }
            if (a.onInput != null) {
                e.addEventListener("input", function(ev)
                    a.onInput((cast ev.target : InputElement).value));
            }
            if (a.onStop == true) {
                e.addEventListener("click", function(ev) ev.stopPropagation());
            }
        }

        append(e, kids);
        return e;
    }

    /** Append a mixed list of Elements / Strings / nested arrays / nulls. */
    public static function append(parent:Element, kids:Array<Dynamic>):Void {
        if (kids == null) return;
        for (k in kids) {
            if (k == null) continue;
            if (Std.isOfType(k, String)) {
                parent.appendChild(document.createTextNode(k));
            } else if (Std.isOfType(k, Array)) {
                append(parent, cast k);
            } else {
                parent.appendChild(cast k);
            }
        }
    }

    /** Replace all children of `parent` with `kids`. */
    public static function fill(parent:Element, kids:Array<Dynamic>):Void {
        parent.innerHTML = "";
        append(parent, kids);
    }
}
