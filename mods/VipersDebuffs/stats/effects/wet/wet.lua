function init()
  animator.setParticleEmitterOffsetRegion("drips", mcontroller.boundBox())
  self.mouthPosition = status.statusProperty("mouthPosition") or {0,0}
  self.mouthBounds = {self.mouthPosition[1], self.mouthPosition[2], self.mouthPosition[1], self.mouthPosition[2]}
  --animator.setParticleEmitterActive("drips", true)
end

function update(dt)
  self.statefflist = status.activeUniqueStatusEffectSummary()
  self.efftablestring = sb.printJson(self.statefflist)
  self.hasburningeff = string.find(self.efftablestring, "burning")
  self.hascoldbiomeeff = string.find(self.efftablestring, "biomecold")
  self.hasswimmingeff = string.find(self.efftablestring, "swimming")
  
  local position = mcontroller.position()
  local worldMouthPosition = {
    self.mouthPosition[1] + position[1],
    self.mouthPosition[2] + position[2]
  }
  local liquidAtMouth = world.liquidAt(worldMouthPosition)
  
  if ((self.hasswimmingeff == nil) or ((self.hasswimmingeff ~= nil) and not liquidAtMouth)) then
    animator.setParticleEmitterActive("drips", true)
  else
    animator.setParticleEmitterActive("drips", false)
  end
  
  if effect.duration() and (self.hasburningeff ~= nil) then
    effect.modifyDuration(-dt)
  end
  if effect.duration() and (self.hascoldbiomeeff ~= nil) then
    effect.modifyDuration(dt)
  end
end

function uninit()
  
end
