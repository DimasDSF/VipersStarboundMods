function ageItem(baseItem, aging)
  if baseItem.parameters.timeToRot then
    baseItem.parameters.timeToRot = baseItem.parameters.timeToRot - aging

    baseItem.parameters.tooltipFields = baseItem.parameters.tooltipFields or {}
    baseItem.parameters.tooltipFields.rotTimeLabel = getRotTimeDescription(baseItem.parameters.timeToRot)

    if baseItem.parameters.timeToRot <= 0 then
      local itemConfig = root.itemConfig(baseItem.name)
      return {
        name = itemConfig.config.rottedItem or root.assetJson("/items/rotting.config:rottedItem"),
        count = baseItem.count,
        parameters = {}
      }
    end
  end

  return baseItem
end

function getRotTimeDescription(rotTime)
  local descList = root.assetJson("/items/rotting.config:rotTimeDescriptions")
  local rotTimeL
  local rotTimeS
	if rotTime > 3599 then
		rotTimeL = math.ceil(rotTime/3600)
		rotTimeS = "%i h"
	elseif rotTime > 59 then
		rotTimeL = math.ceil(rotTime/60)
		rotTimeS = "%i m"
	else
		rotTimeL = math.ceil(rotTime)
		rotTimeS = "%i s"
	end
  for i, desc in ipairs(descList) do
    if rotTime <= desc[1] then return string.format(desc[2], string.format(rotTimeS, rotTimeL)) end
  end
  return string.format(descList[#descList], math.ceil(rotTime/60))
end
