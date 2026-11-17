-- Generado por tools/zone_guides.py. No editar a mano: vuelve a ejecutar el script.
-- Alliance · Mount Hyjal · niveles 55-60 · 108 misiones
local _, QR = ...
QR:RegisterZoneGuide({
    key = "Alliance_MountHyjal",
    faction = "Alliance",
    zone = "Mount Hyjal",
    areaId = 616,
    minLevel = 55,
    maxLevel = 60,
    entry = { quest = 90750, areaId = 616, x = 15.67, y = 54.66 },
    -- { questId, nivelMision, nivelRequerido }
    quests = {
        { 90750, 55, 1 }, -- More Work?
        { 92702, 56, 54 }, -- Branch Out
        { 92064, 56, 54 }, -- Tree Free
        { 91754, 56, 1 }, -- Rub Some Dirt In It
        { 91755, 56, 1 }, -- Leaves to Ligatures
        { 91770, 56, 1 }, -- Bark Bite
        { 92959, 56, 1 }, -- The Dying Ancients
        { 95766, 56, 1 }, -- Fine Feathered Friend
        { 94479, 56, 1 }, -- One Person's Trash
        { 96833, 56, 1 }, -- Venom Maws
        { 92008, 56, 1 }, -- Premiere Parts
        { 92594, 56, 1 }, -- Kindling, Kinda
        { 92015, 56, 54 }, -- Area Denial Skunks
        { 92014, 57, 54 }, -- Fox Hole
        { 96992, 57, 54 }, -- Resupply
        { 93615, 57, 1 }, -- Kits and Cats
        { 96979, 57, 1 }, -- Sacred Refreshment
        { 93952, 57, 1 }, -- Balance Through Strength
        { 92111, 57, 1 }, -- Of Friend and Fur
        { 93828, 57, 1 }, -- Herbs of the Hollow
        { 93830, 57, 1 }, -- Water of Hyjal
        { 93834, 57, 1 }, -- Burrow Beetles
        { 94504, 57, 1 }, -- Barkskin Beginnings
        { 93833, 57, 1 }, -- Wicked Wisdom
        { 96666, 57, 1 }, -- Burrow Bonding
        { 93831, 57, 1 }, -- Sweetpaw Jam
        { 91697, 57, 1 }, -- Meet the Elders
        { 93825, 57, 1 }, -- Barkbound Blessings
        { 93826, 57, 1 }, -- Deal Dread to Deadwood
        { 96559, 57, 54 }, -- Supply Drop
        { 95317, 57, 1 }, -- Notation, Notation, Notation
        { 95320, 57, 1 }, -- A Curious Question
        { 95380, 57, 1 }, -- A Prolific Source
        { 96262, 57, 1 }, -- Prickly Pinecones
        { 95316, 57, 1 }, -- The Experimental Method
        { 91881, 57, 54 }, -- The Western Post
        { 91923, 57, 1 }, -- Celastrus the Bitter
        { 95318, 57, 1 }, -- Taste of Ash
        { 95319, 57, 1 }, -- Crystalline Collection
        { 95378, 58, 1 }, -- The Hydra's Head
        { 95379, 58, 1 }, -- A Revenge So Sweet
        { 96435, 58, 1 }, -- A Fitting End
        { 96255, 58, 1 }, -- Amalgamated Marrow
        { 96321, 58, 1 }, -- The Dying God
        { 96322, 58, 1 }, -- A Revenge Now Bitter
        { 92500, 58, 1 }, -- A Bit of the Sky
        { 92147, 58, 1 }, -- Highfeather Helper
        { 96252, 58, 1 }, -- Tarnished Treasures
        { 92011, 58, 1 }, -- Rubble Rummage
        { 92328, 56, 1 }, -- Siegecraft
        { 96296, 58, 1 }, -- Fetid Corruption
        { 96145, 58, 1 }, -- Past Wing and Claw
        { 91696, 58, 1 }, -- Open Season
        { 91698, 58, 1 }, -- Barkskin Breakout
        { 93567, 58, 1 }, -- Ends Meet
        { 90702, 58, 54 }, -- Disturbed Grave
        { 92449, 58, 54 }, -- Blight No More
        { 94832, 58, 54 }, -- Belle's Ring
        { 92100, 58, 1 }, -- Anywhere But Here
        { 90865, 58, 1 }, -- Eyes of the Watchers
        { 93827, 58, 1 }, -- Windswept Wards
        { 96131, 58, 1 }, -- An Oldstone But An Old Friend
        { 96931, 58, 1 }, -- Heading Up the Mountain
        { 96978, 57, 1 }, -- Violent Venison
        { 93617, 57, 1 }, -- Prey and Predator
        { 96939, 58, 1 }, -- The Balance of Life and Death
        { 92317, 58, 1 }, -- Stolen Life
        { 96957, 58, 1 }, -- Bone Sweet Bone
        { 96550, 58, 1 }, -- Battle Recall
        { 92101, 58, 54 }, -- Lifted by Legacy
        { 93510, 58, 54 }, -- Wake Memories
        { 93197, 58, 1 }, -- Mending Communications
        { 92169, 59, 1 }, -- Paying Back the Pact
        { 92017, 59, 1 }, -- Cleansing Winds
        { 91883, 59, 1 }, -- Spear of the Skylord
        { 96964, 59, 1 }, -- A Clever Creature
        { 92593, 59, 54 }, -- Avalanche of Corruption
        { 96494, 59, 54 }, -- Gathering Storm
        { 96529, 59, 54 }, -- A Shaw Deal
        { 92960, 59, 1 }, -- Siphoned Ephemeral Essence
        { 95793, 59, 1 }, -- Stemming the Demon Tide
        { 96959, 59, 1 }, -- Blademaster's Bonfires
        { 92335, 59, 1 }, -- Ashes of the Legion Ascent
        { 96971, 59, 1 }, -- To Outfox a Demon
        { 96991, 59, 1 }, -- Trail Assist
        { 92591, 59, 57 }, -- Final Death
        { 91688, 59, 54 }, -- To the Summit of Eternity
        { 96676, 59, 54 }, -- Unsealing Blackthorne Pact
        { 96558, 60, 1 }, -- Soldier's Solace
        { 96003, 60, 1 }, -- Drawing Down the Malevolent
        { 96025, 59, 1 }, -- As the Crow Flies
        { 96983, 60, 1 }, -- Yashiro's Windwalk
        { 92016, 60, 1 }, -- Rootwork
        { 96301, 60, 1 }, -- Power Wash
        { 96302, 60, 1 }, -- Arch Absolution
        { 93444, 60, 1 }, -- Bait the Beast
        { 92533, 60, 1 }, -- Twisted Tools
        { 93584, 60, 1 }, -- Cult Closure
        { 96303, 60, 1 }, -- Memory Mist
        { 92833, 60, 1 }, -- Ve'han's Fall
        { 93127, 60, 1 }, -- Summit Sentries
        { 93407, 60, 1 }, -- A Thorn in the Paw
        { 93547, 60, 1 }, -- A Thorny Solution
        { 93848, 60, 1 }, -- Work Well Done
        { 99670, 60, 1 }, -- Return to Jereman
        { 93422, 60, 1 }, -- Blackthorne Blackout
        { 92329, 60, 1 }, -- Drum Up Trouble
        { 93521, 60, 1 }, -- Challenger of the Gods
    },
    -- Misiones que se cogen aquí pero muy por encima del rango (se hacen en otra visita)
    later = {
    },
})
