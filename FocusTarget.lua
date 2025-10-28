-- FocusTarget (WotLK 3.3.5a) – mała ramka "focustarget" w stylu Target-of-Target

local function CreateFocusTarget()
  if _G.FocusTargetFrame then return _G.FocusTargetFrame end
  local ft = CreateFrame("Button", "FocusTargetFrame", UIParent, "TargetofTargetFrameTemplate")
  ft:SetFrameStrata("LOW")
  ft:SetScale(1.0)

  -- Klikanie jak ToT (prawy: menu, lewy: target)
  ft:SetAttribute("unit", "focustarget")
  ft.unit = "focustarget"
  ft:RegisterForClicks("AnyUp")

  -- Pozycja pod FocusFrame (dostosuj jak chcesz)
  if _G.FocusFrame then
    ft:ClearAllPoints()
    ft:SetPoint("TOPLEFT", FocusFrame, "BOTTOMLEFT", 30, -10)
  else
    ft:SetPoint("CENTER", UIParent, "CENTER", 0, -120)
  end

  ft:Hide()
  return ft
end

local ft = CreateFocusTarget()

local function UpdateFT()
  if UnitExists("focustarget") then
    TargetofTarget_Update(ft)   -- użyj blizzowej logiki ToT
    ft:Show()
  else
    ft:Hide()
  end
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_FOCUS_CHANGED")
f:RegisterEvent("UNIT_TARGET")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(_, event, arg1)
  if event == "UNIT_TARGET" and arg1 ~= "focus" then return end
  UpdateFT()
end)

-- Na wszelki wypadek: aktualizuj przy pokazaniu/ukryciu FocusFrame
if _G.FocusFrame then
  FocusFrame:HookScript("OnShow", UpdateFT)
  FocusFrame:HookScript("OnHide", UpdateFT)
end
