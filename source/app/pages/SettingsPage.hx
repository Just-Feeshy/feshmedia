package app.pages;

import js.Browser.document;
import js.html.Element;
import app.Dom.el;
import app.Data;
import app.Icons;
import app.Component;

/** Settings page: profile, connected accounts, and preference toggles. */
class SettingsPage extends Component {
    var darkMode = true;
    var notifs = true;
    var aiAssist = true;
    var editProfileOpen = false;
    var profileName = "Feeshy Designs";
    var profileEmail = "hello@feeshydesigns.co";

    public function new() {
        super();
        document.documentElement.classList.add("dark");
    }

    override function build():Element {
        return el("div", {cls: "flex flex-col sm:flex-row gap-4 pb-4 min-h-full"}, [
            el("div", {cls: "flex-1 flex flex-col gap-3 min-w-0"}, [
                profileCard(),
                accountsCard(),
                preferencesCard()
            ])
        ]);
    }

    function profileCard():Element {
        return el("div", {cls: "bg-card border border-border rounded-xl p-4"}, [
            el("h3", {cls: "text-sm font-semibold mb-4 font-display", text: "Profile"}),
            el("div", {cls: "flex items-center gap-4 mb-4"}, [
                el("div", {
                    cls: "w-14 h-14 rounded-2xl flex items-center justify-center font-bold text-lg shrink-0 font-display",
                    style: "background:linear-gradient(135deg,#00E5FF,#E040FB);color:#0B0620",
                    text: "F"
                }),
                el("div", null, [
                    el("div", {cls: "font-semibold text-sm", text: "Feeshy Designs"}),
                    el("div", {cls: "text-xs text-muted-foreground mt-0.5", text: "hello@feeshydesigns.co"})
                ]),
                el("div", {cls: "relative ml-auto"}, [
                    el("button", {
                        cls: "flex items-center gap-1.5 px-3 py-1.5 rounded-lg border border-border text-xs hover:border-primary/40 transition-colors",
                        style: editProfileOpen ? "border-color:rgba(0,229,255,0.4);color:#00E5FF" : null,
                        onClick: () -> { editProfileOpen = !editProfileOpen; refresh(); }
                    }, [
                        Icons.edit(11), "Edit Profile",
                        el("span", {style: "transition:transform 0.2s;transform:" + (editProfileOpen ? "rotate(180deg)" : "none")}, [Icons.chevronDown(11)])
                    ]),
                    editProfileOpen ? editPopover() : null
                ])
            ])
        ]);
    }

    function editPopover():Element {
        return el("div", {
            cls: "absolute right-0 mt-2 w-72 rounded-2xl border border-border overflow-hidden z-30",
            style: "background:var(--popover);box-shadow:0 16px 48px rgba(0,0,0,0.6),0 0 0 1px rgba(0,229,255,0.1)"
        }, [
            el("div", {cls: "flex items-center justify-between px-4 py-3 border-b border-border"}, [
                el("span", {cls: "text-xs font-semibold font-display", style: "color:#00E5FF", text: "Edit Profile"}),
                el("button", {
                    cls: "text-muted-foreground hover:text-foreground transition-colors",
                    onClick: () -> { editProfileOpen = false; refresh(); }
                }, [Icons.x(13)])
            ]),
            el("div", {cls: "flex flex-col gap-3 p-4"}, [
                field("Display Name", "text", "Your name", profileName, v -> profileName = v),
                field("Email", "email", "you@example.com", profileEmail, v -> profileEmail = v)
            ]),
            el("div", {cls: "flex gap-2 px-4 pb-4"}, [
                el("button", {
                    cls: "flex-1 py-2 rounded-lg text-xs border border-border text-muted-foreground hover:text-foreground hover:border-border/60 transition-colors",
                    text: "Cancel",
                    onClick: () -> { editProfileOpen = false; refresh(); }
                }),
                el("button", {
                    cls: "flex-1 py-2 rounded-lg text-xs font-semibold transition-opacity hover:opacity-90",
                    style: "background:linear-gradient(135deg,#00E5FF,#7B2FBE);color:#0B0620",
                    text: "Save Changes",
                    onClick: () -> { editProfileOpen = false; refresh(); }
                })
            ])
        ]);
    }

    function field(label:String, type:String, placeholder:String, value:String, onChange:String->Void):Element {
        return el("div", {cls: "flex flex-col gap-1"}, [
            el("label", {cls: "text-xs text-muted-foreground", text: label}),
            el("input", {
                type: type, placeholder: placeholder, value: value,
                cls: "w-full px-3 py-2 rounded-lg text-xs bg-muted/60 border border-border text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-1 focus:ring-primary/50 transition-all",
                onInput: onChange
            })
        ]);
    }

    function accountsCard():Element {
        return el("div", {cls: "bg-card border border-border rounded-xl p-4"}, [
            el("h3", {cls: "text-sm font-semibold mb-3 font-display", text: "Connected Accounts"}),
            el("div", {cls: "flex flex-col gap-2"}, [
                for (acc in Data.connectedAccounts) {
                    var c = Data.platformColor(acc.platform);
                    el("div", {cls: "flex items-center gap-3 p-3 rounded-lg bg-muted/30"}, [
                        el("div", {cls: "w-8 h-8 rounded-lg flex items-center justify-center", style: 'background:${c}22;color:${c}'}, [Icons.platform(acc.platform, 14)]),
                        el("div", {cls: "flex-1"}, [
                            el("div", {cls: "text-xs font-medium", text: acc.handle}),
                            el("div", {cls: "text-xs text-muted-foreground", text: acc.followers + " followers"})
                        ]),
                        acc.connected
                            ? el("span", {cls: "flex items-center gap-1 text-xs text-emerald-400"}, [Icons.checkCircle(11), "Connected"])
                            : el("button", {cls: "text-xs px-2 py-1 rounded-lg border border-primary/40 text-primary hover:bg-primary/10 transition-colors", text: "Connect"})
                    ]);
                }
            ])
        ]);
    }

    function preferencesCard():Element {
        return el("div", {cls: "bg-card border border-border rounded-xl p-4"}, [
            el("h3", {cls: "text-sm font-semibold mb-3 font-display", text: "Preferences"}),
            el("div", {cls: "flex flex-col gap-3"}, [
                prefRow("Dark Mode", "Use dark theme across the app", darkMode, () -> {
                    darkMode = !darkMode;
                    document.documentElement.classList.toggle("dark", darkMode);
                    refresh();
                }),
                prefRow("Push Notifications", "Get alerts for post status changes", notifs, () -> { notifs = !notifs; refresh(); }),
                prefRow("AI Assist", "Caption suggestions and hashtag recommendations", aiAssist, () -> { aiAssist = !aiAssist; refresh(); })
            ])
        ]);
    }

    function prefRow(label:String, desc:String, value:Bool, onToggle:Void->Void):Element {
        return el("div", {cls: "flex items-center justify-between py-2 border-b border-border last:border-0"}, [
            el("div", null, [
                el("div", {cls: "text-xs font-medium", text: label}),
                el("div", {cls: "text-xs text-muted-foreground mt-0.5", text: desc})
            ]),
            toggle(value, onToggle)
        ]);
    }

    function toggle(on:Bool, onToggle:Void->Void):Element {
        return el("button", {
            cls: "w-10 h-5 rounded-full transition-all duration-200 relative shrink-0",
            style: "background:" + (on ? "linear-gradient(90deg,#00E5FF,#7B2FBE)" : "var(--switch)"),
            onClick: () -> onToggle()
        }, [
            el("div", {
                cls: "absolute top-0.5 w-4 h-4 rounded-full bg-white transition-all duration-200 shadow",
                style: "left:" + (on ? "calc(100% - 18px)" : "2px")
            })
        ]);
    }
}
