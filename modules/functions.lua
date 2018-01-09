local _,ns = ...
local cfg = ns.config

local function IsMine(unit)
    if (unit == 'player' or unit == 'vehicle' or unit == 'pet') then
        return true
    else
        return false
    end
end
local function UpdateAura(self, elapsed)
	if self.timeLeft then
		self.elapsed = (self.elapsed or 0) + elapsed
		if self.elapsed >= 0.1 then
			if not self.first then
				self.timeLeft = self.timeLeft - self.elapsed
			else
				self.timeLeft = self.timeLeft - GetTime()
				self.first = false
			end
			if self.timeLeft > 0 then
				local time = core.formatTime(self.timeLeft)
					self.time:SetText(time)
				if self.timeLeft < 5 then
					self.time:SetTextColor(1, 0.5, 0.5)
				else
					self.time:SetTextColor(.7, .7, .7)
				end
			else
				self.time:Hide()
				self:SetScript("OnUpdate", nil)
			end
			self.elapsed = 0
		end
	end
end

function ns:PostCastbarUpdate(element, unit)
	--local cb = element.Castbar

	local uf = self:GetParent("cbIconParent")

	if(element.isInterruptable)then
		uf.Shield:SetAlpha(1)
	else
		uf.Shield:SetAlpha(0)
	end
end

function ns:PostUpdateIcon(unit, button,index)
    button.icon:SetAlpha(1)
    if (unit == 'target') then
        if (button.isDebuff) then
            if (not IsMine(button.caster)) then
                --icon.overlay:SetVertexColor(0.45, 0.45, 0.45)
                button.icon:SetDesaturated(true)
                -- icon:SetAlpha(0.55)
            else
                button.icon:SetDesaturated(false)
                button:SetAlpha(1)
            end
        end
    end
    
    --local cooldown = button:GetParent():GetAttribute("cd")
    --button.time:SetText(button.cd:GetCooldownDuration())
end

function ns:UpdateAuraIcon(button)
        --button.overlay:SetAlpha(0)
		button.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		--button.icon:SetDrawLayer('ARTWORK')
        --button.duration:Hide()
        local count = button.count
		count:ClearAllPoints()
		count:SetPoint('TOPRIGHT', 1, 1)
		count:SetFont(cfg.font, 12, "OUTLINEMONOCHROME")
		count:SetVertexColor(0.93, 0.7, 0.39)

		local cd = CreateFrame("Cooldown", "$parentCooldown", button, "CooldownFrameTemplate");
		cd:SetAllPoints();
		cd:SetReverse(true);
		cd:SetDrawEdge(true);
		cd:SetHideCountdownNumbers(true);

		--local time = cd:CreateFontString(nil, 'OVERLAY')
		--time:SetPoint('BOTTOM', 0, 40)
		--time:SetFont(cfg.font, 12, "OUTLINEMONOCHROME")
		--time:SetVertexColor(0.9, 0.9, 0.9)
		--button.time = time
end