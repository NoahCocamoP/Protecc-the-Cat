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

Class = require 'lib/class'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

require 'source/constants'
require 'source/StateMachine'
require 'source/util'
require 'source/Animation'
require 'source/Tile'
require 'source/Entity'
require 'source/Player'
require 'source/LevelMaker'
require 'source/Weapon'
require 'source/Enemy'
require 'source/Health'
require 'source/Cat'

require 'source/states/BaseState'
require 'source/states/PlayState'
require 'source/states/SelectState'
require 'source/states/StartState'
require 'source/states/DirectionsState'
require 'source/states/TransitionState'
require 'source/states/UpgradesState'
require 'source/states/GameOverState'
require 'source/states/Player-states/player-idle'
require 'source/states/Player-states/player-walking'
require 'source/states/Player-states/player-falling'
require 'source/states/Player-states/player-jump'

require 'source/states/Enemy-states/Enemy-falling'
require 'source/states/Enemy-states/Enemy-wandering'
require 'source/states/Enemy-states/Enemy-attacking'
require 'source/states/Enemy-states/Enemy-jumping'


gTextures = {
    ['characters'] = love.graphics.newImage("graphics/knights.png"),
    ['valley-big'] = love.graphics.newImage("graphics/valley-big.png"),
    ['field-big'] = love.graphics.newImage("graphics/field-big.png"),
    ['rocks-big'] = love.graphics.newImage("graphics/rocks-big.png"),
    ['grass-tiles'] = love.graphics.newImage("graphics/grass-tiles.png"),
    ['rock-tiles'] = love.graphics.newImage("graphics/rock-tiles.png"),
    ['duel-sword'] = love.graphics.newImage("graphics/weapon_duel_sword.png"),
    ['knight-sword'] = love.graphics.newImage("graphics/weapon_knight_sword.png"),
    ['red-demon'] = love.graphics.newImage("graphics/red-demon.png"),
    ['left-arrow'] = love.graphics.newImage("graphics/left-arrow.png"),
    ['right-arrow'] = love.graphics.newImage("graphics/right-arrow.png"),
    ['up-arrow'] = love.graphics.newImage("graphics/up-arrow.png"),
    ['down-arrow'] = love.graphics.newImage("graphics/down-arrow.png"),
    ['plants'] = love.graphics.newImage("graphics/plants.png"),
    ['wogol'] = love.graphics.newImage('graphics/wogol.png'),
    ['masked-orc'] = love.graphics.newImage("graphics/masked-orc.png"),
    ['potions'] = love.graphics.newImage("graphics/potions.png"),
    ['black-cat'] = love.graphics.newImage("graphics/black-cat.png"),
    ['white-cat'] = love.graphics.newImage("graphics/white-cat.png"),
    ['orange-cat'] = love.graphics.newImage("graphics/orange-cat.png"),
    ['beige-cat'] = love.graphics.newImage("graphics/beige-cat.png"),
    ['grey-cat'] = love.graphics.newImage("graphics/grey-cat.png")
}

gQuads = {
    ['characters'] = GenerateQuads(gTextures['characters'], 28, 16),
    ['grass-tiles'] = GenerateQuads(gTextures['grass-tiles'], 19, 19),
    ['rock-tiles'] = GenerateQuads(gTextures['rock-tiles'], 19, 19),
    ['red-demon'] = GenerateQuads(gTextures['red-demon'], 24, 16),
    ['plants'] = GenerateQuads(gTextures['plants'], 16, 16),
    ['wogol'] = GenerateQuads(gTextures['wogol'], 20, 16),
    ['masked-orc'] = GenerateQuads(gTextures['masked-orc'], 20, 16),
    ['potions'] = GenerateQuads(gTextures['potions'], 16, 16)
}

Sounds = { 
    ['select'] = love.audio.newSource("sounds/select.wav", 'static'),
    ['no-select'] = love.audio.newSource("sounds/no-select.wav", 'static'),
    ['jump'] = love.audio.newSource('sounds/Jump.wav', 'static'),
    ['attack'] = love.audio.newSource('sounds/attack.wav', 'static'),
    ['hit'] = love.audio.newSource('sounds/Hit.wav', 'static'),
    ['enemy-death'] = love.audio.newSource('sounds/enemy-death.wav', 'static'),
    ['enemy-damaged'] = love.audio.newSource('sounds/monster-damaged.wav', 'static'),
    ['male-damaged'] = love.audio.newSource('sounds/male_damaged.wav', 'static'),
    ['female-damaged'] = love.audio.newSource('sounds/woman_damaged.wav', 'static'),
    ['glug'] = love.audio.newSource('sounds/glug.wav', 'static'),
    ['bonus'] = love.audio.newSource('sounds/bonus.wav', 'static'),
    ['level-complete'] = love.audio.newSource('sounds/level-complete.wav', 'static'),
    ['enter'] = love.audio.newSource('sounds/enter.wav', 'static'),
    ['title-theme'] = love.audio.newSource('sounds/xDeviruchi - Title Theme .wav', 'stream'),
    ['battle-music'] = love.audio.newSource('sounds/xDeviruchi - Prepare for Battle!.wav', 'stream')
}

Fonts = {
    ['to-the-point-small'] = love.graphics.newFont("fonts/to-the-point.ttf", 16),
    ['to-the-point-medium'] = love.graphics.newFont("fonts/to-the-point.ttf", 24),
    ['to-the-point-large'] = love.graphics.newFont("fonts/to-the-point.ttf", 32)
}

Backgrounds = {gTextures['valley-big'], gTextures['field-big'], gTextures['rocks-big']}

Weapons = {gTextures['duel-sword'], gTextures['knight-sword']}

SetColors = {{1, 1, 0, 1}, {1, 0, 0, 1}, {0, 1, 0, 1}, {0, 1, 1, 1}}

EnemyTypes = {'red-demon', 'wogol', 'masked-orc'}

Potions = {"Speed", "Health Points", "Damage"}

Cats = {'orange-cat', 'grey-cat', 'black-cat', 'beige-cat'}