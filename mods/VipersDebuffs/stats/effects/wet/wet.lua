function init()
  animator.setParticleEmitterOffsetRegion("drips", mcontroller.boundBox())
  animator.setParticleEmitterActive("drips", true)
end

function update(dt)
  self.statefflist = status.activeUniqueStatusEffectSummary()
  self.efftablestring = sb.printJson(self.statefflist)
  self.hungerPercentage = 0.9
  self.isburning = false
  self.iscold = false
  self.hasburningeff = string.find(self.efftablestring, "burning")
  self.hascoldbiomeeff = string.find(self.efftablestring, "biomecold")
  if (self.hasburningeff ~= nil) then
    self.isburning = true
  end
  if (self.hascoldbiomeeff ~= nil) then
    self.iscold = true
  end
  
  status.addEphemeralEffect("hungry", 1000)
  
  if effect.duration() and self.isburning then
    effect.modifyDuration(-dt)
  end
  
  if effect.duration() and self.iscold then
    effect.modifyDuration(dt)
  end
end

function uninit()
  
end
