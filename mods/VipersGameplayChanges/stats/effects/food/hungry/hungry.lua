function init()
  world.sendEntityMessage(entity.id(), "queueRadioMessage", "hungry")
  self.healthPercentage = config.getParameter("healthPercentage", 0.8)
  self.movementModifiers = config.getParameter("movementModifiers", {})
end

function update(dt)
  self.statefflist = status.activeUniqueStatusEffectSummary()
  self.efftablestring = sb.printJson(self.statefflist)
  self.irradiated = false
  self.hasradeff = string.find(self.efftablestring, "biomeradiation")
  if self.hasradeff ~= nil then
    self.irradiated = true
  end
  
  if (not self.irradiated) then
    status.setResourcePercentage("health", math.min(status.resourcePercentage("health"), self.healthPercentage))
  end
  
  mcontroller.controlModifiers(self.movementModifiers)
end

function uninit()

end
