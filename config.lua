Config = {}

-- Spawn locations (x, y, z, heading)
Config.SpawnLocations = {
    vector4(967.13, -544.65, 59.37, 198.12),
    vector4(988.69, -527.24, 60.48, 29.61),
    -- Add more locations as needed
}

-- Package models
Config.PackageModels = {
    "prop_cs_cardbox_01",
    -- Add more models as needed
}

-- Items and their probabilities
Config.Items = {
    {name = "weapon_pistol", label = "Pistol", probability = 0.0001}, -- 1 in 10000 chance
    {name = "sandwich", label = "Sandwich", probability = 0.3},
    {name = "weapon_flashlight", label = "Flashlight", probability = 0.3},

    -- Add more items as needed
}

-- Time between package spawns (in milliseconds)
Config.SpawnInterval = 10000 -- 5 minutes

-- Maximum number of packages that can exist at once
Config.MaxPackages = 10

-- Duration of the "opening package" animation (in milliseconds)
Config.OpeningDuration = 5000 -- 5 seconds

-- Enable debug mode (additional console outputs)
Config.Debug = false


-- Time before a package despawns (in milliseconds)
Config.DespawnTime = 1800000 -- 30 minutes

-- Distance players must be away for a package to spawn (in game units)
Config.PlayerProximityCheck = 50.0

return Config