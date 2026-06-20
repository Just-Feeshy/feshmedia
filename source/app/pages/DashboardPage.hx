package app.pages;

import js.html.Element;
import app.Dom.el;
import app.Data;
import app.Icons;
import app.Component;
import app.components.HaxeCredit;

/** Overview page: per-platform engagement & follower cards with a period filter. */
class DashboardPage extends Component {
    var period = "week";
    var open = false;

    public function new() super(null, "w-full flex flex-col gap-5 pb-4");

    override function build():Element {
        return el("div", {cls: "w-full flex flex-col gap-5 pb-4"}, [
            header(),
            cards(),
            credit()
        ]);
    }

    function header():Element {
        var currentLabel = Lambda.find(Data.dashboardPeriods, p -> p.key == period).label;
        return el("div", {cls: "flex items-center justify-between"}, [
            el("div", null, [
                el("h2", {cls: "text-lg font-bold font-display", text: "Overview"}),
                el("p", {cls: "text-xs text-muted-foreground mt-0.5", text: "Total engagement & followers across all platforms"})
            ]),
            el("div", {cls: "relative"}, [
                el("button", {
                    cls: "flex items-center gap-2 px-4 py-2 rounded-xl border border-border text-sm font-medium transition-all hover:border-primary/40",
                    style: "background:rgba(255,255,255,0.04)",
                    onClick: () -> { open = !open; refresh(); }
                }, [
                    el("span", {cls: "font-display", text: currentLabel}),
                    el("span", {
                        cls: "text-muted-foreground",
                        style: "transition:transform 0.2s;transform:" + (open ? "rotate(180deg)" : "none")
                    }, [Icons.chevronDown(14)])
                ]),
                open ? dropdown() : null
            ])
        ]);
    }

    function dropdown():Element {
        return el("div", {
            cls: "absolute right-0 mt-1 w-40 rounded-xl border border-border overflow-hidden z-30",
            style: "background:var(--popover);box-shadow:0 8px 32px rgba(0,0,0,0.5)"
        }, [
            for (opt in Data.dashboardPeriods)
                el("button", {
                    cls: "w-full text-left px-4 py-2.5 text-sm transition-colors hover:bg-white/5 font-display",
                    style: "color:" + (period == opt.key ? "#00E5FF" : "var(--foreground)")
                        + ";background:" + (period == opt.key ? "rgba(0,229,255,0.08)" : "transparent"),
                    text: opt.label,
                    onClick: () -> { period = opt.key; open = false; refresh(); }
                })
        ]);
    }

    function cards():Element {
        return el("div", {
            cls: "grid gap-4",
            style: "grid-template-columns:repeat(auto-fill,minmax(260px,1fr))"
        }, [for (p in Data.platformStats) card(p)]);
    }

    function card(p:PlatformStat):Element {
        var d = Data.dashboardData(period, p.id);
        return el("div", {
            cls: "rounded-2xl border overflow-hidden flex flex-col",
            style: 'border-color:${p.color}44;background:linear-gradient(145deg,var(--card),var(--background))'
        }, [
            el("div", {cls: "h-1 w-full", style: 'background:linear-gradient(90deg,${p.color},${p.color}44)'}),
            el("div", {cls: "p-5 flex flex-col gap-5"}, [
                el("div", {cls: "flex items-center gap-2.5"}, [
                    el("div", {
                        cls: "w-9 h-9 rounded-xl flex items-center justify-center",
                        style: 'background:${p.color}22;color:${p.color}'
                    }, [Icons.platform(p.id, 15)]),
                    el("span", {cls: "font-bold text-base font-display", style: 'color:${p.color}', text: p.label})
                ]),
                el("div", {cls: "grid grid-cols-2 gap-3"}, [
                    statBox("Engagement", Icons.heart(10), Data.fmtK(d.engagement), p.color, d.engagementDelta),
                    statBox("Followers", Icons.users(10), "+" + Data.fmtK(d.followers), "var(--foreground)", d.followersDelta)
                ])
            ])
        ]);
    }

    function statBox(label:String, icon:Element, value:String, valueColor:String, delta:Float):Element {
        var up = delta >= 0;
        return el("div", {cls: "flex flex-col gap-1 p-3 rounded-xl", style: "background:rgba(255,255,255,0.04)"}, [
            el("div", {cls: "flex items-center gap-1 text-muted-foreground", style: "font-size:10px"}, [
                icon,
                el("span", {cls: "uppercase tracking-wide", text: label})
            ]),
            el("span", {cls: "text-2xl font-bold leading-none mt-1 font-display", style: 'color:${valueColor}', text: value}),
            el("span", {
                cls: "flex items-center gap-0.5 text-xs font-semibold mt-1 " + (up ? "text-emerald-400" : "text-red-400")
            }, [up ? Icons.arrowUp(10) : Icons.arrowDown(10), fmtDelta(delta) + "%"])
        ]);
    }

    function fmtDelta(d:Float):String {
        var a = Math.abs(d);
        return (a % 1 == 0) ? Std.string(Std.int(a)) : Std.string(a);
    }

    function credit():Element {
        return el("div", {cls: "relative w-full", style: "height:300px"}, [
            new HaxeCredit(0, 64).render()
        ]);
    }
}
