local _, ns = ...

ns.config = {}
local config = ns.config
--Media

local mediapath = "Interface\Addons\oUF_h\media"

config.texture = [[Interface\ChatFrame\ChatFrameBackground]]
config.font = [[Interface\Addons\oUF_h\media\Unrealised.ttf]]
--[[Interface\AddOns\oUF_h\media\FuturaMediumBT.ttf]]
config.mainfontsize = 28
config.smallfontsize = 12

--General Settings
config.numbers = true
config.party = true
config.numBuffs = 8
config.numDebuffs = 10
config.BuffCooldowns = true

--Positions and Offset
config.playerX = -40
config.playerY = -210
config.offsetY = 30
config.offsetX = 125
