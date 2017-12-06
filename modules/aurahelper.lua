local _,ns = ...


local function IsMine(unit)
    if (unit == 'player' or unit == 'vehicle' or unit == 'pet') then
        return true
    else
        return false
    end
end

function ns:PostUpdateIcon(unit, button)
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
end

function ns:UpdateAuraIcon(button)
        --button:SetSize(50,50)
    	--button:SetBackdrop(BACKDROP)
		--button:SetBackdropColor(0, 0, 0)
		--button.cd:SetReverse(true)
		--button.cd:SetHideCountdownNumbers(true)
        button.overlay:SetAlpha(0)
		button.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
		button.icon:SetDrawLayer('ARTWORK')
		-- XXX: Borked in oUF v1.6+, button:GetSize() returns 0
        --button.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
        --button.icon:ClearAllPoints()
        --button.icon:SetPoint('CENTER', button)
        --button.icon:SetSize(size, size)

        --button.overlay:SetTexture(config.media.border)
        --button.overlay:SetTexCoord(0, 1, 0, 1)
        --button.overlay:ClearAllPoints()
        --button.overlay:SetPoint('TOPRIGHT', button.icon, 1.35, 1.35)
        --button.overlay:SetPoint('BOTTOMLEFT', button.icon, -1.35, -1.35)

        --button.count:SetFont(config.font.normal, 11, 'THINOUTLINE')
        --button.count:SetShadowOffset(0, 0)
        --button.count:ClearAllPoints()
        --button.count:SetPoint('BOTTOMRIGHT', button.icon, 2, 0)


        --if (config.show.disableCooldown) then
          --  button.cd:SetReverse()
          --  button.cd:SetDrawEdge(true)
          --  button.cd:ClearAllPoints()
          --  button.cd:SetPoint('TOPRIGHT', button.icon, 'TOPRIGHT', -1, -1)
          --  button.cd:SetPoint('BOTTOMLEFT', button.icon, 'BOTTOMLEFT', 1, 1)
        --else
          --  auras.disableCooldown = true
            -- button.cd.noOCC = true
        --[[
            button.remaining = button:CreateFontString(nil, 'OVERLAY')
            button.remaining:SetFont(config.font.normal, 8, 'THINOUTLINE')
            button.remaining:SetShadowOffset(0, 0)
            button.remaining:SetPoint('TOP', button.icon, 0, 2)
        end

        --if (not button.Shadow) then
          --  button.Shadow = button:CreateTexture(nil, 'BACKGROUND')
          --  button.Shadow:SetPoint('TOPLEFT', button.icon, 'TOPLEFT', -4, 4)
          --  button.Shadow:SetPoint('BOTTOMRIGHT', button.icon, 'BOTTOMRIGHT', 4, -4)
          --  button.Shadow:SetTexture('Interface\\AddOns\\oUF_Neav\\media\\borderBackground')
          --  button.Shadow:SetVertexColor(0, 0, 0, 1)
        --end

        if (button.stealable) then
            local stealable = button:CreateTexture(nil, 'OVERLAY')
            stealable:SetPoint('TOPLEFT', -4, 4)
            stealable:SetPoint('BOTTOMRIGHT', 4, -4)
        end
        
        button.overlay.Hide = function(self)
            self:SetVertexColor(0.5, 0.5, 0.5, 1)
        end
        ]]
end