package app.pages;

import js.html.Element;
import app.Dom.el;
import app.Data;
import app.Icons;
import app.Component;
import app.components.PostCard;

/** Analytics page: posts ranked by a selectable metric, each as a PostCard. */
class AnalyticsPage extends Component {
    var sortKey = "impressions";
    // Cache cards by post id so carousel state survives re-sorting.
    final cards:Map<Int, PostCard> = new Map();

    public function new() super();

    static function metricIcon(key:String):Element {
        return switch (key) {
            case "impressions": Icons.eye(12);
            case "profileVisits": Icons.users(12);
            case "likes": Icons.heart(12);
            case "comments": Icons.message(12);
            case "reposts": Icons.share(12);
            case "saves": Icons.bookmark(12);
            case "linkClicks": Icons.link(12);
            default: Icons.eye(12);
        }
    }

    override function build():Element {
        var sorted = Data.postAnalytics.copy();
        sorted.sort((a, b) -> Data.metricValue(b, sortKey) - Data.metricValue(a, sortKey));

        return el("div", {cls: "flex flex-col gap-3 pb-4"}, [
            sortControls(),
            el("div", {cls: "grid gap-4", style: "grid-template-columns:repeat(auto-fill,minmax(320px,1fr))"}, [
                for (i in 0...sorted.length) {
                    var post = sorted[i];
                    var card = cards.exists(post.id) ? cards[post.id] : { var c = new PostCard(post); cards[post.id] = c; c; };
                    card.rank = i + 1;
                    card.sortKey = sortKey;
                    card.refresh();
                    card.root;
                }
            ])
        ]);
    }

    function sortControls():Element {
        return el("div", {cls: "flex flex-wrap items-center gap-2"}, [
            el("span", {cls: "text-xs text-muted-foreground", text: "Sort by:"}),
            [for (col in Data.metricCols) {
                var active = col.key == sortKey;
                el("button", {
                    cls: "flex items-center gap-1 px-2.5 py-1 rounded-lg text-xs font-medium transition-all",
                    style: active
                        ? "background:linear-gradient(135deg,rgba(0,229,255,0.15),rgba(224,64,251,0.15));color:#00E5FF;box-shadow:0 0 0 1px rgba(0,229,255,0.2)"
                        : "background:rgba(255,255,255,0.05);color:var(--muted-foreground)",
                    onClick: () -> { sortKey = col.key; refresh(); }
                }, [metricIcon(col.key), el("span", {text: col.label})]);
            }]
        ]);
    }
}
