# Protecc the Cat

## Made by Noah Pride

Hello! Noah here. This is my final project for CS50G - CS50's Introduction to Game Development.

Protecc the Cat is a sidescrolling combat psuedo-RPG, with some light random environmental generation thrown in to spice things up. It was coded in Lua, using the LOVE game engine.

If you want to play it, download the code and then drag the folder onto LOVE or open the main folder with LOVE (you'll need to install it.)

### Gameplay

You select 1 of 4 characters, then enter into level 1. Each level a random number of enemies are spawned, some of them have a color-tint variation that designates they are "Powerful." Powerful enemies have 1.5x the hp of normal enemies and also hit for double the damage. Your goal is to kill all these enemies, without dying. Once you have killed all the enemies, the combat music will stop and a victory sound will play. You will then be taken to the bonus points state, where depending on the amount of health you have remaining you may recieve additional bonus points. After that, you get to select 1 of three potions to power up your stats. Either "Health", "Speed", or "Damage." Upon selecting a potion, the screen fades out and you start the next level. Each level, both you and the enemies gain 1 more hp than the previous level. You may also notice that more and more enemies spawn on subsequent levels, and there's a higher chance that these enemies will be "Powerful." You can play indefinitely until you die, at which point the screen will fade to white and the combat music will fade out with it. You'll be taken to a game over screen, and have the option to restart.
You can also press Esc to quit the game at any point.

### Development

The development for this game was a very hands-on experience. I had to scrounge for various free assets, including character/enemy spritesheets, music, audio effects, tilesets, and a few 1 off bits of pixel art. Oh, and a spritesheet for all of the plants that spawn for aesthetic variation.

Once I had the assets, it was time to try putting them together. I used the basic stateMachine setup that was used in several of CS50G's early games in Lua. I made a tile class and a LevelGenerator class, that would instantiate a levels worth of tiles into a Level table. Initially I wanted to have the enemies be instantiated in this same LevelGenerator class, but I ran into an issue where I wanted the Player class to be instantiated with a reference to the Level table, and I wanted all the enemies to be instantiated with a reference to the Player class for collission. So if I was making the level before the Player was instantiated then I couldn't give the enemies a player reference inside of LevelGenerator. I had to settle for adding the enemies inside of PlayState, where Player had already been instantiated. I also gave Player a reference to the Enemies table in that same State.

On the note of players and enemies, player and enemy both share the entity class. This helped to not have to write identical functions for both the Player and Enemy class, however, they still needed somewhat unique states to drive behavior. Each Enemy and the Player have 4 different states they can be in. For the Player they are:
1. Player-falling, for when the player is falling and not above a solid tile.
2. Player-idle, for a slightly unique animation when they are on top of a solid tile but aren't moving.
3. Player-jump, for when they are jumping and moving upward.
4. Player-walking, for when they are moving left or right on top of a solid tile.

The states for the enemies are:
1. Enemy-wandering, for when they are on top of a tile and are moving randomly to the left or right.
2. Enemy-jumping, for when the AI decides to jump.
3. Enemy-falling, for after a jump or when they are detected to no longer be directly above a solid tile.
4. Enemy-attacking, for when the enemy is within a certain range from the player. They will follow the player and try to damage them. This state will also initiate a state-change to Enemy-jumping if the player is a certain amount above the enemy. This state makes the enemies feel more interactive and aggressive.

### Dealing with Collision

Dealing with tile collision and getting feedback to know if an entity is above a solid tile was one of the trickier things I encountered during development. I wanted the interaction with tiles to be smooth and not have any buggy behavior. I tried all sorts of somewhat hacky solutions, but the algorithm I settled on made me pretty satisfied. I was researching ways that collision is handled in other games, and was introduced to the concept of running 4 while loops, one for the 4 directions (up, left, down, right), that each end when the entity is no longer colliding with the tile in question. You then move the entity to the direction that needed the shortest amount of displacement to get the entity and tile to stop colliding. Finally, return the direction they were moved as a string. I.E. "Up", "Down", "Left", "Right". If the function moved them "Up", then you know they are currently above a tile and can have their state changed to either idle or wandering. This ended up having a pretty smooth interaction for tile collision, and also gave me some ability to know if they are on top of a tile or not.

### Weapon and Attacks

The player has a Weapon class attached to it. Inside of the weapon class, there are variables like "self.hitting." self.hitting starts out as being set to False, however when the player press' Q (the attack button) it will make the weapon render and will tween its radian/rotation value to give the appearence that its being swung. I had to offset the origin so that it rotates from the hilt. At the same time I extend and shrink the weapons hitbox in such a way that its hitbox is largest when the weapon is fully extended. The entire time that self.hitting = True, I'm checking the list of enemies to see if theres a collision between the weapons hitbox and the enemies hitbox. If there is a collision, I call a method tied to the enemy that damages them and plays a sound. There's also a short hit cooldown that is triggered on a hit enemy so that they can't be hit multiple times from 1 swing. If the player presses Q before the first hit has completed, then I cancel the rotation / hitbox extension tween, and reset the weapon to its starting values before the new tween starts. This way the Player can spam attacks without it looking weird.

That way of attacking is good enough for the basic gameplay. However I wasn't fully satisfied with the gameplay variety, so I added a second attack. If the player is jumping or falling and holds down Q, it will render their weapon as pointing straight down beneath them, and moves their hitbox down so that its lined up with where the weapon is rendering. If the player collides with an enemy while attacking in this way, the player will bounce up again on collision and the enemy will take slightly more damage than a normal attack. I have to say, this is probably my favorite way of attacking. I made it deal more damage because it feels like it takes a little more skill and is slightly riskier in terms of taking damage.

### Miscelanious Features

Some random things to mention: There are 4 different character variations to choose from at the start. A male elf, a female elf, a male knight, and a female knight. The males and females have different audio effects when taking damage, and the elfs have a different sword sprite than the knights.

P can be pressed during the battle-phase to pause the game. Esc can be pressed at any time to quit.

When the player is first instantiated, they are given a random cat sprite that sits behind the head of the character. This cat can be seen in the bonus points and the potion states of the game. Hence the name "Protecc the Cat."

The backgrounds, ground tiles, and plants are all chosen randomly during level generation. 

The animation class that I used to animate the frames of any given state is very similar to the one implemented in some of the games we worked on for CS50G.

## Final Thoughts

Overall I had a good time developing this, and it made me really appreciate the value of artists when it comes to game design. I felt like in particular the character/enemy spritesheet that I found added a lot of life and character to the game early on, and made me excited to develop it more. As the game got more complex, I found that it was easier to accidentally add-in bugs when trying to make new features. I think I have it pretty much bug free at this point though, which compared to where it was at other points is pretty awesome! I am fairly happy with how this all turned out.

### Asset Credits

-- Character sprites downloaded from https://0x72.itch.io/dungeontileset-ii

-- Backgrounds taken from CraftPix as freebies: https://craftpix.net/file-licenses/

-- Rock and Grass tilesets taken from https://itch.io/queue/c/643837/16x16-tilesets?game_id=431069

-- Font taken from https://www.fontspace.com/to-the-point-font-f25644

-- Credit to https://www.zapsplat.com for some of the monster sound effects

-- Plant sprites taken from https://danaida.itch.io/free-pixel-plants-16x16

-- Female pain sound effect taken from https://freesound.org/people/Yudena/sounds/377561/

-- Glug Glug Glug, bonus, and level complete sound effects from https://pixabay.com/

-- Music by Marllon Silva (xDeviruchi) from https://xdeviruchi.itch.io/8-bit-fantasy-adventure-music-pack

-- Cat sprite obtained from https://opengameart.org/content/cats-pixel-art by Peony