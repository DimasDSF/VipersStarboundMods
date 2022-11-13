require "/scripts/rect.lua"

function init()
  effect.addStatModifierGroup({{stat = "nude", amount = 1}, {stat = "foodDelta", effectiveMultiplier = 0}})
  if status.isResource("food") and not status.resourcePositive("food") then
    status.setResource("food", 0.01)
  end

  animator.setParticleEmitterOffsetRegion("healing", rect.rotate(mcontroller.boundBox(), mcontroller.rotation()))
  if entity.entityType() ~= "player" then
	animator.setParticleEmitterActive("healing", true)
  end

  script.setUpdateDelta(5)

  self.healingRate = 1.0 / config.getParameter("healTime", 60)
  self.sleepDuration = 0
end

function easeInOutCubic(x, xstart, xend)
	-- This is a fucking abomination
	-- But its 8 AM and I want to sleep
	local midpoint = (xstart + xend)/2
	local normalized = x/midpoint/2
	return ((normalized < 0.5) and (4 * normalized^3)) or (1 - (-2 * normalized + 2)^3 / 2)
end

function update(dt)
	if entity.entityType() == "player" then
		local nightMod = (world.timeOfDay()*2-1)^2 + 0.2
		local consumed = 0
		if status.resource("health") < status.resourceMax("health") then
			local satietyusage = self.healingRate * 0.01 * 2 * (status.resource("health")/status.resourceMax("health")) * dt
			animator.setParticleEmitterActive("healing", true)
			if status.resourcePositive("food") then
				consumed = status.consumeResource("food", satietyusage) and 1 or 0
			end
		else
			animator.setParticleEmitterActive("healing", false)
		end
		self.sleepDuration = self.sleepDuration + script.updateDt()
		local maxSleepTime = config.getParameter("healTime", 60)
		local durationMod = math.max(0.2, math.min(1.5, (1.5*easeInOutCubic(self.sleepDuration, maxSleepTime*0.1, maxSleepTime*0.25))))
		local foodMod = (0.2 + (0.8 * consumed))
		status.modifyResourcePercentage("health", self.healingRate * durationMod * foodMod * nightMod * dt)
	else
		status.modifyResourcePercentage("health", self.healingRate * dt)
	end
end

function uninit()

end
