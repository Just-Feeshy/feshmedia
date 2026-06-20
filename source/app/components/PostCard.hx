package app.components;

import js.html.Element;
import app.Dom.el;
import app.Data;
import app.Icons;
import app.Component;

/** A ranked post-analytics card with an image carousel and a metric grid. */
class PostCard extends Component {
    final post:Post;
    public var rank:Int;
    public var sortKey:String;
    var slide = 0;

    // Carousel layers/controls, updated in place so slide changes cross-fade
    // (CSS easing) instead of rebuilding the card and snapping.
    var layers:Array<Element> = [];
    var dots:Array<Element> = [];
    var countBadge:Element;

    public function new(post:Post) {
        super();
        this.post = post;
        this.rank = 1;
        this.sortKey = "impressions";
    }

    static function metricIcon(key:String, s = 12):Element {
        return switch (key) {
            case "impressions": Icons.eye(s);
            case "profileVisits": Icons.users(s);
            case "likes": Icons.heart(s);
            case "comments": Icons.message(s);
            case "reposts": Icons.share(s);
            case "saves": Icons.bookmark(s);
            case "linkClicks": Icons.link(s);
            default: Icons.eye(s);
        }
    }

    /** Cross-fade to slide `n` by easing layer opacities in place (no rebuild). */
    function setSlide(n:Int, total:Int):Void {
        slide = n;
        for (i in 0...layers.length) layers[i].style.opacity = (i == slide) ? "1" : "0";
        for (i in 0...dots.length) {
            dots[i].style.width = (i == slide) ? "16px" : "6px";
            dots[i].style.background = (i == slide) ? "#00E5FF" : "rgba(255,255,255,0.4)";
        }
        if (countBadge != null) countBadge.textContent = (slide + 1) + " / " + total;
    }

    override function build():Element {
        var border = post.platforms.length > 1 ? "rgba(138,63,217,0.35)" : Data.platformColor(post.platforms[0]) + "44";
        return el("div", {
            cls: "bg-card border rounded-2xl overflow-hidden flex flex-col transition-all duration-200 hover:scale-[1.01] hover:shadow-2xl",
            style: 'border-color:${border}'
        }, [
            post.media != null ? mediaArea() : noMediaHeader(),
            body()
        ]);
    }

    function mediaArea():Element {
        var m = post.media;
        var total = m.gradients.length;
        var kids:Array<Dynamic> = [];

        if (m.type == "video") {
            kids.push(el("div", {cls: 'absolute inset-0 bg-gradient-to-br ${m.gradients[0]}'}));
            kids.push(el("div", {cls: "absolute inset-0 flex items-center justify-center"}, [
                el("div", {
                    cls: "w-14 h-14 rounded-full flex items-center justify-center",
                    style: "background:rgba(0,0,0,0.45);backdrop-filter:blur(4px)"
                }, [el("span", {cls: "text-white ml-1"}, [Icons.play(24)])])
            ]));
            kids.push(el("div", {
                cls: "absolute bottom-3 left-3 px-2 py-0.5 rounded-full text-xs font-medium flex items-center gap-1",
                style: "background:rgba(0,0,0,0.6);color:#FF4060;backdrop-filter:blur(4px)"
            }, [Icons.video(10), m.duration]));
        } else {
            // Stack every gradient as its own layer; cross-fade via opacity
            // (eased with transition-opacity) since gradients can't transition.
            layers = [for (i in 0...total)
                el("div", {
                    cls: 'absolute inset-0 bg-gradient-to-br ${m.gradients[i]} transition-opacity duration-500 ease-in-out',
                    style: "opacity:" + (i == slide ? "1" : "0")
                })];
            for (l in layers) kids.push(l);
            kids.push(el("div", {cls: "absolute inset-0 opacity-30 pointer-events-none", style: "background-image:radial-gradient(circle at 30% 40%,rgba(255,255,255,0.15) 0%,transparent 60%)"}));

            if (total > 1) {
                kids.push(el("button", {
                    cls: "absolute left-2 top-1/2 -translate-y-1/2 w-7 h-7 rounded-full flex items-center justify-center transition-opacity hover:opacity-100 opacity-70",
                    style: "background:rgba(0,0,0,0.5);backdrop-filter:blur(4px)",
                    onClick: () -> setSlide((slide - 1 + total) % total, total)
                }, [el("span", {cls: "text-white"}, [Icons.chevronLeft(14)])]));
                kids.push(el("button", {
                    cls: "absolute right-2 top-1/2 -translate-y-1/2 w-7 h-7 rounded-full flex items-center justify-center transition-opacity hover:opacity-100 opacity-70",
                    style: "background:rgba(0,0,0,0.5);backdrop-filter:blur(4px)",
                    onClick: () -> setSlide((slide + 1) % total, total)
                }, [el("span", {cls: "text-white"}, [Icons.chevronRight(14)])]));
                dots = [for (di in 0...total) el("button", {
                    cls: "rounded-full transition-all duration-200 ease-in-out",
                    style: "width:" + (di == slide ? "16px" : "6px") + ";height:6px;background:" + (di == slide ? "#00E5FF" : "rgba(255,255,255,0.4)"),
                    onClick: () -> setSlide(di, total)
                })];
                kids.push(el("div", {cls: "absolute bottom-3 left-1/2 -translate-x-1/2 flex gap-1.5"}, dots));
                countBadge = el("div", {
                    cls: "absolute top-3 left-3 px-2 py-0.5 rounded-full text-xs font-medium font-display",
                    style: "background:rgba(0,0,0,0.55);color:#E2D9FF;backdrop-filter:blur(4px)",
                    text: (slide + 1) + " / " + total
                });
                kids.push(countBadge);
            }
        }

        // Rank badge — hidden for multi-image carousels (count badge takes its place).
        if (!(m.type == "image" && total > 1)) {
            kids.push(el("div", {
                cls: "absolute top-3 left-3 w-8 h-8 rounded-full flex items-center justify-center text-xs font-bold font-display",
                style: "background:rgba(0,0,0,0.55);color:#E2D9FF;backdrop-filter:blur(4px)",
                text: Std.string(rank)
            }));
        }

        kids.push(el("div", {cls: "absolute top-3 right-3 flex gap-1"}, [
            for (pl in post.platforms) el("div", {
                cls: "w-7 h-7 rounded-full flex items-center justify-center",
                style: 'background:${Data.platformColor(pl)}cc;backdrop-filter:blur(4px)'
            }, [el("span", {cls: "text-white flex", style: "color:#fff"}, [Icons.platform(pl, 14)])])
        ]));

        return el("div", {cls: "relative w-full overflow-hidden", style: "height:200px"}, kids);
    }

    function noMediaHeader():Element {
        var first = post.platforms[0];
        return el("div", {cls: "relative w-full flex items-center px-5 pt-5 pb-2 gap-3"}, [
            el("span", {cls: "text-3xl font-bold opacity-15 tabular-nums leading-none font-display", text: StringTools.lpad(Std.string(rank), "0", 2)}),
            el("div", {cls: "h-px flex-1", style: 'background:linear-gradient(90deg,${Data.platformColor(first)}66,transparent)'}),
            el("div", {cls: "flex gap-1"}, [
                for (pl in post.platforms) el("div", {
                    cls: "w-6 h-6 rounded-full flex items-center justify-center",
                    style: 'background:${Data.platformColor(pl)}22;color:${Data.platformColor(pl)}'
                }, [Icons.platform(pl, 14)])
            ])
        ]);
    }

    function body():Element {
        return el("div", {cls: "flex flex-col gap-3 p-4 flex-1"}, [
            el("div", null, [
                el("p", {cls: "text-sm font-semibold leading-snug text-foreground/95 line-clamp-2", text: post.caption}),
                el("div", {cls: "flex flex-wrap items-center gap-1.5 mt-2"}, [
                    [for (pl in post.platforms) PlatformBadge.make(pl)],
                    el("span", {cls: "text-xs text-muted-foreground", text: post.date})
                ])
            ]),
            el("div", {cls: "h-px w-full", style: "background:rgba(138,63,217,0.15)"}),
            el("div", {cls: "grid grid-cols-2 gap-1.5"}, [
                for (col in Data.metricCols) metricRow(col)
            ])
        ]);
    }

    function metricRow(col:MetricCol):Element {
        var active = col.key == sortKey;
        return el("div", {
            cls: "flex items-center justify-between px-3 py-2 rounded-lg",
            style: "background:" + (active ? "rgba(0,229,255,0.08)" : "rgba(255,255,255,0.03)")
                + ";border:1px solid " + (active ? "rgba(0,229,255,0.22)" : "transparent")
        }, [
            el("div", {cls: "flex items-center gap-1.5 " + (active ? "text-primary" : "text-muted-foreground"), style: "font-size:11px"}, [
                metricIcon(col.key), el("span", {text: col.label})
            ]),
            el("span", {
                cls: "text-sm font-bold tabular-nums font-display",
                style: "color:" + (active ? "#00E5FF" : "var(--foreground)"),
                text: Data.fmtK(Data.metricValue(post, col.key))
            })
        ]);
    }
}
