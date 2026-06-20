package app.pages;

import js.html.Element;
import app.Dom.el;
import app.Data;
import app.Icons;
import app.Component;

/** Calendar page: post-reminder bar with tracked platforms + a month grid. */
class CalendarPage extends Component {
    var selectedDay:Null<Int> = 18;
    var reminderPeriod = "1w";
    var reminderOpen = false;
    var addPlatformOpen = false;
    var dismissed:Array<String> = [];
    var tracked:Array<String> = ["instagram", "twitter", "youtube", "linkedin"];

    static final weekDays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];

    public function new() super();

    override function build():Element {
        return el("div", {cls: "flex flex-col gap-4"}, [
            reminderBar(),
            el("div", {cls: "flex flex-col lg:flex-row gap-4 min-h-full"}, [
                el("div", {cls: "flex-1 flex flex-col gap-3 min-w-0"}, [calendarCard()])
            ])
        ]);
    }

    // ── Reminder bar ───────────────────────────────────────────────────
    function reminderBar():Element {
        var threshold = Data.reminderThresholds[reminderPeriod];
        var due = Data.platformStats.filter(p ->
            tracked.contains(p.id) && !dismissed.contains(p.id) && Data.platformLastPosted[p.id] >= threshold);

        return el("div", {cls: "bg-card border border-border rounded-xl p-3 flex flex-wrap items-center gap-3"}, [
            el("div", {cls: "flex items-center gap-2 shrink-0"}, [
                el("span", {cls: "text-accent"}, [Icons.bell(13)]),
                el("span", {cls: "text-xs font-semibold font-display", text: "Post Reminders"}),
                el("span", {cls: "text-xs text-muted-foreground", text: "— notify if no post in:"})
            ]),
            reminderDropdown(),
            el("div", {cls: "flex flex-wrap gap-2 flex-1 min-w-0 items-center"}, [
                chips(due),
                addPlatform()
            ])
        ]);
    }

    function reminderDropdown():Element {
        var label = Lambda.find(Data.reminderPeriods, p -> p.key == reminderPeriod).label;
        return el("div", {cls: "relative shrink-0"}, [
            el("button", {
                cls: "flex items-center gap-1.5 px-3 py-1.5 rounded-lg border border-border text-xs font-medium transition-all hover:border-primary/40",
                style: reminderOpen ? "border-color:rgba(0,229,255,0.4);color:#00E5FF" : null,
                onClick: () -> { reminderOpen = !reminderOpen; refresh(); }
            }, [
                label,
                el("span", {style: "transition:transform 0.2s;transform:" + (reminderOpen ? "rotate(180deg)" : "none")}, [Icons.chevronDown(11)])
            ]),
            reminderOpen ? el("div", {
                cls: "absolute left-0 mt-1 w-32 rounded-xl border border-border overflow-hidden z-20",
                style: "background:var(--popover);box-shadow:0 8px 32px rgba(0,0,0,0.5)"
            }, [
                for (opt in Data.reminderPeriods)
                    el("button", {
                        cls: "w-full text-left px-3 py-2 text-xs transition-colors hover:bg-white/5 font-display",
                        style: "color:" + (reminderPeriod == opt.key ? "#00E5FF" : "var(--foreground)")
                            + ";background:" + (reminderPeriod == opt.key ? "rgba(0,229,255,0.08)" : "transparent"),
                        text: opt.label,
                        onClick: () -> { reminderPeriod = opt.key; reminderOpen = false; dismissed = []; refresh(); }
                    })
            ]) : null
        ]);
    }

    function chips(due:Array<PlatformStat>):Element {
        if (tracked.length == 0)
            return el("span", {cls: "text-xs text-muted-foreground", text: "No platforms added — use + to track one"});
        if (due.length == 0)
            return el("span", {cls: "text-xs text-emerald-400 flex items-center gap-1"}, [
                Icons.checkCircle(11), "All tracked platforms are up to date"
            ]);
        return el("span", {style: "display:contents"}, [
            for (p in due)
                el("div", {
                    cls: "flex items-center gap-1.5 pl-2 pr-1 py-1 rounded-full text-xs font-medium",
                    style: 'background:${p.color}18;border:1px solid ${p.color}44;color:${p.color}'
                }, [
                    Icons.platform(p.id, 14),
                    el("span", {text: p.label}),
                    el("span", {cls: "text-xs opacity-60 ml-0.5", text: "· " + Data.platformLastPosted[p.id] + "d ago"}),
                    el("button", {
                        cls: "ml-1 rounded-full p-0.5 hover:bg-white/10 transition-colors opacity-60 hover:opacity-100",
                        onClick: () -> { dismissed.push(p.id); refresh(); }
                    }, [Icons.x(10)])
                ])
        ]);
    }

    function addPlatform():Element {
        return el("div", {cls: "relative"}, [
            el("button", {
                cls: "flex items-center gap-1 px-2 py-1 rounded-full text-xs font-medium border border-dashed transition-all hover:border-primary/60 hover:text-primary",
                style: "border-color:rgba(138,63,217,0.35);color:var(--muted-foreground)",
                onClick: () -> { addPlatformOpen = !addPlatformOpen; refresh(); }
            }, [Icons.plus(11), "Add"]),
            addPlatformOpen ? el("div", {
                cls: "absolute left-0 mt-1 w-40 rounded-xl border border-border overflow-hidden z-20",
                style: "background:var(--popover);box-shadow:0 8px 32px rgba(0,0,0,0.5)"
            }, [
                for (p in Data.platformStats) {
                    var isTracked = tracked.contains(p.id);
                    el("button", {
                        cls: "w-full flex items-center justify-between px-3 py-2 text-xs transition-colors hover:bg-white/5",
                        onClick: () -> {
                            if (isTracked) {
                                tracked.remove(p.id);
                                dismissed.remove(p.id);
                            } else tracked.push(p.id);
                            refresh();
                        }
                    }, [
                        el("span", {cls: "flex items-center gap-2", style: 'color:${p.color}'}, [Icons.platform(p.id, 14), p.label]),
                        isTracked ? el("span", {cls: "text-primary"}, [Icons.check(11)]) : null
                    ]);
                }
            ]) : null
        ]);
    }

    // ── Calendar grid ──────────────────────────────────────────────────
    function calendarCard():Element {
        return el("div", {cls: "bg-card border border-border rounded-xl p-4 flex flex-col", style: "min-height:420px"}, [
            el("div", {cls: "flex items-center justify-between mb-4"}, [
                el("div", {cls: "flex items-center gap-3"}, [
                    el("button", {cls: "w-7 h-7 rounded-lg bg-muted flex items-center justify-center hover:bg-primary/20 transition-colors"}, [Icons.chevronLeft(14)]),
                    el("h2", {cls: "text-base font-bold font-display", text: "June 2026"}),
                    el("button", {cls: "w-7 h-7 rounded-lg bg-muted flex items-center justify-center hover:bg-primary/20 transition-colors"}, [Icons.chevronRight(14)])
                ])
            ]),
            el("div", {cls: "grid grid-cols-7 mb-2"}, [
                for (d in weekDays) el("div", {cls: "text-center text-xs text-muted-foreground font-medium py-1", text: d})
            ]),
            el("div", {cls: "grid grid-cols-7 gap-1 flex-1"}, [
                for (cell in Data.calendarDays) dayCell(cell)
            ])
        ]);
    }

    function dayCell(cell:CalendarCell):Element {
        var cls = "relative rounded-lg p-1.5 flex flex-col items-center gap-1 transition-all duration-150";
        cls += cell.day == null ? " opacity-0 pointer-events-none" : " hover:bg-muted/60";
        if (selectedDay == cell.day) cls += " ring-1 ring-primary bg-primary/10";
        if (cell.day == 20) cls += " border border-accent/40";

        var numCls = "text-xs font-medium leading-none ";
        numCls += selectedDay == cell.day ? "text-primary" : (cell.day == 20 ? "text-accent" : "text-foreground/80");

        return el("button", {
            cls: cls,
            disabled: cell.day == null,
            onClick: cell.day == null ? null : (() -> { selectedDay = cell.day; refresh(); })
        }, [
            el("span", {cls: numCls, text: cell.day == null ? "" : Std.string(cell.day)}),
            cell.posts > 0 ? dots(cell.posts) : null
        ]);
    }

    function dots(count:Int):Element {
        var colors = ["#00E5FF", "#E040FB", "#7B2FBE", "#FF4060"];
        var n = Std.int(Math.min(count, 4));
        return el("div", {cls: "flex gap-0.5 flex-wrap justify-center"}, [
            for (i in 0...n) el("div", {cls: "w-1.5 h-1.5 rounded-full", style: 'background:${colors[i]}'})
        ]);
    }
}
