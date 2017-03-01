function init()
  animator.setParticleEmitterOffsetRegion("snow", mcontroller.boundBox())
  animator.setParticleEmitterActive("snow", true)

  effect.setParentDirectives(config.getParameter("directives", ""))

  self.movementModifiers = config.getParameter("movementModifiers", {})

  self.energyCost = config.getParameter("energyCost", 1)
  self.healthDamage = config.getParameter("healthDamage", 1)
  
  script.setUpdateDelta(config.getParameter("tickRate", 1))

  effect.addStatModifierGroup({{stat = "energyRegenPercentageRate", effectiveMultiplier = 0}})

  world.sendEntityMessage(entity.id(), "queueRadioMessage", "biomecold")
end

function update(dt)
  self.statefflist = status.activeUniqueStatusEffectSummary()
  self.efftablestring = sb.printJson(self.statefflist)
  self.iswet = false
  self.hasweteff = string.find(self.efftablestring, "wet")
  if self.hasweteff ~= nil then
    self.iswet = true
  end
  
  if self.iswet then
    self.energyCost = 2 * (config.getParameter("energyCost", 1))
	self.healthDamage = 1.2 * (config.getParameter("healthDamage", 1))
  else
    self.energyCost = config.getParameter("energyCost", 1)
	self.healthDamage = config.getParameter("healthDamage", 1)
  end
  
  mcontroller.controlModifiers(self.movementModifiers)
  if not status.overConsumeResource("energy", self.energyCost) then
    status.applySelfDamageRequest({
        damageType = "IgnoresDef",
        damage = self.healthDamage,
        damageSourceKind = "ice",
        sourceEntityId = entity.id()
      })
  end
end

function uninit()

end
