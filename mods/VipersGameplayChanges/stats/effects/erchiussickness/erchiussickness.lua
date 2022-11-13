function init()
	self.effectMaxErchius = config.getParameter("effectMaxErchius")
	self.energyCost = config.getParameter("energyCost", 0.06)
	self.healthDamage = config.getParameter("healthDamage", 0.5)
	self.tickTimer = config.getParameter("tickTimeBase", 2.5)
	self.geigerTimer = config.getParameter("geigerTimeBase", 1.5)
	self.solidMult = config.getParameter("solidMult", 1)
	self.liquidMult = config.getParameter("liquidMult", 1)
end

function update(dt)
	local erchiusCount = ((world.entityHasCountOfItem(entity.id(), "liquidfuel") or 0) * self.liquidMult) + ((world.entityHasCountOfItem(entity.id(), "solidfuel") or 0) * self.solidMult)
	local statefflist = status.activeUniqueStatusEffectSummary()
	local efftablestring = sb.printJson(statefflist)
	if string.find(efftablestring, "erchiuscoat") then
		erchiusCount = erchiusCount * config.getParameter("erchiusCoatMult", 1.5) + config.getParameter("erchiusCoatBase", 200)
	end
	local erchiusRatioPure = erchiusCount / self.effectMaxErchius
	if erchiusCount > 0 then
		self.energyCost = erchiusRatioPure * config.getParameter("energyCost", 0.5)
		self.geigerTimer = self.geigerTimer - dt
		if self.geigerTimer <= 0 then
			local geigerTimeReduction = 0.1 * math.max(0.0, math.floor((erchiusCount) / 200))
			self.geigerTimer = math.max(0.3, (config.getParameter("geigerTimeBase", 1.5) - geigerTimeReduction)) + math.random(-1,1)*0.1
			animator.playSound("geiger_"..math.random(1,3))
		end
		if not status.overConsumeResource("energy", self.energyCost) then
			status.setResource("energy", 0)
			self.tickTimer = self.tickTimer - dt
			if self.tickTimer <= 0 then
				local erchiusOverfill = 0
				if erchiusCount > self.effectMaxErchius then
					erchiusOverfill = config.getParameter("tickTimeReductionOverCap", 0.01) * math.max(0.0, math.floor((erchiusCount - self.effectMaxErchius) / 100))
				end
				self.tickTimer = math.max(0.05, config.getParameter("tickTimeBase", 2.5) - erchiusOverfill)
				self.healthDamage = erchiusRatioPure * config.getParameter("healthDamage", 0.5)
				animator.playSound("beep")
				status.modifyResource("health", -self.healthDamage)
			end
		end
	end
end

function uninit()
end
