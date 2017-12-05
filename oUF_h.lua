local _, ns = ...
--get Config out of the Namespace
local cfg = ns.config

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

    if (not UnitAffectingCombat("player")) 
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
        Power:SetPoint("LEFT",self.Health,"RIGHT",30,0)
        Power:SetReverseFill(false)
        Power:SetStatusBarTexture(cfg.texture)
        Power:SetAlpha(1)

        -- Add a background
        local Background = Power:CreateTexture(nil, 'BACKGROUND')
        Background:SetAllPoints(Power)
        Background:SetTexture(1, 1, 1,.5)
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
        Icon:SetPoint('RIGHT', Castbar, 'LEFT',-10,0)

        -- Add a timer
        local Time = self.cbIconParent:CreateFontString(nil, 'OVERLAY')
        Time:SetFont(cfg.font,18,"THINOUTLINE")
        Time:SetPoint('RIGHT', self.Health,-5,0)
        --bind time to stringparent
        self.StringParent.Time = Time
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
            pp:SetFont(cfg.font,18,"THINOUTLINE")
            --Name:SetWordWrap(false)
            self:Tag(pp, '[h:pp]')

            local hp = self.StringParent:CreateFontString(nil, 'OVERLAY')
            hp:SetPoint('LEFT',self.Health,5,0)
            hp:SetFont(cfg.font,18,"THINOUTLINE")
            self:Tag(hp, '[h:hp]')
        end
        end,
    target = function(self)
        --target specific code goes here
            local Name = self.StringParent:CreateFontString(nil, 'OVERLAY')
            Name:SetPoint('LEFT',self.Health,"RIGHT", 30, 0)
            Name:SetFont(cfg.font,18,"THINOUTLINE")
            --Name:SetWordWrap(false)
            self:Tag(Name, '[name]')
        if(cfg.numbers) then
            local lvl = self.StringParent:CreateFontString(nil, 'OVERLAY')
            lvl:SetPoint('RIGHT', self.Health,'RIGHT',0,0)
            lvl:SetFont(cfg.font,18,"THINOUTLINE")
            self:Tag(lvl, '[h:lvldef]')

            local hp = self.StringParent:CreateFontString(nil, 'OVERLAY')
            hp:SetPoint('LEFT',self.Health,5,0)
            hp:SetFont(cfg.font,18,"THINOUTLINE")
            self:Tag(hp, '[h:hp]')
        end

    end,
     
        party = function(self)
        if(cfg.partyframe) then
            -- Party specific layout code.
            local Name = self.StringParent:CreateFontString(nil, 'OVERLAY')
            Name:SetPoint('LEFT',self,"RIGHT", 0, 0)
            Name:SetFont(cfg.font,12,"THINOUTLINE")
            
            self:Tag(Name, '[name]')     
        end
        end,
}

local Shared = function(self, unit)
    -- general
    self:RegisterForClicks('AnyUp')
    self:SetScript('OnEnter', UnitFrame_OnEnter)
    self:SetScript('OnLeave', UnitFrame_OnLeave)
    self:SetSize(200,20)

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
    Health:SetFrameLevel(2)
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
    Background:SetTexture(1, 1, 1)
    Background:SetColorTexture(0,0,0)
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



oUF:RegisterStyle("plainsimple", Shared)
oUF:Factory(function(self)

     self:SetActiveStyle("plainsimple")
     self:Spawn("target"):SetPoint("CENTER", 0, -150)
     self:Spawn("player"):SetPoint('CENTER', 0, -180)
     self:Spawn("targettarget"):SetPoint("RIGHT", oUF_plainsimpleTarget,"LEFT", 120,0)

     -- oUF:SpawnHeader(overrideName, overrideTemplate, visibility, attributes ...)
     local party = self:SpawnHeader(nil, nil, 'raid,party,solo',
          -- http://wowprogramming.com/docs/secure_template/Group_Headers
          -- Set header attributes
          'showParty', true, 
          'showPlayer', true, 
          'yOffset', -10
     ):SetPoint("LEFT", UIParent, "TOPLEFT", -200, -10)
     --party:
end)