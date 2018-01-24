require "/scripts/vec2.lua"
require "/scripts/util.lua"
require "/scripts/interp.lua"

function init()
	self.effectMaxErchius = config.getParameter("effectMaxErchius")
	self.energyCost = config.getParameter("energyCost", 0.06)
	self.healthDamage = config.getParameter("healthDamage", 0.5)
	self.tickTime = config.getParameter("tickTimeBase", 2.5)
	self.tickTimer = self.tickTime
end

function update(dt)
	local erchiusCount = 0
	erchiusCount = erchiusCount + (world.entityHasCountOfItem(entity.id(), "liquidfuel") or 0)
	erchiusCount = erchiusCount + (world.entityHasCountOfItem(entity.id(), "solidfuel") or 0)
	local erchiusRatio = math.min(1.0, erchiusCount / self.effectMaxErchius)
	local erchiusRatioPure = erchiusCount / self.effectMaxErchius
	if erchiusCount > 0 then
		self.energyCost = erchiusRatioPure * config.getParameter("energyCost", 0.5)
		if not status.overConsumeResource("energy", self.energyCost) then
			status.setResource("energy", 0)
			self.tickTimer = self.tickTimer - dt
			if self.tickTimer <= 0 then
				local erchiusOverfill = 0
				if erchiusCount > self.effectMaxErchius then
					erchiusOverfill = config.getParameter("tickTimeReductionOverCap", 0.01) * math.max(0.0, math.floor((erchiusCount - self.effectMaxErchius) / 100))
				end
				self.tickTime = math.max(0.05, config.getParameter("tickTimeBase", 2.5) - erchiusOverfill)
				self.tickTimer = self.tickTime
				self.healthDamage = erchiusRatioPure * config.getParameter("healthDamage", 0.5)
				animator.playSound("beep")
				status.modifyResource("health", -self.healthDamage)
			end
		end
	end
end

function uninit()
end
