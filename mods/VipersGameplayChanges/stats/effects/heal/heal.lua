function init()
  animator.setParticleEmitterOffsetRegion("healing", mcontroller.boundBox())
  animator.setParticleEmitterEmissionRate("healing", config.getParameter("emissionRate", 3))
  animator.setParticleEmitterActive("healing", true)

  script.setUpdateDelta(5)

  self.healingRate = config.getParameter("healAmount", 30) / effect.duration()
end

function update(dt)
	if entity.entityType() == "player" then
		local hungermult = math.max(0.3, math.min(1.0, status.resource("food")/status.resourceMax("food")))
		local satietyusage = self.healingRate * 0.01 * dt
		if status.resource("health") < status.resourceMax("health") then
			status.consumeResource("food", satietyusage)
		end
		status.modifyResource("health", self.healingRate * hungermult * dt)
	else
		status.modifyResource("health", self.healingRate * dt)
	end
end

function uninit()
  
end
