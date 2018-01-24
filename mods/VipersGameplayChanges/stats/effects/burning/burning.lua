function init()
  animator.setParticleEmitterOffsetRegion("flames", mcontroller.boundBox())
  animator.setParticleEmitterActive("flames", true)
  effect.setParentDirectives("fade=BF3300=0.25")
  animator.playSound("burn", -1)
  
  script.setUpdateDelta(5)
  self.tickDamagePercentage = 0.030
  self.tickTime = 1.0
  self.tickTimer = self.tickTime
end

function update(dt)
  self.statefflist = status.activeUniqueStatusEffectSummary()
  self.efftablestring = sb.printJson(self.statefflist)
  self.hasoiledeff = string.find(self.efftablestring, "tarslow")
  self.hasweteff = string.find(self.efftablestring, "wet")
  
  if effect.duration() and (self.hasoiledeff ~= nil) then
    effect.modifyDuration(dt)
  end
  
  if effect.duration() and (self.hasoiledeff == nil) and (world.liquidAt({mcontroller.xPosition(), mcontroller.yPosition() - 1}) or (self.hasweteff ~= nil)) then
    effect.expire()
  end
  
  if (self.hasoiledeff ~= nil) and ((self.hasweteff ~= nil) or world.liquidAt({mcontroller.xPosition(), mcontroller.yPosition() - 1})) then
    self.tickDamagePercentage = 0.015
  elseif (self.hasoiledeff ~= nil) and (not ((self.hasweteff ~= nil) or world.liquidAt({mcontroller.xPosition(), mcontroller.yPosition() - 1}))) then
    self.tickDamagePercentage = 0.040
  else
    self.tickDamagePercentage = 0.030
  end

  self.tickTimer = self.tickTimer - dt
  if self.tickTimer <= 0 then
    self.tickTimer = self.tickTime
    status.applySelfDamageRequest({
        damageType = "IgnoresDef",
        damage = math.floor(status.resourceMax("health") * self.tickDamagePercentage) + 1,
        damageSourceKind = "fire",
        sourceEntityId = entity.id()
      })
  end
end

function uninit()
  
end
