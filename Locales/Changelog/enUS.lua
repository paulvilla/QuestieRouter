-- QuestieRouter: changelog in English (also the fallback for languages without their own). Newest first.
local _, QR = ...

QR.Changelogs = QR.Changelogs or {}
QR.Changelogs.enUS = {
    {
        version = "0.9.3", date = "2026-11-13",
        title = "Route and flight fixes",
        lines = {
            "Fixed a repeating error when taking a flight or heading to a city (Router.lua:551) with newer Questie versions.",
            "QuestieRouter now always uses Questie's own map library instead of an older copy from another addon (such as Spy).",
            "Fixed an error in the flight map report with flight masters the addon doesn't know (for example, one in Mount Hyjal).",
        },
    },
    {
        version = "0.9.2", date = "2026-11-12",
        title = "Setup wizard and new guides",
        lines = {
            "Setup wizard the first time the addon is installed: text size, what the top card and the step list show, and a note about flights (/qr install or from Settings).",
            "New guides: Zephras Isle (Alliance and Horde) and Darkspear Islands (PvP).",
            "Guides use the level range shown on each zone's map.",
            "In capital cities, all completed quests turned in there come first, then the guide continues.",
            "Chain menu (right-click a quest): the whole chain with each quest's status (done, in progress, ready to turn in, available, level), elite and dungeon icons, and the reason when it's locked.",
            "Quests from another race or class are no longer shown as the previous quest.",
            "Portraits in the Target window are square, like their frame.",
            "Target window: no longer shows another creature's portrait when the NPC wasn't loaded in the game yet (portraits saved with that bug are cleared).",
            "Target window: with 3D portraits, the 2D portrait is shown until the model finishes loading (far-away NPCs or on another continent) instead of an empty frame.",
            "Target window: 2D portraits and 3D models of NPCs even if you have never seen them (the addon ships the model of over 10,000 NPCs); when you target them, the game's real model is used if it differs.",
            "The guide window is anchored by the banner: the top card grows upwards and the list below no longer moves or resizes with each step.",
            "Flight bar: the icon sits on the left with rounded corners and the text no longer overlaps the time.",
            "Options: new Travel time settings section, with a flight bar preview (turned off when the options close) and the size of the destination and the time left.",
            "Fixed the error \"attempt to index field 'HBD'\" when Questie's map library wasn't available at startup.",
            "Settings: the changelog opens on the latest version, the QuestieRouter category expands when clicked, and the look and the donate button match LizeUI.",
        },
    },
    {
        version = "0.9.1", date = "2026-11-10",
        title = "Reliable learned flights",
        lines = {
            "Every time you open a flight master's map, all your flights on that continent are checked automatically.",
            "Flights you don't have are no longer counted as learned, and the ones you have are no longer lost.",
            "A discovered flight is recorded for the flight master you talk to; flights you take also count.",
            "Warning when a route is calculated and your flights on that continent aren't known yet.",
            "Flights wrongly saved as learned are cleared: open a flight master's map once on each continent.",
            "Bigger elite and dungeon icons; smoothed zone artwork.",
        },
    },
    {
        version = "0.9.0", date = "2026-11-09",
        title = "Automation and Settings",
        lines = {
            "Auto-accept and auto turn-in when talking to an NPC (toggles in the menu and in Settings; hold Shift to skip).",
            "Right-click a quest in the list: route to its quest giver or to the start of its chain.",
            "Skip and restore quests from the list.",
            "Messages explaining why a quest can't be picked up yet: level, earlier quest or already done.",
            "Elite and dungeon quest icons in the quest list, in the steps and in the legend.",
            "Panel in Settings > AddOns with the options, the changelog and support (/qr settings).",
        },
    },
    {
        version = "0.8.4", date = "2026-11-09",
        title = "Steadier steps",
        lines = {
            "The guide no longer flips between two nearby quests.",
            "Heads-up for items to collect near your path.",
            "Target and Items windows with square buttons, placed above the quest tracker.",
        },
    },
    {
        version = "0.8.3", date = "2026-11-09",
        title = "Quest chains and new artwork",
        lines = {
            "Chains: the quest list shows the missing earlier quest.",
            "If an NPC doesn't offer a quest, the guide won't send you back until you progress.",
            "New zone artwork, skies, icons and textures.",
        },
    },
    {
        version = "0.8.2", date = "2026-11-09",
        title = "Menu",
        lines = {
            "The right-click menu closes when you click outside it.",
        },
    },
    {
        version = "0.8.1", date = "2026-11-09",
        title = "Dungeon guides",
        lines = {
            "Dungeon guides: picks up their quests around the world, then takes you to the entrance.",
            "Steps done inside a dungeon are marked \"(inside ...)\".",
            "Flight bar and countdown with real flight times.",
            "New arrows: RX, RX round, RX 3D prism, RX 3D block and the official one.",
            "Target window: raid marker on the target when you select it, a different icon per button.",
            "Icon legend in the list; the active card can be hidden to see more of the list.",
        },
    },
    {
        version = "0.8.0", date = "2026-11-09",
        title = "Travel routes and languages",
        lines = {
            "Full route on the map and in the list: flights, boats, zeppelins, tram and portals.",
            "Zone crossings and paths inside each zone; cities are entered and left through their gates.",
            "Route to a dungeon entrance (/qr dungeon).",
            "Interface in English and Spanish (esES / esMX).",
        },
    },
    {
        version = "0.7.0", date = "2026-11-08",
        title = "First version",
        lines = {
            "Zone guides per faction: takes you to pick up, complete and turn in the zone's quests in order.",
            "Hub planner: picks up everything nearby, does the objectives around it and comes back to turn in.",
            "Navigation arrow with target name and distance, and animated lines on the map and minimap.",
            "Guide window: current step card, step and quest lists, and a zone banner with a day/night cycle.",
            "Zone picker with thumbnails.",
            "Fastest route with flights, boats and zeppelins, and a bar for the flight in progress.",
            "Target and Items windows to select enemies and use quest items.",
            "Minimap button, right-click menu and graphics options.",
        },
    },
}
