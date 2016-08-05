-- This is the entry-point to your game mode and should be used primarily to precache models/particles/sounds/etc

require('internal/util')
require('gamemode')

-- Library containing some utilitary functions 
require('mechanics/hud')
require('mechanics/players')
require('mechanics/units')
require('mechanics/particles')

-- Library containing utilitary methods to check victory/defeat conditions 
require('ninpou_game_rules')

-- Library containing custom commands 
require('commands')

-- AI for medical ninja units in order to enable them to autocast heal ability
require('units/AI/medical_ninja_ai')

-- AI for elite anbu units 
require('units/AI/elite_anbu_ai')

-- AI for elite anbu leader units 
require('units/AI/elite_anbu_leader_ai')

-- AI for Juubi 
require('units/AI/juubi_ai')

require('gamemode')

LinkLuaModifier("modifier_building", "libraries/modifiers/modifier_building", LUA_MODIFIER_MOTION_NONE)

function Precache( context )
--[[
  This function is used to precache resources/units/items/abilities that will be needed
  for sure in your game and that will not be precached by hero selection.  When a hero
  is selected from the hero selection screen, the game will precache that hero's assets,
  any equipped cosmetics, and perform the data-driven precaching defined in that hero's
  precache{} block, as well as the precache{} block for any equipped abilities.

  See GameMode:PostLoadPrecache() in gamemode.lua for more information
  ]]

  DebugPrint("[BAREBONES] Performing pre-load precache")

  -- Particles can be precached individually or by folder
  -- It it likely that precaching a single particle system will precache all of its children, but this may not be guaranteed
  -- PrecacheResource("particle", "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf", context)
  -- PrecacheResource("particle_folder", "particles/test_particle", context)

  -- Models can also be precached by folder or individually
  -- PrecacheModel should generally used over PrecacheResource for individual models
  -- PrecacheResource("model_folder", "particles/heroes/antimage", context)
  -- PrecacheResource("model", "particles/heroes/viper/viper.vmdl", context)
  -- PrecacheModel("models/heroes/viper/viper.vmdl", context)

  -- Entire items can be precached by name
  -- Abilities can also be precached in this way despite the name
  -- PrecacheItemByNameSync("example_ability", context)
  -- PrecacheItemByNameSync("item_example_item", context)

  -- Entire heroes (sound effects/voice/models/particles) can be precached with PrecacheUnitByNameSync
  -- Custom units from npc_units_custom.txt can also have all of their abilities and precache{} blocks precached in this way
  -- PrecacheUnitByNameSync("npc_dota_hero_ancient_apparition", context)
  -- PrecacheUnitByNameSync("npc_dota_hero_enigma", context)
  
  -- Precache custom sounds
  PrecacheResource("soundfile", "soundevents/game_sounds_custom.vsndevts", context)
  PrecacheResource("soundfile", "soundevents/game_sounds.vsndevts", context)
  PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_batrider.vsndevts", context)
  PrecacheResource("soundfile", "soundevents/game_sounds_roshan_halloween.vsndevts", context)
  PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_enigma.vsndevts", context)
  PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_alchemist.vsndevts", context)
  PrecacheResource("particle", "particles/units/heroes/hero_batrider/batrider_flamebreak.vpcf", context)
  PrecacheResource("particle", "particles/items/poisonmist/batrider_flamebreak.vpcf", context)
  PrecacheResource("particle", "particles/base_destruction_fx/gensmoke.vpcf", context)
  PrecacheResource("particle", "particles/econ/items/effigies/status_fx_effigies/base_statue_destruction_generic.vpcf", context)

  -- Precache units 
  PrecacheUnitByNameSync("npc_konoha_chunnin_unit", context)
  PrecacheUnitByNameSync("npc_konoha_jounin_unit", context)
  PrecacheUnitByNameSync("npc_oto_chunnin_unit", context)
  PrecacheUnitByNameSync("npc_oto_jounin_unit", context)
  PrecacheUnitByNameSync("npc_akatsuki_chunnin_unit", context)
  PrecacheUnitByNameSync("npc_akatsuki_jounin_unit", context)
  PrecacheUnitByNameSync("npc_anbu_unit", context)
  PrecacheUnitByNameSync("npc_medical_ninja_unit", context)
  PrecacheUnitByNameSync("npc_juubi_unit", context)
end

-- Create the game mode when we activate
function Activate()
  GameRules.GameMode = GameMode()
  GameRules.GameMode:InitGameMode()
end