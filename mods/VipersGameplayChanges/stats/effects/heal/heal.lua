function init()
  animator.setParticleEmitterOffsetRegion("healing", mcontroller.boundBox())
  animator.setParticleEmitterEmissionRate("healing", config.getParameter("emissionRate", 3))
  animator.setParticleEmitterActive("healing", true)

  script.setUpdateDelta(5)

  self.healingRate = config.getParameter("healAmount", 30) / effect.duration()
end

function update(dt)
	local statefflist = status.activeUniqueStatusEffectSummary()
	local efftablestring = sb.printJson(statefflist)
	local hashungryeff = string.find(efftablestring, "hungry")
	local hasstarvingeff = string.find(efftablestring, "starving")
	local starvinghealmult = 1.0
	if hashungryeff ~= nil then
		starvinghealmult = 0.7
	elseif hasstarvingeff ~= nil then
		starvinghealmult = 0.3
	end
	status.modifyResource("health", self.healingRate * starvinghealmult * dt)
end

function uninit()
  
end
