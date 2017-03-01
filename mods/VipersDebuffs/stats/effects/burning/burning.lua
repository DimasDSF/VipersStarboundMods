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
  self.oiled = false
  self.wet = false
  
  self.hasoiledeff = string.find(self.efftablestring, "tarslow")
  self.hasweteff = string.find(self.efftablestring, "wet")
  
  if (self.hasoiledeff ~= nil) then
    self.oiled = true
  end
  if (self.hasweteff ~= nil) then
    self.wet = true
  end
  
  if effect.duration() and self.oiled then
    effect.modifyDuration(dt)
  end
  
  if effect.duration() and (not self.oiled) and (world.liquidAt({mcontroller.xPosition(), mcontroller.yPosition() - 1}) or self.wet) then
    effect.expire()
  end
  
  if self.oiled and (self.wet or world.liquidAt({mcontroller.xPosition(), mcontroller.yPosition() - 1})) then
    self.tickDamagePercentage = 0.015
  elseif self.oiled and (not (self.wet or world.liquidAt({mcontroller.xPosition(), mcontroller.yPosition() - 1}))) then
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
