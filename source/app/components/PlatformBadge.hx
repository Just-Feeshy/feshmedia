package app.components;

import js.html.Element;
import app.Dom.el;
import app.Data;
import app.Icons;

/** Small rounded platform chip (brand icon + platform id), tinted per platform. */
class PlatformBadge {
    public static function make(platform:String):Element {
        var c = Data.platformColor(platform);
        return el("span", {
            cls: "flex items-center gap-1 px-2 py-0.5 rounded-full text-xs font-medium",
            style: 'background:${c}22;color:${c};border:1px solid ${c}44'
        }, [Icons.platform(platform, 14), platform]);
    }
}
