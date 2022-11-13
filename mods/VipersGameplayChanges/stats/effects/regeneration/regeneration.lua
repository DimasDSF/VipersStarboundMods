function init()
  animator.setParticleEmitterOffsetRegion("healing", mcontroller.boundBox())
  animator.setParticleEmitterActive("healing", config.getParameter("particles", true))

  script.setUpdateDelta(5)

  self.healingRate = 1.0 / config.getParameter("healTime", 60)
end

function update(dt)
	if entity.entityType() == "player" then
		local hungermult = math.max(0.15, math.min(1.0, status.resource("food")/status.resourceMax("food")))
		local satietyusage = self.healingRate * 0.01 * dt
		if status.resource("health") < status.resourceMax("health") then
			status.consumeResource("food", satietyusage)
		end
		status.modifyResourcePercentage("health", self.healingRate * hungermult * dt)
	else
		status.modifyResourcePercentage("health", self.healingRate * dt)
	end
end

function uninit()
  
end
