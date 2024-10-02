# hz-ppirate: FiveM Package Spawn Script

"hz-ppirate" is a dynamic package spawning system for your FiveM server using QBCore. The script is inspired by the concept of porch pirates stealing packages, hence the name (shortened from hz-porchpirates to hz-ppirate). Packages spawn at predefined locations and contain random items based on configured probabilities, simulating the thrill and unpredictability of package theft.

## Features

- Dynamic package spawning at configurable locations
- Player proximity check for immersive spawning
- Time-based package despawning
- Customizable package models
- Item probabilities for varied loot
- Integration with ox_target for interaction
- Animations for picking up and opening packages
- Server-side item distribution
- Debug commands for easy testing and management

## Requirements

- QBCore framework
- ox_lib
- ox_target

## Installation

1. Ensure you have QBCore, ox_lib, and ox_target installed and configured on your server.
2. Clone or download this repository into your FiveM server's resources folder.
3. Rename the folder to `hz-ppirate` if it's not already named as such.
4. Add the following to your `server.cfg`:
   ```
   ensure hz-ppirate
   ```
5. Configure the `config.lua` file to your liking (see Configuration section).
6. Add the mystery box item to your QBCore shared items. In `qb-core/shared/items.lua`, add:
   ```lua
   ['mystery_box'] = {
       name = 'mystery_box',
       label = 'Mystery Box',
       weight = 1000,
       type = 'item',
       image = 'mystery_box.png',
       unique = false,
       useable = true,
       shouldClose = true,
       combinable = nil,
       description = 'A mysterious box. Who knows what\'s inside?'
   },
   ```
7. Add the `mystery_box.png` image to your qb-inventory's images folder. The path should be:
   ```
   [path_to_resources]/qb-inventory/html/images/mystery_box.png
   ```
8. Start your server and enjoy the new package spawning system!

## Configuration

Edit the `config.lua` file to customize:

- Spawn locations
- Package models
- Items and their probabilities
- Spawn intervals
- Maximum number of packages
- Despawn time
- Player proximity check distance
- Debug mode

See the comments in `config.lua` for detailed explanations of each option.

## Usage

- Packages will spawn automatically based on the configured interval and locations.
- Players can interact with the packages using the ox_target integration.
- When a package is picked up, it's added to the player's inventory as a "mystery_box" item.
- Players can use the mystery box item to open it and receive a random item based on the configured probabilities.

## Debug Commands

If debug mode is enabled in the config:

- `/spawnpackage`: Manually spawn a package
- `/clearpackages`: Remove all spawned packages
- `/itemprobs`: View the probabilities of items in the console

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.