package app;

// ── Shared types ───────────────────────────────────────────────────────
typedef PlatformStat = {
    id:String, label:String, color:String,
    followers:String, followerDelta:String, followerUp:Bool,
    engagement:String, engagementDelta:String, engagementUp:Bool,
    reach:String, reachDelta:String, reachUp:Bool,
    scheduled:Int
};

typedef DashStat = {
    engagement:Int, engagementDelta:Float,
    followers:Int, followersDelta:Float
};

typedef Period = {key:String, label:String};

typedef CalendarCell = {day:Null<Int>, posts:Int};

typedef MediaAsset = {
    id:Int, type:String, name:String, size:String,
    date:String, tags:Array<String>, gradient:String
};

typedef PostMedia = {type:String, gradients:Array<String>, ?duration:String};

typedef Post = {
    id:Int, caption:String, date:String, platforms:Array<String>,
    media:Null<PostMedia>,
    impressions:Int, profileVisits:Int, likes:Int, comments:Int,
    reposts:Int, saves:Int, linkClicks:Int
};

typedef MetricCol = {key:String, label:String};

typedef Account = {platform:String, handle:String, followers:String, connected:Bool};

typedef Notification = {
    id:Int, read:Bool, platform:String, category:String,
    title:String, desc:String, time:String
};

/**
 * All mock data and lookup helpers ported from the Electron UI. Pure data —
 * no DOM. Pages import from here so the content stays in one place.
 */
class Data {
    public static final platformIds = ["instagram", "twitter", "youtube", "linkedin"];

    public static function platformColor(id:String):String {
        return switch (id) {
            case "instagram": "#E040FB";
            case "twitter": "#00E5FF";
            case "youtube": "#FF4060";
            case "linkedin": "#7B2FBE";
            default: "#8B7AB8";
        }
    }

    public static function platformLabel(id:String):String {
        return switch (id) {
            case "instagram": "Instagram";
            case "twitter": "Twitter / X";
            case "youtube": "YouTube";
            case "linkedin": "LinkedIn";
            default: id;
        }
    }

    public static function stat(id:String):PlatformStat {
        for (p in platformStats) if (p.id == id) return p;
        return platformStats[0];
    }

    public static final platformStats:Array<PlatformStat> = [
        {
            id: "instagram", label: "Instagram", color: "#E040FB",
            followers: "48.2K", followerDelta: "+6.3%", followerUp: true,
            engagement: "12.4K", engagementDelta: "+11.2%", engagementUp: true,
            reach: "284K", reachDelta: "+18.9%", reachUp: true, scheduled: 9
        },
        {
            id: "twitter", label: "Twitter / X", color: "#00E5FF",
            followers: "31.4K", followerDelta: "+4.1%", followerUp: true,
            engagement: "18.7K", engagementDelta: "+9.0%", engagementUp: true,
            reach: "310K", reachDelta: "+24.4%", reachUp: true, scheduled: 7
        },
        {
            id: "youtube", label: "YouTube", color: "#FF4060",
            followers: "22.8K", followerDelta: "+14.7%", followerUp: true,
            engagement: "9.2K", engagementDelta: "-1.8%", engagementUp: false,
            reach: "198K", reachDelta: "+8.3%", reachUp: true, scheduled: 4
        },
        {
            id: "linkedin", label: "LinkedIn", color: "#7B2FBE",
            followers: "8.1K", followerDelta: "+2.9%", followerUp: true,
            engagement: "2.6K", engagementDelta: "+5.5%", engagementUp: true,
            reach: "41K", reachDelta: "-3.2%", reachUp: false, scheduled: 4
        }
    ];

    // ── Dashboard ──────────────────────────────────────────────────────
    public static final dashboardPeriods:Array<Period> = [
        {key: "3d", label: "Last 3 Days"},
        {key: "week", label: "Last Week"},
        {key: "month", label: "Last Month"}
    ];

    public static function dashboardData(period:String, platform:String):DashStat {
        return DASH[period][platform];
    }

    static final DASH:Map<String, Map<String, DashStat>> = [
        "3d" => [
            "instagram" => {engagement: 9240, engagementDelta: 14.2, followers: 380, followersDelta: 8.1},
            "twitter" => {engagement: 12100, engagementDelta: 9.8, followers: 210, followersDelta: 3.4},
            "youtube" => {engagement: 4800, engagementDelta: -2.1, followers: 520, followersDelta: 18.6},
            "linkedin" => {engagement: 1840, engagementDelta: 5.5, followers: 90, followersDelta: 2.9}
        ],
        "week" => [
            "instagram" => {engagement: 24800, engagementDelta: 11.3, followers: 940, followersDelta: 6.3},
            "twitter" => {engagement: 31200, engagementDelta: 9.0, followers: 580, followersDelta: 4.1},
            "youtube" => {engagement: 11400, engagementDelta: -1.8, followers: 1240, followersDelta: 14.7},
            "linkedin" => {engagement: 5100, engagementDelta: 5.5, followers: 210, followersDelta: 2.9}
        ],
        "month" => [
            "instagram" => {engagement: 84200, engagementDelta: 18.7, followers: 3410, followersDelta: 12.4},
            "twitter" => {engagement: 112000, engagementDelta: 21.4, followers: 2180, followersDelta: 8.8},
            "youtube" => {engagement: 42000, engagementDelta: 8.3, followers: 4800, followersDelta: 22.1},
            "linkedin" => {engagement: 18300, engagementDelta: 6.2, followers: 720, followersDelta: 4.0}
        ]
    ];

    // ── Calendar ───────────────────────────────────────────────────────
    public static final reminderPeriods:Array<Period> = [
        {key: "1d", label: "1 Day"},
        {key: "3d", label: "3 Days"},
        {key: "1w", label: "1 Week"},
        {key: "1m", label: "1 Month"},
        {key: "3m", label: "3 Months"}
    ];

    public static final reminderThresholds:Map<String, Int> = [
        "1d" => 1, "3d" => 3, "1w" => 7, "1m" => 30, "3m" => 90
    ];

    public static final platformLastPosted:Map<String, Int> = [
        "instagram" => 2, "twitter" => 1, "youtube" => 9, "linkedin" => 32
    ];

    public static final calendarDays:Array<CalendarCell> = [
        for (i in 0...35) {
            var day = i - 4;
            {
                day: (day < 1 || day > 30) ? null : day,
                posts: (day > 0 && day <= 30) ? Math.floor(Math.random() * 4) : 0
            };
        }
    ];

    // ── Media ──────────────────────────────────────────────────────────
    public static final mediaAssets:Array<MediaAsset> = [
        {id: 1, type: "image", name: "campaign-hero.jpg", size: "2.4 MB", date: "Jun 18", tags: ["campaign", "hero"], gradient: "from-cyan-500 to-blue-600"},
        {id: 2, type: "video", name: "brand-reel-v2.mp4", size: "48 MB", date: "Jun 17", tags: ["video", "reel"], gradient: "from-purple-600 to-pink-500"},
        {id: 3, type: "image", name: "product-flat-lay.png", size: "1.8 MB", date: "Jun 16", tags: ["product"], gradient: "from-indigo-500 to-purple-600"},
        {id: 4, type: "image", name: "collab-post-june.jpg", size: "980 KB", date: "Jun 15", tags: ["collab"], gradient: "from-fuchsia-500 to-violet-600"},
        {id: 5, type: "video", name: "tutorial-skincare.mp4", size: "120 MB", date: "Jun 14", tags: ["tutorial"], gradient: "from-blue-500 to-cyan-400"},
        {id: 6, type: "image", name: "quote-card-01.png", size: "340 KB", date: "Jun 13", tags: ["quote"], gradient: "from-violet-600 to-indigo-500"},
        {id: 7, type: "image", name: "bts-studio-shoot.jpg", size: "3.1 MB", date: "Jun 12", tags: ["bts"], gradient: "from-pink-500 to-rose-600"},
        {id: 8, type: "image", name: "announcement-banner.png", size: "560 KB", date: "Jun 11", tags: ["announcement"], gradient: "from-cyan-400 to-teal-500"},
        {id: 9, type: "video", name: "unboxing-haul.mp4", size: "85 MB", date: "Jun 10", tags: ["unboxing"], gradient: "from-purple-500 to-fuchsia-600"}
    ];

    // ── Analytics ──────────────────────────────────────────────────────
    public static final metricCols:Array<MetricCol> = [
        {key: "impressions", label: "Impressions"},
        {key: "profileVisits", label: "Profile Visits"},
        {key: "likes", label: "Likes"},
        {key: "comments", label: "Comments"},
        {key: "reposts", label: "Reposts"},
        {key: "saves", label: "Saves"},
        {key: "linkClicks", label: "Link Clicks"}
    ];

    public static function metricValue(p:Post, key:String):Int {
        return switch (key) {
            case "impressions": p.impressions;
            case "profileVisits": p.profileVisits;
            case "likes": p.likes;
            case "comments": p.comments;
            case "reposts": p.reposts;
            case "saves": p.saves;
            case "linkClicks": p.linkClicks;
            default: 0;
        }
    }

    public static final postAnalytics:Array<Post> = [
        {
            id: 1, caption: "Morning vibes ✨ New collection drop is here!", date: "Jun 18, 2026",
            platforms: ["instagram"],
            media: {type: "image", gradients: ["from-fuchsia-500 via-purple-600 to-indigo-700", "from-cyan-400 via-blue-500 to-violet-600", "from-pink-500 via-rose-500 to-orange-400"]},
            impressions: 84200, profileVisits: 3410, likes: 4820, comments: 312, reposts: 198, saves: 940, linkClicks: 620
        },
        {
            id: 2, caption: "We just hit 50K followers! Thank you all 🚀", date: "Jun 17, 2026",
            platforms: ["twitter", "instagram"], media: null,
            impressions: 61400, profileVisits: 2180, likes: 6240, comments: 890, reposts: 1430, saves: 210, linkClicks: 380
        },
        {
            id: 3, caption: "Behind the Scenes — How We Build Our Brand (Full Video)", date: "Jun 16, 2026",
            platforms: ["youtube"],
            media: {type: "video", gradients: ["from-red-600 via-rose-700 to-purple-800"], duration: "14:32"},
            impressions: 49800, profileVisits: 1920, likes: 1830, comments: 204, reposts: 88, saves: 560, linkClicks: 1140
        },
        {
            id: 4, caption: "3 lessons from scaling to 6 figures on social media", date: "Jun 15, 2026",
            platforms: ["linkedin", "twitter"], media: null,
            impressions: 28300, profileVisits: 1040, likes: 1020, comments: 98, reposts: 312, saves: 480, linkClicks: 890
        },
        {
            id: 5, caption: "Weekend energy 💜 Drop your plans below!", date: "Jun 14, 2026",
            platforms: ["instagram"],
            media: {type: "image", gradients: ["from-violet-500 via-fuchsia-600 to-pink-600", "from-indigo-500 via-blue-600 to-cyan-500"]},
            impressions: 37600, profileVisits: 1650, likes: 3290, comments: 441, reposts: 74, saves: 310, linkClicks: 140
        },
        {
            id: 6, caption: "Hot take: short-form video is NOT the only way to grow", date: "Jun 13, 2026",
            platforms: ["twitter", "linkedin"], media: null,
            impressions: 19400, profileVisits: 720, likes: 880, comments: 267, reposts: 540, saves: 190, linkClicks: 230
        },
        {
            id: 7, caption: "New tutorial just dropped — Skincare routine for beginners 🧴", date: "Jun 12, 2026",
            platforms: ["youtube", "instagram"],
            media: {type: "video", gradients: ["from-cyan-500 via-blue-600 to-violet-700"], duration: "8:14"},
            impressions: 55100, profileVisits: 2340, likes: 2640, comments: 388, reposts: 120, saves: 1020, linkClicks: 740
        },
        {
            id: 8, caption: "Big announcement dropping Monday — stay tuned 👀", date: "Jun 11, 2026",
            platforms: ["instagram", "twitter", "linkedin"],
            media: {type: "image", gradients: ["from-indigo-600 via-purple-600 to-fuchsia-500", "from-emerald-500 via-teal-600 to-cyan-500", "from-amber-400 via-orange-500 to-pink-500", "from-rose-500 via-fuchsia-600 to-violet-700"]},
            impressions: 72800, profileVisits: 4100, likes: 5910, comments: 634, reposts: 820, saves: 670, linkClicks: 480
        }
    ];

    // ── Settings ───────────────────────────────────────────────────────
    public static final connectedAccounts:Array<Account> = [
        {platform: "instagram", handle: "@feeshydesigns", followers: "48.2K", connected: true},
        {platform: "twitter", handle: "@feeshydesigns", followers: "31.4K", connected: true},
        {platform: "youtube", handle: "Feeshy Designs", followers: "22.8K", connected: true},
        {platform: "linkedin", handle: "Feeshy Designs Co.", followers: "8.1K", connected: false}
    ];

    // ── Notifications ──────────────────────────────────────────────────
    public static function notifications():Array<Notification> {
        return [
            {id: 1, read: false, platform: "instagram", category: "schedule", title: "Best time to post", desc: "Peak engagement on Instagram today is 11am–1pm", time: "Just now"},
            {id: 2, read: false, platform: "twitter", category: "schedule", title: "Overdue post", desc: "You haven't posted on Twitter in 3 days — schedule one now", time: "1h ago"},
            {id: 3, read: true, platform: "youtube", category: "schedule", title: "Upcoming slot open", desc: "No YouTube post scheduled for this week", time: "4h ago"},
            {id: 4, read: false, platform: "instagram", category: "followers", title: "+124 new followers", desc: "Instagram gained 124 followers in the last 24h", time: "30m ago"},
            {id: 5, read: false, platform: "linkedin", category: "followers", title: "Follower milestone", desc: "You just crossed 8,000 LinkedIn followers 🎉", time: "2h ago"},
            {id: 6, read: true, platform: "twitter", category: "followers", title: "+58 new followers", desc: "Twitter gained 58 followers after your last post", time: "6h ago"},
            {id: 7, read: false, platform: "instagram", category: "engagement", title: "Post trending", desc: "\"Morning vibes ✨\" has 4.8K likes and 312 comments", time: "15m ago"},
            {id: 8, read: false, platform: "youtube", category: "engagement", title: "New comment spike", desc: "Your BTS video received 40 new comments in the last hour", time: "1h ago"},
            {id: 9, read: true, platform: "linkedin", category: "engagement", title: "High save rate", desc: "\"3 lessons from scaling\" is being saved 3× above average", time: "3h ago"}
        ];
    }

    /** Format a number with a "K" suffix, matching the React `fmt` helper. */
    public static function fmtK(n:Float):String {
        return n >= 1000 ? (Math.round(n / 100) / 10) + "K" : Std.string(Std.int(n));
    }
}
