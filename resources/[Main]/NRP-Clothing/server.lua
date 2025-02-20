RegisterServerEvent('outfits:saveskin')
AddEventHandler('outfits:saveskin', function(skin, name)
 local source = tonumber(source)
 TriggerEvent('core:getPlayerFromId', source, function(user)
  exports['GHMattiMySQL']:QueryAsync('INSERT INTO `outfits` (char_id, outfit_name, outfit_clothing) VALUES (@charid, @name, @skin)',{['@charid'] = user.getCharacterID(), ['@name'] = name, ['@skin'] = json.encode(skin)})
  TriggerClientEvent('NRP-notify:client:SendAlert', source, { type = 'inform', text = "Outfit Saved"})
 end)
end)

RegisterServerEvent('outfits:deleteoutfit')
AddEventHandler('outfits:deleteoutfit', function(name) 
 local source = tonumber(source)
 TriggerEvent('core:getPlayerFromId', source, function(user)	
  exports['GHMattiMySQL']:QueryAsync('DELETE FROM `outfits` WHERE (char_id = @charid AND outfit_name = @name)',{['@charid'] = user.getCharacterID(), ['@name'] = name})
  TriggerClientEvent('NRP-notify:client:SendAlert', source, { type = 'inform', text = "Outfit Deleted"})
 end)
end)

RegisterServerEvent('outfits:getoutfits')
AddEventHandler('outfits:getoutfits', function()
 local source = tonumber(source)
 TriggerEvent('core:getPlayerFromId', source, function(user)
  local outfits = {}
  local result = exports['GHMattiMySQL']:QueryResult("SELECT * FROM `outfits` WHERE char_id=@charid",{['@charid'] = user.getCharacterID()})
  for _,v in pairs(result) do
   table.insert(outfits, {skin = v.outfit_clothing, name = v.outfit_name, id = v.id})
  end
  TriggerClientEvent('outfits:outfitlist', source, outfits)
 end)
end)

RegisterServerEvent('outfits:share')
AddEventHandler('outfits:share', function(target, name, outfit)
 local source = tonumber(source)
 local target = tonumber(target)
 TriggerEvent('core:getPlayerFromId', target, function(user)
  exports['GHMattiMySQL']:QueryAsync('INSERT INTO `outfits` (char_id, outfit_name, outfit_clothing) VALUES (@charid, @name, @skin)',{['@charid'] = user.getCharacterID(), ['@name'] = name, ['@skin'] = outfit})
  TriggerClientEvent('NRP-notify:client:SendAlert', source, { type = 'inform', text = "Outfit Shared With "..user.getIdentity().fullname})
 end)
end)

TriggerEvent('core:addCommand', 'clothes', function(source, args, user)
 local source = tonumber(source)
 TriggerEvent('core:getPlayerFromId', source, function(user)
  local outfit = json.decode(user.getOutfit())
  if outfit ~= nil then
   TriggerClientEvent('clothes:load', source, outfit)
  end
 end)
end)
