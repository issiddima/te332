local AutoHits = {}

AutoHits.Enabled = Menu.AddOption({"Utility", "AutoHits"}, "Script Enabled", "Enable/Disable")
AutoHits.Font = Renderer.LoadFont("Tahoma", 24, Enum.FontWeight.EXTRABOLD)

function AutoHits.OnDraw()
  if not Menu.IsEnabled(AutoHits.Enabled) then return end
  if not GameRules.GetGameState() == 5 then return end
  if not Heroes.GetLocal() then return end  
  local myHero = Heroes.GetLocal()

  if Entity.IsAlive(myHero) and Entity.GetHealth(myHero) > 0 then
    for _, npc in ipairs(NPC.GetUnitsInRadius(myHero, 99999, Enum.TeamType.TEAM_BOTH)) do
      if Entity.IsAlive(npc) and NPC.IsKillable(npc) and not Entity.IsDormant(npc) and Entity.GetHealth(npc) > 0 then
        local hitsToKill = Entity.GetHealth(npc) / (NPC.GetDamageMultiplierVersus(myHero, npc) * NPC.GetTrueDamage(myHero) * NPC.GetArmorDamageMultiplier(npc))
        local pos = NPC.GetAbsOrigin(npc)
        local x, y, visible = Renderer.WorldToScreen(pos)
        if visible and npc then
          Renderer.SetDrawColor(255, 0, 0, 255)

          if Entity.IsSameTeam(myHero, npc) then
            Renderer.SetDrawColor(255, 160, 0, 255)
          end

          if hitsToKill <= 1 then
            Renderer.SetDrawColor(0, 255, 0, 255)
          end

          if hitsToKill > 1 and hitsToKill <= 2 then
            Renderer.SetDrawColor(255, 255, 0, 255)
          end

          if Entity.IsHero(npc) then
            Renderer.SetDrawColor(0, 255, 255, 255)
          end

          if not (Entity.IsSameTeam(myHero, npc) and Entity.IsHero(npc)) and not (Entity.IsSameTeam(myHero, npc) and Entity.GetHealth(npc) >= Entity.GetMaxHealth(npc) * .5) and not (not Entity.IsHero(npc) and hitsToKill > 5) then
            Renderer.DrawTextCentered(AutoHits.Font, x, y-15, tostring(AutoHits.Round(hitsToKill, 1)), 1)
          end
        end
      end
    end
  end
end


function AutoHits.Round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

return AutoHits