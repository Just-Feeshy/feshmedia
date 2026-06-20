package app;

import js.Browser.document;
import js.html.Element;

/**
 * Inline SVG icons in the Lucide style (stroke-based, 24×24 viewBox), plus the
 * brand glyphs and the Haxe logo used on the dashboard. Each function returns a
 * fresh <svg> element sized to `size` pixels, coloured via `currentColor`.
 */
class Icons {
    static inline var NS = "http://www.w3.org/2000/svg";

    static function svg(size:Int, inner:String):Element {
        var e = document.createElementNS(NS, "svg");
        e.setAttribute("width", Std.string(size));
        e.setAttribute("height", Std.string(size));
        e.setAttribute("viewBox", "0 0 24 24");
        e.setAttribute("fill", "none");
        e.setAttribute("stroke", "currentColor");
        e.setAttribute("stroke-width", "2");
        e.setAttribute("stroke-linecap", "round");
        e.setAttribute("stroke-linejoin", "round");
        e.setAttribute("style", "display:inline-block;flex-shrink:0;vertical-align:middle");
        e.innerHTML = inner;
        return cast e;
    }

    // ── Navigation / chrome ────────────────────────────────────────────
    public static function dashboard(s = 15) return svg(s,
        '<rect width="7" height="9" x="3" y="3" rx="1"/><rect width="7" height="5" x="14" y="3" rx="1"/><rect width="7" height="9" x="14" y="12" rx="1"/><rect width="7" height="5" x="3" y="16" rx="1"/>');

    public static function calendar(s = 15) return svg(s,
        '<path d="M8 2v4"/><path d="M16 2v4"/><rect width="18" height="18" x="3" y="4" rx="2"/><path d="M3 10h18"/>');

    public static function barChart(s = 15) return svg(s,
        '<line x1="18" x2="18" y1="20" y2="10"/><line x1="12" x2="12" y1="20" y2="4"/><line x1="6" x2="6" y1="20" y2="14"/>');

    public static function settings(s = 15) return svg(s,
        '<path d="M12.22 2h-.44a2 2 0 0 0-2 2v.18a2 2 0 0 1-1 1.73l-.43.25a2 2 0 0 1-2 0l-.15-.08a2 2 0 0 0-2.73.73l-.22.38a2 2 0 0 0 .73 2.73l.15.1a2 2 0 0 1 1 1.72v.51a2 2 0 0 1-1 1.74l-.15.09a2 2 0 0 0-.73 2.73l.22.38a2 2 0 0 0 2.73.73l.15-.08a2 2 0 0 1 2 0l.43.25a2 2 0 0 1 1 1.73V20a2 2 0 0 0 2 2h.44a2 2 0 0 0 2-2v-.18a2 2 0 0 1 1-1.73l.43-.25a2 2 0 0 1 2 0l.15.08a2 2 0 0 0 2.73-.73l.22-.39a2 2 0 0 0-.73-2.73l-.15-.08a2 2 0 0 1-1-1.74v-.5a2 2 0 0 1 1-1.74l.15-.09a2 2 0 0 0 .73-2.73l-.22-.38a2 2 0 0 0-2.73-.73l-.15.08a2 2 0 0 1-2 0l-.43-.25a2 2 0 0 1-1-1.73V4a2 2 0 0 0-2-2z"/><circle cx="12" cy="12" r="3"/>');

    public static function search(s = 13) return svg(s,
        '<circle cx="11" cy="11" r="8"/><path d="m21 21-4.3-4.3"/>');

    public static function bell(s = 14) return svg(s,
        '<path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/>');

    public static function plus(s = 12) return svg(s,
        '<path d="M5 12h14"/><path d="M12 5v14"/>');

    public static function x(s = 14) return svg(s,
        '<path d="M18 6 6 18"/><path d="m6 6 12 12"/>');

    public static function check(s = 11) return svg(s,
        '<path d="M20 6 9 17l-5-5"/>');

    public static function checkCircle(s = 11) return svg(s,
        '<circle cx="12" cy="12" r="10"/><path d="m9 12 2 2 4-4"/>');

    public static function chevronDown(s = 14) return svg(s, '<path d="m6 9 6 6 6-6"/>');
    public static function chevronLeft(s = 14) return svg(s, '<path d="m15 18-6-6 6-6"/>');
    public static function chevronRight(s = 14) return svg(s, '<path d="m9 18 6-6-6-6"/>');

    public static function arrowUp(s = 11) return svg(s,
        '<path d="m5 12 7-7 7 7"/><path d="M12 19V5"/>');
    public static function arrowDown(s = 11) return svg(s,
        '<path d="M12 5v14"/><path d="m19 12-7 7-7-7"/>');

    public static function send(s = 12) return svg(s,
        '<path d="m22 2-7 20-4-9-9-4Z"/><path d="M22 2 11 13"/>');

    public static function edit(s = 11) return svg(s,
        '<path d="M12 20h9"/><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4Z"/>');

    // ── Metrics / content ──────────────────────────────────────────────
    public static function heart(s = 10) return svg(s,
        '<path d="M19 14c1.49-1.46 3-3.21 3-5.5A5.5 5.5 0 0 0 16.5 3c-1.76 0-3 .5-4.5 2-1.5-1.5-2.74-2-4.5-2A5.5 5.5 0 0 0 2 8.5c0 2.3 1.5 4.05 3 5.5l7 7Z"/>');

    public static function users(s = 10) return svg(s,
        '<path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/>');

    public static function eye(s = 12) return svg(s,
        '<path d="M2 12s4-8 10-8 10 8 10 8-4 8-10 8-10-8-10-8z"/><circle cx="12" cy="12" r="3"/>');

    public static function message(s = 12) return svg(s,
        '<path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/>');

    public static function share(s = 12) return svg(s,
        '<circle cx="18" cy="5" r="3"/><circle cx="6" cy="12" r="3"/><circle cx="18" cy="19" r="3"/><line x1="8.59" x2="15.42" y1="13.51" y2="17.49"/><line x1="15.41" x2="8.59" y1="6.51" y2="10.49"/>');

    public static function bookmark(s = 12) return svg(s,
        '<path d="m19 21-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"/>');

    public static function link(s = 12) return svg(s,
        '<path d="M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71"/><path d="M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71"/>');

    public static function play(s = 24) return svg(s, '<polygon points="6 3 20 12 6 21 6 3"/>');
    public static function video(s = 16) return svg(s,
        '<path d="m22 8-6 4 6 4V8Z"/><rect width="14" height="12" x="2" y="6" rx="2"/>');
    public static function image(s = 24) return svg(s,
        '<rect width="18" height="18" x="3" y="3" rx="2" ry="2"/><circle cx="9" cy="9" r="2"/><path d="m21 15-3.086-3.086a2 2 0 0 0-2.828 0L6 21"/>');

    public static function grid(s = 14) return svg(s,
        '<rect width="7" height="7" x="3" y="3" rx="1"/><rect width="7" height="7" x="14" y="3" rx="1"/><rect width="7" height="7" x="14" y="14" rx="1"/><rect width="7" height="7" x="3" y="14" rx="1"/>');
    public static function list(s = 14) return svg(s,
        '<path d="M8 6h13"/><path d="M8 12h13"/><path d="M8 18h13"/><path d="M3 6h.01"/><path d="M3 12h.01"/><path d="M3 18h.01"/>');
    public static function filter(s = 12) return svg(s,
        '<polygon points="22 3 2 3 10 12.46 10 19 14 21 14 12.46 22 3"/>');
    public static function download(s = 12) return svg(s,
        '<path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="7 10 12 15 17 10"/><line x1="12" x2="12" y1="15" y2="3"/>');
    public static function upload(s = 12) return svg(s,
        '<path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" x2="12" y1="3" y2="15"/>');
    public static function moreHorizontal(s = 14) return svg(s,
        '<circle cx="12" cy="12" r="1"/><circle cx="19" cy="12" r="1"/><circle cx="5" cy="12" r="1"/>');

    // ── Brand glyphs ───────────────────────────────────────────────────
    public static function instagram(s = 14) return svg(s,
        '<rect width="20" height="20" x="2" y="2" rx="5" ry="5"/><path d="M16 11.37A4 4 0 1 1 12.63 8 4 4 0 0 1 16 11.37z"/><line x1="17.5" x2="17.51" y1="6.5" y2="6.5"/>');
    public static function twitter(s = 14) return svg(s,
        '<path d="M22 4s-.7 2.1-2 3.4c1.6 10-9.4 17.3-18 11.6 2.2.1 4.4-.6 6-2C3 15.5.5 9.6 3 5c2.2 2.6 5.6 4.1 9 4-.9-4.2 4-6.6 7-3.8 1.1 0 3-1.2 3-1.2z"/>');
    public static function youtube(s = 14) return svg(s,
        '<path d="M2.5 17a24.12 24.12 0 0 1 0-10 2 2 0 0 1 1.4-1.4 49.56 49.56 0 0 1 16.2 0A2 2 0 0 1 21.5 7a24.12 24.12 0 0 1 0 10 2 2 0 0 1-1.4 1.4 49.55 49.55 0 0 1-16.2 0A2 2 0 0 1 2.5 17"/><path d="m10 15 5-3-5-3z"/>');
    public static function linkedin(s = 14) return svg(s,
        '<path d="M16 8a6 6 0 0 1 6 6v7h-4v-7a2 2 0 0 0-2-2 2 2 0 0 0-2 2v7h-4v-7a6 6 0 0 1 6-6z"/><rect width="4" height="12" x="2" y="9"/><circle cx="4" cy="4" r="2"/>');

    /** Look up a platform brand icon by id ("instagram" etc.). */
    public static function platform(id:String, s = 14):Element {
        return switch (id) {
            case "instagram": instagram(s);
            case "twitter": twitter(s);
            case "youtube": youtube(s);
            case "linkedin": linkedin(s);
            default: instagram(s);
        }
    }

    /** Gradient-stroked Haxe logo (200×200 viewBox) used by HaxeCredit. */
    public static function haxeLogo(size = 160):Element {
        var e = document.createElementNS(NS, "svg");
        e.setAttribute("viewBox", "0 0 230 230");
        e.setAttribute("style", 'width:${size}px;height:${size}px;'
            + "filter:drop-shadow(0 0 22px rgba(0,229,255,0.4)) drop-shadow(0 0 48px rgba(224,64,251,0.25))");
        e.innerHTML = '<defs><linearGradient id="hx-outline-grad" x1="0%" y1="0%" x2="100%" y2="100%">'
            + '<stop offset="0%" stop-color="#00E5FF"/><stop offset="50%" stop-color="#7B2FBE"/><stop offset="100%" stop-color="#E040FB"/>'
            + '</linearGradient></defs>'
            + '<g style="fill:none;stroke:url(#hx-outline-grad);stroke-width:3;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:10" transform="matrix(.24008588 0 0 .24008588 -2.289055 -240.92061)">'
            + '<path d="m488.5212 1149.7881v-.1079l-443.5829-110.784h221.7874l221.7955 110.7839"/>'
            + '<path d="m488.5212 1149.7881v-.1079l443.5992-110.7839h-221.8119l-221.7874 110.7839"/>'
            + '<path d="m488.5212 1815.1521 443.5992 110.8938h-221.8119l-221.7874-111.0077"/>'
            + '<path d="m488.5212 1815.1521-443.5829 110.8938h221.7874l221.7955-111.0077"/>'
            + '<path d="m155.832 1482.469v-.126l-110.8937 443.7029v-221.7671l110.8937-221.9358"/>'
            + '<path d="m155.832 1482.469v-.126l-110.8937-443.4468v221.7854l110.8937 221.6614"/>'
            + '<path d="m821.2104 1482.469v-.126l110.8937-443.4468v221.7854l-110.8937 221.6614"/>'
            + '<path d="m821.2104 1482.469 110.8937 443.5687v-221.7589l-110.8937-221.9379"/>'
            + '<path d="m44.9383 1038.8962 443.5829 110.8918-332.6892 332.5062-110.8937-443.1721"/>'
            + '<path d="m44.9383 1926.0459 110.8937-443.5748 332.6891 332.437-443.5828 110.6863"/>'
            + '<path d="m932.1204 1038.8962-110.91 443.5546-332.6892-332.681 443.5992-110.6477"/>'
            + '<path d="m932.1204 1926.0459-443.5992-110.8856 332.6892-332.6892 110.91 443.1233"/>'
            + '<path d="m488.5212 1149.7881-332.6892 332.6809 332.6891 332.6831 332.6892-332.7013-332.6892-332.7726"/>'
            + '</g>';
        return cast e;
    }
}
