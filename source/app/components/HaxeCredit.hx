package app.components;

import js.html.Element;
import app.Dom.el;
import app.Icons;

/**
 * The "Powered with Haxe" credit block — the gradient Haxe logo above a
 * gradient wordmark and subtitle. Positioned at an absolute (x, y) offset
 * given to the constructor, so callers can drop it anywhere inside a
 * relatively-positioned container.
 */
class HaxeCredit {
    final x:Int;
    final y:Int;

    public function new(x:Int, y:Int) {
        this.x = x;
        this.y = y;
    }

    /** Build the credit block element, absolutely positioned at (x, y). It
        spans to the parent's right edge so the column stays centered between
        the x offset and the edge. */
    public function render():Element {
        return el("div", {
            cls: "flex flex-col items-center justify-center gap-4 select-none",
            style: 'position:absolute;left:${x}px;right:0;top:${y}px'
        }, [
            Icons.haxeLogo(160),
            el("div", {cls: "flex flex-col items-center gap-1"}, [
                el("span", {
                    cls: "text-sm font-bold tracking-widest uppercase font-display",
                    style: "background:linear-gradient(90deg,#00E5FF,#7B2FBE,#E040FB);"
                        + "-webkit-background-clip:text;background-clip:text;-webkit-text-fill-color:transparent",
                    text: "Powered with Haxe"
                }),
                el("span", {
                    cls: "text-xs text-muted-foreground",
                    text: "Built using the Haxe programming language"
                })
            ])
        ]);
    }
}
