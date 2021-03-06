local _, ns = ...
--get Config out of the Namespace
local cfg = ns.config
local ah = ns.aurahelpers

local function HideIcon(self)
    local unit = self.unit
    --local time = self.StringParent.Time
    if (not (UnitCastingInfo(unit) or UnitChannelInfo(unit))) then
        UIFrameFadeOut(self.cbIconParent,0.8,self.cbIconParent:GetAlpha(),0)
        --UIFrameFadeOut(self.StringParent.Time,0.5,self.StringParent.Time:GetAlpha(),0)
        --self.cbIconParent:SetAlpha(0)
        --self.StringParent.Time:SetAlpha(0)
    else
        --self.cbIconParent:SetAlpha(1)
        --self.StringParent.Time:SetAlpha(1)
        UIFrameFadeIn(self.cbIconParent,0.3,self.cbIconParent:GetAlpha(),1)
        --UIFrameFadeOut(self.StringParent.Time,0.1,self.StringParent.Time:GetAlpha(),1)
    end
end

local function Fader(self)
    local unit = self.unit

    if (not UnitAffectingCombat("player") and not UnitExists("target")) 
    then
        UIFrameFadeOut(self, 0.6, self:GetAlpha(), 0.3)
    else
        UIFrameFadeIn(self, 0.6, self:GetAlpha(), 1)
    end
end

local UnitSpecific = {
    player = function(self)
        -- Player specific layout code.
        -- Position and size
        local Power = CreateFrame('StatusBar', nil, self)
        Power:SetSize(100, 20)
        Power:SetPoint("LEFT",self.Health,"RIGHT",25,0)
        Power:SetReverseFill(false)
        Power:SetStatusBarTexture(cfg.texture)
        Power:SetAlpha(1)

        -- Add a background
        local Background = Power:CreateTexture(nil, 'BACKGROUND')
        Background:SetAllPoints(Power)
        Background:SetTexture(texture)
        Background:SetColorTexture(0,0,0)
        Background:SetAlpha(1)
        -- Options
        Power.frequentUpdates = true
        Power.colorTapping = true
        Power.colorDisconnected = true
        Power.colorPower = true
        Power.colorClass = true
        Power.colorReaction = true
        -- Register it with oUF
        Power.bg = Background
        self.Power = Power
        --Power Prediction, still dont Know if its working?
        local mainBar = CreateFrame('StatusBar', nil, self.Power)
        mainBar:SetReverseFill(true)
        mainBar:SetPoint('RIGHT', self.Power:GetStatusBarTexture(), 'RIGHT')
        mainBar:SetStatusBarColor(0,1,0)
        mainBar:SetStatusBarTexture(cfg.texture)
        mainBar:SetWidth(100)
        -- Register with oUF
        self.PowerPrediction = {
            mainBar = mainBar
        }
        --Castbar
        local Castbar = CreateFrame('StatusBar', nil, self)
        Castbar:SetSize(206, 25)
        Castbar:SetStatusBarTexture(cfg.texture)
        Castbar:SetStatusBarColor(1,1,1)
        Castbar:SetFrameLevel(1)
        Castbar:SetAlpha(.5)
        Castbar:SetPoint("CENTER",self.Health,"CENTER",0,0)
        
        local Icon = self.cbIconParent:CreateTexture(nil, 'OVERLAY')
        Icon:SetAlpha(1)
        Icon:SetSize(20, 20)
        Icon:SetTexCoord(0.08, 0.8, 0.08, 0.8)
        Icon:SetPoint('LEFT', Castbar, 'RIGHT',-23,0)

        -- Add a timer
        local Time = self.cbIconParent:CreateFontString(nil, 'OVERLAY')
        Time:SetFont(cfg.font,cfg.smallfontsize,"THINOUTLINE")
        Time:SetPoint('RIGHT', self.Health,-30,0)

        local Safezone = Castbar:CreateTexture(nil, 'OVERLAY')
        --bind time to stringparent
        self.StringParent.Time = Time
        Castbar.SafeZone = Safezone
        Castbar.Icon = Icon
        Castbar.Time = Time
        self.Castbar = Castbar

        local gcdbar = CreateFrame('StatusBar', nil, self)
        gcdbar:SetSize(206, 26)
        gcdbar:SetStatusBarTexture(cfg.texture)
        gcdbar:SetStatusBarColor(1,1,1)
        gcdbar:SetFrameLevel(1)
        gcdbar:SetAlpha(.5)
        gcdbar:SetPoint("CENTER",self.Health,"CENTER",0,0)

        self.GCD = gcdbar

        if(cfg.numbers) then
            local pp = self.StringParent:CreateFontString(nil, 'OVERLAY')
            pp:SetPoint('RIGHT',self.Power,-5, 0)
            pp:SetFont(cfg.font,cfg.smallfontsize,"THINOUTLINE")
            --Name:SetWordWrap(false)
            self:Tag(pp, '[h:pp]')

            local hp = self.StringParent:CreateFontString(nil, 'OVERLAY')
            hp:SetPoint('LEFT',self.Health,5,0)
            hp:SetFont(cfg.font,cfg.mainfontsize,"THINOUTLINE")
            self:Tag(hp, '[h:hp]')
        end
        end,
    target = function(self)
        --target specific code goes here
            local Name = self.StringParent:CreateFontString(nil, 'OVERLAY')
            Name:SetPoint('LEFT',self.Health,"RIGHT", 25, 0)
            Name:SetFont(cfg.font,cfg.mainfontsize,"THINOUTLINE")
            --Name:SetWordWrap(false)
            self:Tag(Name, '[h:lvldef][name]')
        if(cfg.numbers) then
            local lvl = self.StringParent:CreateFontString(nil, 'OVERLAY')
            lvl:SetPoint('RIGHT', self.Health,'RIGHT',0,0)
            lvl:SetFont(cfg.font,cfg.smallfontsize,"THINOUTLINE")
            self:Tag(lvl, '')

            local hp = self.StringParent:CreateFontString(nil, 'OVERLAY')
            hp:SetPoint('LEFT',self.Health,5,0)
            hp:SetFont(cfg.font,cfg.smallfontsize,"THINOUTLINE")
            self:Tag(hp, '[h:hp]')
        end
        local Castbar = CreateFrame('StatusBar', nil, self)
        Castbar:SetSize(206, 25)
        Castbar:SetStatusBarTexture(cfg.texture)
        Castbar:SetStatusBarColor(1,1,1)
        Castbar:SetFrameLevel(1)
        Castbar:SetAlpha(.5)
        Castbar:SetPoint("CENTER",self.Health,"CENTER",0,0)
        
        local Icon = self.cbIconParent:CreateTexture(nil, 'OVERLAY')
        Icon:SetAlpha(1)
        Icon:SetSize(20, 20)
        Icon:SetTexCoord(0.08, 0.8, 0.08, 0.8)
        Icon:SetPoint('LEFT', Castbar, 'RIGHT',-23,0)

        -- Add a timer
        local Time = self.cbIconParent:CreateFontString(nil, 'OVERLAY')
        Time:SetFont(cfg.font,cfg.smallfontsize,"THINOUTLINE")
        Time:SetPoint('RIGHT', self.Health,-30,0)

        local Shield = CreateFrame('Frame', nil, self)
        Shield:SetSize(40,40)
        Shield:SetAlpha(0)
        Shield:SetPoint('RIGHT', Castbar, 'LEFT', -5, 0)
        self.Shield = Shield
        ShieldTexture = self.Shield:CreateTexture(nil, 'OVERLAY')
        ShieldTexture:SetAllPoints(Shield)
        ShieldTexture:SetTexture(texture)
        
        ShieldTexture:SetSize(30, 60)
       
        --Castbar.interruptIcon = Shield
        Castbar.Icon = Icon
        
        Castbar.Time = Time
        self.Castbar = Castbar
        Castbar.PostCastStart = ns.PostCastbarUpdate
        Castbar.PostCastInterruptible = ns.PostCastbarUpdate
        Castbar.PostCastNotInterruptible = ns.PostCastbarUpdate
        Castbar.PostChannelStart = ns.PostCastbarUpdate

        local Auras = CreateFrame('Frame', nil, self)
                Auras.gap = true
                Auras.size = 20
                Auras:SetHeight(60)
                Auras:SetWidth(200)
                Auras:SetPoint('BOTTOMLEFT', self.Health, 'TOPLEFT', 0, 10)
                Auras.initialAnchor = 'BOTTOMLEFT'
                Auras['growth-x'] = 'RIGHT'
                Auras['growth-y'] = 'UP'
                Auras.numBuffs = cfg.numBuffs
                Auras.numDebuffs = cfg.numDebuffs
                Auras.spacing = 2
                Auras.disableCooldown = cfg.BuffCooldowns
                Auras.showStealableBuffs = true

                Auras.PostCreateIcon = ns.UpdateAuraIcon
                Auras.PostUpdateIcon = ns.PostUpdateIcon
                self.Auras = Auras

    end,
     
        party = function(self)
    
        if(cfg.party) then
            -- Position and size
            local GroupRoleIndicator = self:CreateTexture(nil, 'OVERLAY')
            GroupRoleIndicator:SetSize(16, 16)
            GroupRoleIndicator:SetPoint('LEFT', self)

            -- Register it with oUF
            self.GroupRoleIndicator = GroupRoleIndicator    
            -- Party specific layout code.
            local PartyName = self.StringParent:CreateFontString(nil, 'OVERLAY')
            PartyName:SetPoint('LEFT',self.GroupRoleIndicator,"LEFT", 20, 0)
            PartyName:SetFont(cfg.font,cfg.smallfontsize,"THINOUTLINE")
            self.PartyName = PartyName
            
            self:Tag(PartyName, '[raidcolor][name]')

            local partyHP = self.StringParent:CreateFontString(nil, 'OVERLAY')
            partyHP:SetPoint("LEFT",self.PartyName,"RIGHT",0,0)
            partyHP:SetFont(cfg.font, cfg.smallfontsize, "THINOUTLINE")
            self:Tag(partyHP, '[h:hpcper]')
            
        end
        end,
        raid = function(self)
        if (cfg.raid) then

            local sqHealth = CreateFrame('StatusBar', nil, self)
            sqHealth:SetSize(50,50)
            sqHealth:SetTexture(texture)
            sqHealth:SetReverseFill(false)
            sqHealth:SetFrameLevel(2)
            sqHealth:SetAlpha(1)
            sqHealth.frequentUpdates = true
            sqHealth:SetReverseFill(true)
            sqHealth.PostUpdate = function(sqHealth, unit, min, max)
                sqHealth:SetValue(max - Health:GetValue())
            end
            self.Health = sqHealth

            -- Add a background
            local Background = sqHealth:CreateTexture(nil, 'BACKGROUND')
            Background:SetAllPoints()
            Background:SetTexture(texture)
            Background:SetColorTexture(0,0,0,1)
            Background:SetAlpha(1)

            -- Register it with oUF
            sqHealth.bg = Background
            -- Options
            sqHealth.frequentUpdates = true
            sqHealth.colorTapping = true
            sqHealth.colorDisconnected = true

            sqHealth.colorHealth = false
            sqHealth.colorClass = false
            sqHealth.colorReaction = false
            
            --[hpcper] in center
        end
        end,
}   

local Shared = function(self, unit)
    -- general
    self:RegisterForClicks('AnyUp')
    self:SetScript('OnEnter', UnitFrame_OnEnter)
    self:SetScript('OnLeave', UnitFrame_OnLeave)
    if(unit == "player" or unit == "target") then
    self:SetSize(200,20)
    elseif (unit == "targettarget" or unit == "focus") then
        self:SetSize(100,20)
    else
        self:SetSize(50,20)
    end

    -- We create a parent for strings so that they appear above everything else
    local StringParent = CreateFrame('Frame', nil, self)
    StringParent:SetSize(20,20)
    StringParent:SetFrameLevel(20)
    self.StringParent = StringParent
    -- We create a parent to hold castbar icons
    local cbIconParent = CreateFrame('Frame', nil, self)
    cbIconParent:SetSize(20,20)
    cbIconParent:SetFrameLevel(10)
    self.cbIconParent = cbIconParent
    self:RegisterEvent("CURRENT_SPELL_CAST_CHANGED", HideIcon)
    self:RegisterEvent("PLAYER_ENTERING_WORLD", Fader)
    self:RegisterEvent('PLAYER_REGEN_ENABLED', Fader)
    self:RegisterEvent('PLAYER_REGEN_DISABLED', Fader)
    self:RegisterEvent('PLAYER_TARGET_CHANGED', Fader)

    -- Shared layout code.
    -- Position and size
    local Health = CreateFrame('StatusBar', nil, self)
    if (unit == "player" or unit == "target") then
        Health:SetSize(200,20)
    elseif (unit == "targettarget" or unit == "focus") then
        Health:SetSize(100,20)
    end
    Health:SetPoint("CENTER")
    Health:SetStatusBarTexture(cfg.texture)
    Health:SetStatusBarColor(1, 0, 0)
    Health:SetReverseFill(false)
    --Health:SetFrameLevel(2)
    Health:SetAlpha(1)
    Health.frequentUpdates = true
    Health:SetReverseFill(true)
    Health.PostUpdate = function(Health, unit, min, max)
        Health:SetValue(max - Health:GetValue())
    end
    self.Health = Health

    -- Add a background
    local Background = Health:CreateTexture(nil, 'BACKGROUND')
    Background:SetAllPoints()
    Background:SetTexture(texture)
    Background:SetColorTexture(0,0,0,1)
    Background:SetAlpha(1)
    -- Make the background darker.
    --Background.multiplier = .5

    -- Register it with oUF
    Health.bg = Background
    -- Options
    Health.frequentUpdates = true
    Health.colorTapping = true
    Health.colorDisconnected = true
    --Health.colorClass = true
    if unit == "player" then
        Health.colorHealth = false
        Health.colorClass = false
        Health.colorReaction = false
    else
        Health.colorHealth = true
        Health.colorClass = true
        Health.colorReaction = true
    end

    --self.Health = Health
    if(UnitSpecific[unit]) then
        return UnitSpecific[unit](self)
    end
end



oUF:RegisterStyle("h", Shared)
oUF:Factory(function(self)

     self:SetActiveStyle("h")
     self:Spawn("target"):SetPoint("CENTER", cfg.playerX + cfg.offsetX, cfg.playerY + cfg.offsetY)
     self:Spawn("player"):SetPoint('CENTER', cfg.playerX, cfg.playerY)
     self:Spawn("targettarget"):SetPoint("RIGHT", oUF_hTarget,"LEFT", -25,0)
     self:Spawn("focus"):SetPoint("RIGHT",oUF_hPlayer,"LEFT",-25,0)

     -- oUF:SpawnHeader(overrideName, overrideTemplate, visibility, attributes ...)
     local party = self:SpawnHeader(nil, nil, 'raid,party,solo',
          -- http://wowprogramming.com/docs/secure_template/Group_Headers
          -- Set header attributes
          'showParty', true, 
          'showPlayer', true, 
          'yOffset', -10
     ):SetPoint("TOPLEFT", UIParent, "TOPLEFT", 10, -10)
     --party:
end)