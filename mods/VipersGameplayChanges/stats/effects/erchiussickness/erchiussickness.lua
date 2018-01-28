require "/scripts/vec2.lua"
require "/scripts/util.lua"
require "/scripts/interp.lua"

function init()
	self.effectMaxErchius = config.getParameter("effectMaxErchius")
	self.energyCost = config.getParameter("energyCost", 0.06)
	self.healthDamage = config.getParameter("healthDamage", 0.5)
	self.tickTime = config.getParameter("tickTimeBase", 2.5)
	self.tickTimer = self.tickTime
	self.geigerTime = config.getParameter("geigerTimeBase", 1.5)
	self.geigerTimer = self.geigerTime
end

function update(dt)
	local erchiusCount = 0
	erchiusCount = erchiusCount + (world.entityHasCountOfItem(entity.id(), "liquidfuel") or 0)
	erchiusCount = erchiusCount + (world.entityHasCountOfItem(entity.id(), "solidfuel") or 0)
	local statefflist = status.activeUniqueStatusEffectSummary()
	local efftablestring = sb.printJson(statefflist)
	if string.find(efftablestring, "erchiuscoat") then
		erchiusCount = erchiusCount * config.getParameter("erchiusCoatMult", 1.5)
	end
	local erchiusRatioPure = erchiusCount / self.effectMaxErchius
	if erchiusCount > 0 then
		self.energyCost = erchiusRatioPure * config.getParameter("energyCost", 0.5)
		self.geigerTimer = self.geigerTimer - dt
		if self.geigerTimer <= 0 then
			local geigerTimeReduction = 0.1 * math.max(0.0, math.floor((erchiusCount) / 200))
			self.geigerTime = math.max(0.3, (config.getParameter("geigerTimeBase", 1.5) - geigerTimeReduction)) + math.random(-1,1)*0.1
			self.geigerTimer = self.geigerTime
			local randomsound = math.random(1,3)
			if randomsound == 1 then
				animator.playSound("geiger_1")
			elseif randomsound == 2 then
				animator.playSound("geiger_2")
			elseif randomsound == 3 then
				animator.playSound("geiger_3")
			end
		end
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
