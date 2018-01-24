function init()
  world.sendEntityMessage(entity.id(), "queueRadioMessage", "starving")

  self.soundInterval = config.getParameter("soundInterval")
  self.soundTimer = 0

  self.tickTime = config.getParameter("starttickTime", 10)
  self.tickTimer = self.tickTime
  self.dmgincrement = 0
  self.cfgdmgIncrement = config.getParameter("damageIncrement", 0.05)
  self.cfgtimerDecrement = config.getParameter("delayDecrement", 0.05)
  self.movementModifiers = config.getParameter("movementModifiers", {})
  self.healthPercentage = config.getParameter("healthPercentage", 0.5)
end

function update(dt)
  self.statefflist = status.activeUniqueStatusEffectSummary()
  self.efftablestring = sb.printJson(self.statefflist)
  self.irradiated = false
  self.hasradeff = string.find(self.efftablestring, "biomeradiation")
  if self.hasradeff ~= nil then
    self.irradiated = true
  end
  
  --self.soundTimer = math.max(0, self.soundTimer - dt)
  --if self.soundTimer == 0 then
  --  animator.playSound("beep")
  --  self.soundTimer = self.soundInterval
  --end
  
  if (not self.irradiated) then
    status.setResourcePercentage("health", math.min(status.resourcePercentage("health"), self.healthPercentage))
  end
  
  self.tickTimer = self.tickTimer - dt
  if self.tickTimer <= 0 then
    self.tickTime = self.tickTime - self.cfgtimerDecrement
	self.tickTime = math.max(self.tickTime, 0.5)
    self.tickTimer = self.tickTime
    self.dmgincrement = self.dmgincrement + self.cfgdmgIncrement
	self.dmgincrement = math.min(self.dmgincrement, 0.7)
    local tickDamage = self.dmgincrement
	animator.playSound("beep")
    status.modifyResource("health", -tickDamage)
  end
  mcontroller.controlModifiers(self.movementModifiers)
end

function uninit()

end
