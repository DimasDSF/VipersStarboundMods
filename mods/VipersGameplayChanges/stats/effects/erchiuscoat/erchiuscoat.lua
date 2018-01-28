function init()
	animator.setParticleEmitterOffsetRegion("drips", mcontroller.boundBox())
	self.mouthPosition = status.statusProperty("mouthPosition") or {0,0}
	self.mouthBounds = {self.mouthPosition[1], self.mouthPosition[2], self.mouthPosition[1], self.mouthPosition[2]}
end

function update(dt)
  
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
end

function uninit()
  
end
