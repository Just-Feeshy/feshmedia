package app;

import js.html.Element;
import js.html.InputElement;
import app.Dom.el;
import app.Data;
import app.Icons;
import app.Component;
import app.pages.DashboardPage;
import app.pages.CalendarPage;
import app.pages.AnalyticsPage;
import app.pages.SettingsPage;

typedef NavItem = {id:String, label:String, icon:Void->Element};

/**
 * Top-level application shell: nav bar, search, notifications panel,
 * new-post modal, status bar, and page routing. Pages are persistent
 * component instances so their state survives shell re-renders.
 */
class App extends Component {
    static final navItems:Array<NavItem> = [
        {id: "dashboard", label: "Dashboard", icon: () -> Icons.dashboard(15)},
        {id: "calendar", label: "Calendar", icon: () -> Icons.calendar(15)},
        {id: "analytics", label: "Analytics", icon: () -> Icons.barChart(15)},
        {id: "settings", label: "Settings", icon: () -> Icons.settings(15)}
    ];

    final pages:Map<String, Component>;

    var page = "dashboard";
    var searchVal = "";
    var notifOpen = false;
    var notifTab = "schedule";
    var notifications:Array<Notification>;

    var newPostOpen = false;
    var npCaption = "";
    var npPlatforms:Array<String> = [];
    var npDate = "";
    var npTime = "";

    public function new() {
        super();
        notifications = Data.notifications();
        pages = [
            "dashboard" => new DashboardPage(),
            "calendar" => new CalendarPage(),
            "analytics" => new AnalyticsPage(),
            "settings" => new SettingsPage()
        ];
        for (p in pages) p.refresh();
    }

    override function build():Element {
        return el("div", {
            cls: "w-full h-screen flex flex-col overflow-hidden font-sans",
            style: "background:var(--background)"
        }, [
            el("div", {cls: "absolute top-0 left-0 right-0 h-px", style: "background:linear-gradient(90deg,transparent,#00E5FF66,#E040FB66,transparent)"}),
            header(),
            el("main", {cls: "flex-1 overflow-y-auto overflow-x-hidden p-3 sm:p-4 flex flex-col no-scrollbar"}, [
                el("div", {cls: "flex-1"}, [pages[page].root])
            ]),
            statusBar(),
            newPostOpen ? modal() : null
        ]);
    }

    // ── Header ─────────────────────────────────────────────────────────
    function header():Element {
        return el("header", {
            cls: "h-12 shrink-0 flex items-center px-3 gap-2 border-b border-border relative z-20",
            style: "background:var(--chrome);backdrop-filter:blur(12px)"
        }, [
            nav(),
            page == "analytics" ? searchBox() : null,
            actions()
        ]);
    }

    function nav():Element {
        return el("nav", {cls: "flex items-center gap-0.5 ml-1 overflow-x-auto no-scrollbar"}, [
            for (item in navItems) {
                var active = page == item.id;
                el("button", {
                    cls: "flex items-center gap-1.5 px-2.5 py-1.5 rounded-lg text-xs font-medium transition-all duration-150 shrink-0 "
                        + (active ? "text-foreground" : "text-muted-foreground hover:text-foreground/80 hover:bg-white/5"),
                    style: active ? "background:linear-gradient(135deg,rgba(0,229,255,0.15),rgba(224,64,251,0.15));color:#00E5FF;box-shadow:0 0 0 1px rgba(0,229,255,0.2)" : null,
                    onClick: () -> { page = item.id; refresh(); }
                }, [item.icon(), el("span", {cls: "hidden md:inline", text: item.label})]);
            }
        ]);
    }

    function searchBox():Element {
        var input = el("input", {
            placeholder: "Search posts, media...",
            value: searchVal,
            cls: "w-full pl-8 pr-3 py-1.5 rounded-lg text-xs bg-muted/60 border border-border text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-1 focus:ring-primary/50 transition-all",
            onInput: v -> searchVal = v // store only; no re-render so focus is kept
        });
        return el("div", {cls: "flex-1 max-w-xs ml-auto relative hidden sm:block"}, [
            el("span", {cls: "absolute left-2.5 top-1/2 -translate-y-1/2 text-muted-foreground pointer-events-none"}, [Icons.search(13)]),
            input
        ]);
    }

    function actions():Element {
        return el("div", {cls: "flex items-center gap-1.5 shrink-0 ml-auto sm:ml-0"}, [
            el("div", {cls: "relative"}, [
                el("button", {
                    cls: "relative w-7 h-7 rounded-lg bg-muted/60 flex items-center justify-center hover:bg-muted transition-colors",
                    onClick: () -> { notifOpen = !notifOpen; refresh(); }
                }, [
                    el("span", {cls: notifOpen ? "text-primary" : "text-muted-foreground"}, [Icons.bell(14)]),
                    notifications.filter(n -> !n.read).length > 0
                        ? el("span", {cls: "absolute top-1 right-1 w-1.5 h-1.5 rounded-full bg-accent"}) : null
                ]),
                notifOpen ? notifPanel() : null
            ]),
            el("button", {
                cls: "hidden sm:flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-semibold transition-opacity hover:opacity-90",
                style: "background:linear-gradient(135deg,#00E5FF,#7B2FBE);color:#0B0620",
                onClick: () -> { newPostOpen = true; refresh(); }
            }, [Icons.plus(12), el("span", {cls: "hidden md:inline", text: "New Post"})]),
            el("button", {
                cls: "flex sm:hidden w-7 h-7 items-center justify-center rounded-lg text-xs font-semibold",
                style: "background:linear-gradient(135deg,#00E5FF,#7B2FBE);color:#0B0620",
                onClick: () -> { newPostOpen = true; refresh(); }
            }, [Icons.plus(14)]),
            el("div", {
                cls: "w-7 h-7 rounded-full flex items-center justify-center text-xs font-bold cursor-pointer font-display",
                style: "background:linear-gradient(135deg,#E040FB,#7B2FBE);color:white",
                text: "F"
            })
        ]);
    }

    // ── Notifications panel ────────────────────────────────────────────
    function notifPanel():Element {
        var tabs = [
            {key: "schedule", label: "When to Post", icon: () -> Icons.calendar(11), color: "#00E5FF"},
            {key: "followers", label: "Followers", icon: () -> Icons.users(11), color: "#E040FB"},
            {key: "engagement", label: "Likes & Comments", icon: () -> Icons.heart(11), color: "#7B2FBE"}
        ];
        var activeTab = Lambda.find(tabs, t -> t.key == notifTab);
        var items = notifications.filter(n -> n.category == notifTab);
        var unreadTotal = notifications.filter(n -> !n.read).length;

        return el("div", {
            cls: "absolute right-0 mt-2 w-80 rounded-2xl border border-border overflow-hidden z-40",
            style: "background:var(--card);box-shadow:0 16px 48px rgba(0,0,0,0.6),0 0 0 1px rgba(0,229,255,0.08)"
        }, [
            el("div", {cls: "flex items-center justify-between px-4 py-3 border-b border-border"}, [
                el("div", {cls: "flex items-center gap-2"}, [
                    el("span", {cls: "text-primary"}, [Icons.bell(13)]),
                    el("span", {cls: "text-xs font-bold font-display", text: "Notifications"}),
                    unreadTotal > 0 ? el("span", {cls: "px-1.5 py-0.5 rounded-full text-xs font-bold", style: "background:rgba(224,64,251,0.2);color:#E040FB", text: Std.string(unreadTotal)}) : null
                ]),
                el("button", {cls: "text-xs text-muted-foreground hover:text-primary transition-colors", text: "Mark all read", onClick: markAllRead})
            ]),
            el("div", {cls: "flex border-b border-border"}, [
                for (tab in tabs) {
                    var unread = notifications.filter(n -> n.category == tab.key && !n.read).length;
                    var isActive = notifTab == tab.key;
                    el("button", {
                        cls: "flex-1 flex items-center justify-center gap-1 py-2.5 text-xs font-medium transition-all relative",
                        style: "color:" + (isActive ? tab.color : "var(--muted-foreground)"),
                        onClick: () -> { notifTab = tab.key; refresh(); }
                    }, [
                        tab.icon(),
                        el("span", {cls: "hidden sm:inline", text: tab.label}),
                        unread > 0 ? el("span", {cls: "w-4 h-4 rounded-full flex items-center justify-center font-bold", style: 'background:${tab.color}30;color:${tab.color};font-size:9px', text: Std.string(unread)}) : null,
                        isActive ? el("div", {cls: "absolute bottom-0 left-0 right-0 h-0.5 rounded-full", style: 'background:${tab.color}'}) : null
                    ]);
                }
            ]),
            el("div", {cls: "flex flex-col max-h-64 overflow-y-auto no-scrollbar"},
                items.length == 0
                    ? [el("div", {cls: "flex flex-col items-center justify-center py-8 gap-2"}, [
                        el("span", {style: 'color:${activeTab.color};opacity:0.4'}, [activeTab.icon()]),
                        el("span", {cls: "text-xs text-muted-foreground", text: "No notifications here"})
                    ])]
                    : [for (n in items) notifRow(n, activeTab.color)]
            ),
            el("div", {cls: "px-4 py-2.5 border-t border-border"}, [
                el("button", {cls: "w-full text-center text-xs text-muted-foreground hover:text-primary transition-colors", text: "Clear all notifications", onClick: markAllRead})
            ])
        ]);
    }

    function notifRow(n:Notification, accent:String):Element {
        var c = Data.platformColor(n.platform);
        return el("button", {
            cls: "w-full flex items-start gap-3 px-4 py-3 text-left transition-colors hover:bg-white/5 border-b border-border last:border-0",
            style: "background:" + (n.read ? "transparent" : '${accent}08'),
            onClick: () -> { n.read = true; refresh(); }
        }, [
            el("div", {cls: "w-7 h-7 rounded-full flex items-center justify-center shrink-0 mt-0.5", style: 'background:${c}22;color:${c}'}, [Icons.platform(n.platform, 14)]),
            el("div", {cls: "flex-1 min-w-0"}, [
                el("div", {cls: "flex items-center justify-between gap-2"}, [
                    el("span", {cls: "text-xs font-semibold truncate", style: "color:" + (n.read ? "var(--muted-foreground)" : "var(--foreground)"), text: n.title}),
                    el("span", {cls: "text-xs text-muted-foreground shrink-0", text: n.time})
                ]),
                el("p", {cls: "text-xs text-muted-foreground mt-0.5 line-clamp-2", text: n.desc})
            ]),
            !n.read ? el("div", {cls: "w-1.5 h-1.5 rounded-full shrink-0 mt-1.5", style: 'background:${accent}'}) : null
        ]);
    }

    function markAllRead():Void {
        for (n in notifications) n.read = true;
        refresh();
    }

    // ── Status bar ─────────────────────────────────────────────────────
    function statusBar():Element {
        return el("div", {cls: "h-6 shrink-0 flex items-center px-4 gap-4 border-t border-border", style: "background:var(--chrome)"}, [
            el("div", {cls: "flex items-center gap-1.5"}, [
                el("div", {cls: "w-1.5 h-1.5 rounded-full bg-emerald-400 animate-pulse"}),
                el("span", {cls: "text-xs text-muted-foreground", text: "All platforms connected"})
            ]),
            el("span", {cls: "text-xs text-muted-foreground ml-auto", text: "v2.4.1 · Postiz Desktop"})
        ]);
    }

    // ── New Post modal ─────────────────────────────────────────────────
    function modal():Element {
        var counter = el("div", {cls: "text-right text-xs text-muted-foreground", text: npCaption.length + " / 2200"});
        var caption = el("textarea", {
            rows: 4,
            placeholder: "Write your post caption...",
            value: npCaption,
            cls: "w-full resize-none px-3 py-2.5 rounded-xl text-sm bg-muted/50 border border-border text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-1 focus:ring-primary/50 transition-all leading-relaxed",
            onInput: v -> { npCaption = v; counter.textContent = npCaption.length + " / 2200"; }
        });

        return el("div", {
            cls: "fixed inset-0 z-50 flex items-center justify-center p-4",
            style: "background:rgba(0,0,0,0.7);backdrop-filter:blur(6px)",
            onClick: () -> { newPostOpen = false; refresh(); }
        }, [
            el("div", {
                cls: "w-full max-w-md rounded-2xl border border-border flex flex-col overflow-hidden",
                style: "background:var(--card);box-shadow:0 24px 64px rgba(0,0,0,0.7),0 0 0 1px rgba(0,229,255,0.12)",
                onStop: true
            }, [
                el("div", {cls: "flex items-center justify-between px-5 py-4 border-b border-border"}, [
                    el("div", {cls: "flex items-center gap-2"}, [
                        el("div", {cls: "w-6 h-6 rounded-lg flex items-center justify-center", style: "background:linear-gradient(135deg,#00E5FF,#7B2FBE)"}, [el("span", {style: "color:#0B0620"}, [Icons.plus(13)])]),
                        el("span", {cls: "text-sm font-bold font-display", text: "New Post"})
                    ]),
                    el("button", {cls: "text-muted-foreground hover:text-foreground transition-colors", onClick: () -> { newPostOpen = false; refresh(); }}, [Icons.x(16)])
                ]),
                el("div", {cls: "flex flex-col gap-4 p-5"}, [
                    el("div", {cls: "flex flex-col gap-1.5"}, [
                        el("label", {cls: "text-xs font-medium text-muted-foreground uppercase tracking-wide", text: "Caption"}),
                        caption,
                        counter
                    ]),
                    el("div", {cls: "flex flex-col gap-1.5"}, [
                        el("label", {cls: "text-xs font-medium text-muted-foreground uppercase tracking-wide", text: "Platforms"}),
                        el("div", {cls: "flex flex-wrap gap-2"}, [
                            for (pl in Data.platformIds) platformToggle(pl)
                        ])
                    ]),
                    el("div", {cls: "flex gap-3"}, [
                        dateField("Date", "date", npDate, v -> npDate = v),
                        dateField("Time", "time", npTime, v -> npTime = v)
                    ])
                ]),
                el("div", {cls: "flex gap-2 px-5 pb-5"}, [
                    el("button", {cls: "flex-1 py-2.5 rounded-xl text-xs border border-border text-muted-foreground hover:text-foreground hover:border-border/60 transition-colors", text: "Cancel", onClick: () -> { newPostOpen = false; refresh(); }}),
                    el("button", {
                        cls: "flex items-center justify-center gap-1.5 flex-1 py-2.5 rounded-xl text-xs font-semibold transition-opacity hover:opacity-90",
                        style: "background:linear-gradient(135deg,#00E5FF,#7B2FBE);color:#0B0620",
                        onClick: schedulePost
                    }, [Icons.send(12), "Schedule Post"])
                ])
            ])
        ]);
    }

    function platformToggle(pl:String):Element {
        var on = npPlatforms.contains(pl);
        var c = Data.platformColor(pl);
        return el("button", {
            cls: "flex items-center gap-1.5 px-3 py-1.5 rounded-full text-xs font-medium transition-all",
            style: "background:" + (on ? '${c}22' : "rgba(255,255,255,0.04)")
                + ";color:" + (on ? c : "var(--muted-foreground)")
                + ";border:1px solid " + (on ? '${c}66' : "rgba(138,63,217,0.2)"),
            onClick: () -> { if (on) npPlatforms.remove(pl) else npPlatforms.push(pl); refresh(); }
        }, [Icons.platform(pl, 14), pl]);
    }

    function dateField(label:String, type:String, value:String, onChange:String->Void):Element {
        return el("div", {cls: "flex flex-col gap-1.5 flex-1"}, [
            el("label", {cls: "text-xs font-medium text-muted-foreground uppercase tracking-wide", text: label}),
            el("input", {
                type: type, value: value,
                cls: "w-full px-3 py-2 rounded-xl text-xs bg-muted/50 border border-border text-foreground focus:outline-none focus:ring-1 focus:ring-primary/50 transition-all",
                style: "color-scheme:dark",
                onInput: onChange
            })
        ]);
    }

    function schedulePost():Void {
        newPostOpen = false;
        npCaption = "";
        npPlatforms = [];
        npDate = "";
        npTime = "";
        refresh();
    }
}
