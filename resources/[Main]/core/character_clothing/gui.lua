GUI = {}
Menu = {}

Menus = {}

--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--
--==============================================================================================--
--                                           Settings                                           --
--==============================================================================================--
--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--
GUI.maxVisOptions = 8 ------------------------ Max options to show on the menu                  --
GUI.titleText = {0, 150, 0, 255, 1} ------- Color of title text                             --
GUI.titleRect = {0, 0, 0, 255} ------------- Color of rectangle [title]                      --
GUI.optionText = {255, 255, 255, 255, 6} ------ Color of option text                            --
GUI.optionRect = {0, 0, 0, 190} ------------ Color of option rectangles                      --
GUI.scroller = {0, 150, 0, 255} ----------- Color of active option                            --
titleTextSize = {0.85, 0.65} ------------ {p1, Size}                                     		--
titleRectSize = {0.16, 0.085} ----------- {Width, Height}                                		--
optionTextSize = {0.5, 0.5} ------------- {p1, Size}                                     		--
optionRectSize = {0.16, 0.035} ---------- {Width, Height}                                 		--
menuX = 0.9 ----------------------------- X position of the menu                         		--
menuXOption = 0.075 --------------------- X postiion of Menu.Option text                 		--
menuXOtherOption = 0.055 ---------------- X position of Bools, Arrays etc text            		--
menuYModify = 0.6500 -------------------- Default: 0.1174   ------ Top bar                		--
menuYOptionDiv = 18.56 ------------------ Default: 3.56   ------ Distance between buttons 		--
menuYOptionAdd = 0.675 ------------------ Default: 0.142  ------ Move buttons up and down 		--
--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--
--==============================================================================================--
--                                           Settings                                           --
--==============================================================================================--
--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--==--

local menuOpen = false
prevMenu = nil
curMenu = nil
local selectPressed = false
local leftPressed = false
local rightPressed = false
currentOption = 1
local optionCount = 0

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function Menu.IsOpen() 
	return menuOpen == true
end

function Menu.SetupMenu(menu, title)
	Menus[menu] = {}
	Menus[menu].title = title
	Menus[menu].optionCount = 0
	Menus[menu].options = {}
	Menus[menu].previous = nil
	--currentOption = 1
end

function Menu.addOption(menu, option)
	if not (Menus[menu].title == nil) then
		Menus[menu].optionCount = Menus[menu].optionCount + 1
		Menus[menu].options[Menus[menu].optionCount] = option
	end
end

function Menu.Switch(prevmenu, menu)
  curMenu = menu
  prevMenu = prevmenu
  if Menus[menu] then
    if Menus[menu].optionCount then
      if Menus[menu].optionCount < currentOption then
        currentOption = Menus[menu].optionCount
        if currentOption == 0 then
          currentOption = 1
        end
      end
    end
  end
  if prevmenu ~= nil and menu ~= "" then
    Menus[menu].previous = prevmenu
  end
end

function Menu.DisplayCurMenu()
	if not (curMenu == "") then
		menuOpen = true
		Menu.Title(Menus[curMenu].title)
		for k,v in pairs(Menus[curMenu].options) do
			v()
		end
		Menu.updateSelection()
	end
end

function GUI.Text(text, color, position, size, center)
	SetTextCentre(center)
	SetTextColour(color[1], color[2], color[3], color[4])
	SetTextFont(color[5])
	SetTextScale(size[1], size[2])
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(position[1], position[2])
end

function GUI.Rect(color, position, size)
	DrawRect(position[1], position[2], size[1], size[2], color[1], color[2], color[3], color[4])
end

function Menu.Title(title)
	GUI.Text(title, GUI.titleText, {menuX, menuYModify - 0.02241}, titleTextSize, true)
	GUI.Rect(GUI.titleRect, {menuX, menuYModify}, titleRectSize)
	Menu.PageCounter()
end

function Menu.PageCounter()
	GUI.Text(currentOption.."/"..Menus[curMenu].optionCount, GUI.optionText, {menuX + menuXOption - 0.02, ((menuYOptionAdd - 0.018) + (optionCount / menuYOptionDiv) * menuYModify)},  optionTextSize, false)
	GUI.Rect(GUI.optionRect, { menuX, (menuYOptionAdd + (optionCount / menuYOptionDiv) * menuYModify) }, optionRectSize)
	RequestStreamedTextureDict("commonmenu", true)
	DrawSprite("commonmenu", "shop_arrows_upanddown", menuX, ((menuYOptionAdd - 0.018) + (optionCount / menuYOptionDiv) * menuYModify + 0.015), 0.03, 0.03, 0.0, 255, 255, 255, 255)
	GUI.Rect(GUI.titleRect, { menuX, (menuYOptionAdd + (optionCount / menuYOptionDiv) * menuYModify + 0.015) }, {optionRectSize[1], optionRectSize[2] - 0.03})
end

function Menu.Option(option)
	optionCount = optionCount + 1

	local thisOption = nil
	if(currentOption == optionCount) then
		thisOption = true
	else
		thisOption = false
	end

	if(currentOption <= GUI.maxVisOptions and optionCount <= GUI.maxVisOptions) then
		GUI.Text(option, GUI.optionText, {menuX - menuXOption, ((menuYOptionAdd - 0.018) + (optionCount / menuYOptionDiv) * menuYModify)},  optionTextSize, false)
		GUI.Rect(GUI.optionRect, { menuX, (menuYOptionAdd + (optionCount / menuYOptionDiv) * menuYModify) }, optionRectSize)
		if(thisOption) then
			RequestStreamedTextureDict("timerbars", true)
			DrawSprite("timerbars", "all_white_bg", menuX + 0.045, (menuYOptionAdd + (optionCount / menuYOptionDiv) * menuYModify), optionRectSize[1] + 0.1, optionRectSize[2], 180.0, GUI.scroller[1], GUI.scroller[2], GUI.scroller[3], GUI.scroller[4])
		end
	elseif (optionCount > currentOption - GUI.maxVisOptions and optionCount <= currentOption) then
		GUI.Text(option, GUI.optionText, {menuX - menuXOption, ((menuYOptionAdd - 0.018) + ((optionCount - (currentOption - GUI.maxVisOptions)) / menuYOptionDiv) * menuYModify)},  optionTextSize, false)
		GUI.Rect(GUI.optionRect, { menuX, (menuYOptionAdd + ((optionCount - (currentOption - GUI.maxVisOptions)) / menuYOptionDiv) * menuYModify) }, optionRectSize)
		if(thisOption) then
			RequestStreamedTextureDict("timerbars", true)
			DrawSprite("timerbars", "all_white_bg", menuX + 0.045, (menuYOptionAdd + ((optionCount - (currentOption - GUI.maxVisOptions)) / menuYOptionDiv) * menuYModify), optionRectSize[1] + 0.1, optionRectSize[2], 180.0, GUI.scroller[1], GUI.scroller[2], GUI.scroller[3], GUI.scroller[4])
		end
	end

	if (optionCount == currentOption and selectPressed) then
		return true
	end

	return false
end

function Menu.Option2(option)
	optionCount = optionCount + 1

	local thisOption = nil
	if(currentOption == optionCount) then
		thisOption = true
	else
		thisOption = false
	end

	if(currentOption <= GUI.maxVisOptions and optionCount <= GUI.maxVisOptions) then
		GUI.Text(option, GUI.optionText, {menuX - menuXOption, ((menuYOptionAdd - 0.018) + (optionCount / menuYOptionDiv) * menuYModify)},  optionTextSize, false)
		GUI.Rect(GUI.optionRect, { menuX, (menuYOptionAdd + (optionCount / menuYOptionDiv) * menuYModify) }, optionRectSize)
		if(thisOption) then
			GUI.Rect(GUI.scroller, { menuX, (menuYOptionAdd + (optionCount / menuYOptionDiv) * menuYModify) }, optionRectSize)
		end
	elseif (optionCount > currentOption - GUI.maxVisOptions and optionCount <= currentOption) then
		GUI.Text(option, GUI.optionText, {menuX - menuXOption, ((menuYOptionAdd - 0.018) + ((optionCount - (currentOption - GUI.maxVisOptions)) / menuYOptionDiv) * menuYModify)},  optionTextSize, false)
		GUI.Rect(GUI.optionRect, { menuX, (menuYOptionAdd + ((optionCount - (currentOption - GUI.maxVisOptions)) / menuYOptionDiv) * menuYModify) }, optionRectSize)
		if(thisOption) then
			GUI.Rect(GUI.scroller, { menuX, (menuYOptionAdd + ((optionCount - (currentOption - GUI.maxVisOptions)) / menuYOptionDiv) * menuYModify) }, optionRectSize)
		end
	end

	if (optionCount == currentOption and selectPressed) then
		return true
	end

	return false
end

function Menu.changeMenu(option, menu)
	if (Menu.Option(option)) then
		Menu.Switch(curMenu, menu)
	end

	if(currentOption <= GUI.maxVisOptions and optionCount <= GUI.maxVisOptions) then
		GUI.Text(">>", GUI.optionText, { menuX + menuXOtherOption, ((menuYOptionAdd - 0.018) + (optionCount / menuYOptionDiv) * menuYModify)}, optionTextSize, true)
	elseif(optionCount > currentOption - GUI.maxVisOptions and optionCount <= currentOption) then
		GUI.Text(">>", GUI.optionText, { menuX + 0.068, ((menuYOptionAdd - 0.018) + ((optionCount - (currentOption - GUI.maxVisOptions)) / menuYOptionDiv) * menuYModify)}, optionTextSize, true)
	end

	if (optionCount == currentOption and selectPressed) then
		return true
	end

	return false
end

function Menu.Bool(option, bool, option2, option3, cb)
	Menu.Option(option)

	if(currentOption <= GUI.maxVisOptions and optionCount <= GUI.maxVisOptions) then
		if(bool) then
			GUI.Text(option2, GUI.optionText, { menuX + menuXOtherOption, ((menuYOptionAdd - 0.018) + (optionCount / menuYOptionDiv) * menuYModify)}, optionTextSize, true)
		else
			GUI.Text(option3, GUI.optionText, { menuX + menuXOtherOption, ((menuYOptionAdd - 0.018) + (optionCount / menuYOptionDiv) * menuYModify)}, optionTextSize, true)
		end
	elseif(optionCount > currentOption - GUI.maxVisOptions and optionCount <= currentOption) then
		if(bool) then
			GUI.Text(option2, GUI.optionText, { menuX + menuXOtherOption, ((menuYOptionAdd - 0.018) + ((optionCount - (currentOption - GUI.maxVisOptions)) / menuYOptionDiv) * menuYModify)}, optionTextSize, true)
		else
			GUI.Text(option3, GUI.optionText, { menuX + menuXOtherOption, ((menuYOptionAdd - 0.018) + ((optionCount - (currentOption - GUI.maxVisOptions)) / menuYOptionDiv) * menuYModify)}, optionTextSize, true)
		end
	end

	if (optionCount == currentOption and selectPressed) then
		cb(not bool)
		return true
	end

	return false
end

function Menu.CarBool(option, bool, option2, option3, cb)
	Menu.Option(option)
	local amount = 0
	if string.len(option2) == 8 and option2 ~= "~g~OWNED" and option3 ~= "~g~OWNED" then  -- 1
		amount = 0.035
	elseif string.len(option2) == 8 and option2 == "~g~OWNED" and option3 == "~g~OWNED" then  -- 1
		amount = 0.0175
	elseif string.len(option2) == 9 then -- 10
		amount = 0.032
	elseif string.len(option2) == 10 and option2 ~= "~g~Insured" and option3 ~= "~g~Insured" then -- 100
		amount = 0.0265
	elseif string.len(option2) == 10 and option2 == "~g~Insured" and option3 == "~g~Insured" then -- 100
		amount = 0.0165
	elseif string.len(option2) == 11 then -- 1000
		amount = 0.0215
	elseif string.len(option2) == 12 then -- 10000
		amount = 0.0165
	elseif string.len(option2) == 13 then -- 100000
		amount = 0.0115
	elseif string.len(option2) == 14 then -- 1000000
		amount = 0.0065
	elseif string.len(option2) == 15 then -- 10000000
		amount = 0.0015
	elseif string.len(option2) == 4 then
		amount = 0.0265
	end
	if(currentOption <= GUI.maxVisOptions and optionCount <= GUI.maxVisOptions) then
		if(bool) then
			GUI.Text(option2, GUI.optionText, { menuX + menuXOtherOption + amount, ((menuYOptionAdd - 0.018) + (optionCount / menuYOptionDiv) * menuYModify)}, optionTextSize, false)
		else
			GUI.Text(option3, GUI.optionText, { menuX + menuXOtherOption + amount, ((menuYOptionAdd - 0.018) + (optionCount / menuYOptionDiv) * menuYModify)}, optionTextSize, false)
		end
	elseif(optionCount > currentOption - GUI.maxVisOptions and optionCount <= currentOption) then
		if(bool) then
			GUI.Text(option2, GUI.optionText, { menuX + menuXOtherOption + amount, ((menuYOptionAdd - 0.018) + ((optionCount - (currentOption - GUI.maxVisOptions)) / menuYOptionDiv) * menuYModify)}, optionTextSize, false)
		else
			GUI.Text(option3, GUI.optionText, { menuX + menuXOtherOption + amount, ((menuYOptionAdd - 0.018) + ((optionCount - (currentOption - GUI.maxVisOptions)) / menuYOptionDiv) * menuYModify)}, optionTextSize, false)
		end
	end

	if (optionCount == currentOption and selectPressed) then
		cb(not bool)
		return true
	end

	return false
end

function Menu.GunBool(option, bool, option2, option3, cb)
	Menu.Option(option)
	local amount = 0
	if string.len(option2) == 8 then  -- 1
		amount = 0.035
	elseif string.len(option2) == 9 then -- 10
		amount = 0.032
	elseif string.len(option2) == 10 then -- 100
		amount = 0.0265
	elseif string.len(option2) == 11 then -- 1000
		amount = 0.0215
	elseif string.len(option2) == 12 then -- 10000
		amount = 0.0165
	elseif string.len(option2) == 13 then -- 100000
		amount = 0.0115
	elseif string.len(option2) == 14 then -- 1000000
		amount = 0.0065
	elseif string.len(option2) == 15 then -- 10000000
		amount = 0.0015
	end
	if(currentOption <= GUI.maxVisOptions and optionCount <= GUI.maxVisOptions) then
		if(bool) then
			GUI.Text(option2, GUI.optionText, { menuX + menuXOtherOption + amount, ((menuYOptionAdd - 0.018) + (optionCount / menuYOptionDiv) * menuYModify)}, optionTextSize, false)
		else
			GUI.Text(option3, GUI.optionText, { menuX + menuXOtherOption + amount, ((menuYOptionAdd - 0.018) + (optionCount / menuYOptionDiv) * menuYModify)}, optionTextSize, false)
		end
	elseif(optionCount > currentOption - GUI.maxVisOptions and optionCount <= currentOption) then
		if(bool) then
			GUI.Text(option2, GUI.optionText, { menuX + menuXOtherOption + amount, ((menuYOptionAdd - 0.018) + ((optionCount - (currentOption - GUI.maxVisOptions)) / menuYOptionDiv) * menuYModify)}, optionTextSize, false)
		else
			GUI.Text(option3, GUI.optionText, { menuX + menuXOtherOption + amount, ((menuYOptionAdd - 0.018) + ((optionCount - (currentOption - GUI.maxVisOptions)) / menuYOptionDiv) * menuYModify)}, optionTextSize, false)
		end
	end

	if (optionCount == currentOption and selectPressed) then
		cb(not bool)
		return true
	end

	return false
end

function Menu.GarageBool(option, bool, option2, option3, cb)
	Menu.Option(option)
	local amount = 0
	if string.len(option2) == 8 then  -- 1
		amount = 0.035
	elseif string.len(option2) == 9 then -- 10
		amount = 0.032
	elseif string.len(option2) == 10 then -- 100
		amount = 0.0265
	elseif string.len(option2) == 11 then -- 1000
		amount = 0.0215
	elseif string.len(option2) == 12 then -- 10000
		amount = 0.0165
	elseif string.len(option2) == 13 then -- 100000
		amount = 0.0115
	elseif string.len(option2) == 14 then -- 1000000
		amount = 0.0065
	elseif string.len(option2) == 15 then -- 10000000
		amount = 0.0015
	end
	if(currentOption <= GUI.maxVisOptions and optionCount <= GUI.maxVisOptions) then
		if(bool) then
			GUI.Text(option2, GUI.optionText, { menuX + menuXOtherOption + amount, ((menuYOptionAdd - 0.018) + (optionCount / menuYOptionDiv) * menuYModify)}, optionTextSize, false)
		else
			GUI.Text(option3, GUI.optionText, { menuX + menuXOtherOption + amount, ((menuYOptionAdd - 0.018) + (optionCount / menuYOptionDiv) * menuYModify)}, optionTextSize, false)
		end
	elseif(optionCount > currentOption - GUI.maxVisOptions and optionCount <= currentOption) then
		if(bool) then
			GUI.Text(option2, GUI.optionText, { menuX + menuXOtherOption + amount, ((menuYOptionAdd - 0.018) + ((optionCount - (currentOption - GUI.maxVisOptions)) / menuYOptionDiv) * menuYModify)}, optionTextSize, false)
		else
			GUI.Text(option3, GUI.optionText, { menuX + menuXOtherOption + amount, ((menuYOptionAdd - 0.018) + ((optionCount - (currentOption - GUI.maxVisOptions)) / menuYOptionDiv) * menuYModify)}, optionTextSize, false)
		end
	end

	if (optionCount == currentOption and selectPressed) then
		cb(not bool)
		return true
	end

	return false
end

function Menu.TransferBool(option, bool, option2, option3, cb)
	Menu.Option(option)
	if(currentOption <= GUI.maxVisOptions and optionCount <= GUI.maxVisOptions) then
		if(bool) then
			GUI.Text(option2, GUI.optionText, { menuX + menuXOtherOption + 0.01, ((menuYOptionAdd - 0.018) + (optionCount / menuYOptionDiv) * menuYModify)}, optionTextSize, true)
		else
			GUI.Text(option3, GUI.optionText, { menuX + menuXOtherOption + 0.01, ((menuYOptionAdd - 0.018) + (optionCount / menuYOptionDiv) * menuYModify)}, optionTextSize, true)
		end
	elseif(optionCount > currentOption - GUI.maxVisOptions and optionCount <= currentOption) then
		if(bool) then
			GUI.Text(option2, GUI.optionText, { menuX + menuXOtherOption + 0.01, ((menuYOptionAdd - 0.018) + ((optionCount - (currentOption - GUI.maxVisOptions)) / menuYOptionDiv) * menuYModify)}, optionTextSize, true)
		else
			GUI.Text(option3, GUI.optionText, { menuX + menuXOtherOption + 0.01, ((menuYOptionAdd - 0.018) + ((optionCount - (currentOption - GUI.maxVisOptions)) / menuYOptionDiv) * menuYModify)}, optionTextSize, true)
		end
	end

	if (optionCount == currentOption and selectPressed) then
		cb(not bool)
		return true
	end

	return false
end

function Menu.Int(option, int, min, max, cb)
	Menu.Option(option);

	if (optionCount == currentOption) then
		if (leftPressed) then
			if(int > min) then int = int - 1 else int = max end-- : _int = max;
		end
		if (rightPressed) then
			if(int < max) then int = int + 1 else int = min end
		end
	end

	if (currentOption <= GUI.maxVisOptions and optionCount <= GUI.maxVisOptions) then
		GUI.Text(tostring(int), GUI.optionText, { menuX + menuXOtherOption, ((menuYOptionAdd - 0.018) + (optionCount / menuYOptionDiv) * menuYModify)}, optionTextSize, true)
	elseif (optionCount > currentOption - GUI.maxVisOptions and optionCount <= currentOption) then
		GUI.Text(tostring(int), GUI.optionText, { menuX + menuXOtherOption, ((menuYOptionAdd - 0.018) + ((optionCount - (currentOption - GUI.maxVisOptions)) / menuYOptionDiv) * menuYModify)}, optionTextSize, true)
	end

	if (optionCount == currentOption and selectPressed) then cb(position) return true
    elseif (optionCount == currentOption and leftPressed) then cb(position)
    elseif (optionCount == currentOption and rightPressed) then cb(position) end

	return false
end

function Menu.StringArray(option, array, position, cb)

	Menu.Option(option);

	if (optionCount == currentOption) then
		local max = tablelength(array)
		local min = 1
		if (leftPressed) then
			if(position > min) then position = position - 1 else position = max end
		end
		if (rightPressed) then
			if(position < max) then position = position + 1 else position = min end
		end
	end

	if (currentOption <= GUI.maxVisOptions and optionCount <= GUI.maxVisOptions) then
		GUI.Text(array[position], GUI.optionText, { menuX + menuXOtherOption, ((menuYOptionAdd - 0.018) + (optionCount / menuYOptionDiv) * menuYModify)}, optionTextSize, true)
	elseif (optionCount > currentOption - GUI.maxVisOptions and optionCount <= currentOption) then
		GUI.Text(array[position], GUI.optionText, { menuX + menuXOtherOption, ((menuYOptionAdd - 0.018) + ((optionCount - (currentOption - GUI.maxVisOptions)) / menuYOptionDiv) * menuYModify)}, optionTextSize, true)
	end

	if (optionCount == currentOption and selectPressed) then cb(position) return true
    elseif (optionCount == currentOption and leftPressed) then cb(position)
    elseif (optionCount == currentOption and rightPressed) then cb(position) end

	return false
end

function Menu.ScrollBarStringSelect(array, min, cb)

    local currentPosition = min -- Scroller Position
    local maxPosition = tablelength(array)

    Menu.Option2(array[currentPosition+1])
    local bar = {
        x = menuX, -- X Coordinate of both boxes
        y = (menuYOptionAdd + (optionCount / menuYOptionDiv) * menuYModify), -- Y Coordinate of both boxes
        height = optionRectSize[2]/1.5, -- Height of both boxes
        width = {background_box = optionRectSize[1], scroller = optionRectSize[1]/5}, -- Width??
    }

    if (optionCount == currentOption) then
        if (leftPressed) then
            if currentPosition > 0 then currentPosition = currentPosition-1 elseif currentPosition == 0 then currentPosition = maxPosition-1 else currentPosition = min end
        end
        if (rightPressed) then -- right
            if currentPosition < maxPosition-1 then currentPosition = currentPosition+1 elseif currentPosition == maxPosition-1 then currentPosition = 0 else currentPosition = maxPosition-1 end
        end
    end

    if(currentOption <= GUI.maxVisOptions and optionCount <= GUI.maxVisOptions) then
        bar.y = (menuYOptionAdd + (optionCount / menuYOptionDiv) * menuYModify)
        DrawRect(bar.x, bar.y, bar.width.background_box, bar.height, GUI.optionRect[1], GUI.optionRect[2], GUI.optionRect[3], GUI.optionRect[4]) -- Background
        local new_x = (bar.x - ((bar.width.background_box - bar.width.scroller)/2)) + (((bar.width.background_box - bar.width.scroller) / (maxPosition-1)) * currentPosition)
        if new_x < (bar.x - ((bar.width.background_box - bar.width.scroller)/2)) then new_x = (bar.x - ((bar.width.background_box - bar.width.scroller)/2)) end  ---- SCROLLER MIN
        if new_x > (bar.x + ((bar.width.background_box - bar.width.scroller)/2)) then new_x = (bar.x + ((bar.width.background_box - bar.width.scroller)/2)) end  ---- SCROLLER MAX
        DrawRect(new_x,bar.y,bar.width.scroller,bar.height, GUI.scroller[1], GUI.scroller[2]-36, GUI.scroller[3]-72, GUI.scroller[4])    -- Scroller
    elseif (optionCount > currentOption - GUI.maxVisOptions and optionCount <= currentOption) then
        bar.y = (menuYOptionAdd + ((optionCount - (currentOption - GUI.maxVisOptions)) / menuYOptionDiv) * menuYModify)
        DrawRect(bar.x, bar.y, bar.width.background_box, bar.height, GUI.optionRect[1], GUI.optionRect[2], GUI.optionRect[3], GUI.optionRect[4]) -- Background
        local new_x = (bar.x - ((bar.width.background_box - bar.width.scroller)/2)) + (((bar.width.background_box - bar.width.scroller) / (maxPosition-1)) * currentPosition)
        if new_x < (bar.x - ((bar.width.background_box - bar.width.scroller)/2)) then new_x = (bar.x - ((bar.width.background_box - bar.width.scroller)/2)) end  ---- SCROLLER MIN
        if new_x > (bar.x + ((bar.width.background_box - bar.width.scroller)/2)) then new_x = (bar.x + ((bar.width.background_box - bar.width.scroller)/2)) end  ---- SCROLLER MAX
        DrawRect(new_x,bar.y,bar.width.scroller,bar.height, GUI.scroller[1], GUI.scroller[2]-36, GUI.scroller[3]-72, GUI.scroller[4])    -- Scroller
    end

    if (optionCount == currentOption and selectPressed) then cb(currentPosition) return true
    elseif (optionCount == currentOption and leftPressed) then cb(currentPosition) return false
    elseif (optionCount == currentOption and rightPressed) then cb(currentPosition) return false end
    return false
end

function Menu.ScrollBarString(array, min, cb)

    local currentPosition = min -- Scroller Position
    local maxPosition = tablelength(array)

    Menu.Option2(array[currentPosition+1])
    local bar = {
        x = menuX, -- X Coordinate of both boxes
        y = (menuYOptionAdd + (optionCount / menuYOptionDiv) * menuYModify), -- Y Coordinate of both boxes
        height = optionRectSize[2]/1.5, -- Height of both boxes
        width = {background_box = optionRectSize[1], scroller = optionRectSize[1]/5}, -- Width??
    }

    if (optionCount == currentOption) then
        if (leftPressed) then
            if currentPosition > 0 then currentPosition = currentPosition-1 elseif currentPosition == 0 then currentPosition = maxPosition-1 else currentPosition = min end
        end
        if (rightPressed) then -- right
            if currentPosition < maxPosition-1 then currentPosition = currentPosition+1 elseif currentPosition == maxPosition-1 then currentPosition = 0 else currentPosition = maxPosition-1 end
        end
    end

    if(currentOption <= GUI.maxVisOptions and optionCount <= GUI.maxVisOptions) then
        bar.y = (menuYOptionAdd + (optionCount / menuYOptionDiv) * menuYModify)
        DrawRect(bar.x, bar.y, bar.width.background_box, bar.height, GUI.optionRect[1], GUI.optionRect[2], GUI.optionRect[3], GUI.optionRect[4]) -- Background
        local new_x = (bar.x - ((bar.width.background_box - bar.width.scroller)/2)) + (((bar.width.background_box - bar.width.scroller) / (maxPosition-1)) * currentPosition)
        if new_x < (bar.x - ((bar.width.background_box - bar.width.scroller)/2)) then new_x = (bar.x - ((bar.width.background_box - bar.width.scroller)/2)) end  ---- SCROLLER MIN
        if new_x > (bar.x + ((bar.width.background_box - bar.width.scroller)/2)) then new_x = (bar.x + ((bar.width.background_box - bar.width.scroller)/2)) end  ---- SCROLLER MAX
        DrawRect(new_x,bar.y,bar.width.scroller,bar.height, GUI.scroller[1], GUI.scroller[2]-36, GUI.scroller[3]-72, GUI.scroller[4])    -- Scroller
    elseif (optionCount > currentOption - GUI.maxVisOptions and optionCount <= currentOption) then
        bar.y = (menuYOptionAdd + ((optionCount - (currentOption - GUI.maxVisOptions)) / menuYOptionDiv) * menuYModify)
        DrawRect(bar.x, bar.y, bar.width.background_box, bar.height, GUI.optionRect[1], GUI.optionRect[2], GUI.optionRect[3], GUI.optionRect[4]) -- Background
        local new_x = (bar.x - ((bar.width.background_box - bar.width.scroller)/2)) + (((bar.width.background_box - bar.width.scroller) / (maxPosition-1)) * currentPosition)
        if new_x < (bar.x - ((bar.width.background_box - bar.width.scroller)/2)) then new_x = (bar.x - ((bar.width.background_box - bar.width.scroller)/2)) end  ---- SCROLLER MIN
        if new_x > (bar.x + ((bar.width.background_box - bar.width.scroller)/2)) then new_x = (bar.x + ((bar.width.background_box - bar.width.scroller)/2)) end  ---- SCROLLER MAX
        DrawRect(new_x,bar.y,bar.width.scroller,bar.height, GUI.scroller[1], GUI.scroller[2]-36, GUI.scroller[3]-72, GUI.scroller[4])    -- Scroller
    end

    if (optionCount == currentOption and leftPressed) then cb(currentPosition) return true
    elseif (optionCount == currentOption and rightPressed) then cb(currentPosition) return true end
    return false
end

function Menu.ScrollBarInt(option, min, max, cb)
    
    Menu.Option2(option)
    local bar = {
        x = menuX, -- X Coordinate of both boxes
        y = (menuYOptionAdd + (optionCount / menuYOptionDiv) * menuYModify), -- Y Coordinate of both boxes
        height = optionRectSize[2]/1.5, -- Height of both boxes
        width = {background_box = optionRectSize[1], scroller = optionRectSize[1]/5}, -- Width??
    }
    local currentPosition = min -- Scroller Position
    local maxPosition = max

    if (optionCount == currentOption) then
        if (leftPressed) then
            if currentPosition > 0 then currentPosition = currentPosition-1 elseif currentPosition == 0 then currentPosition = maxPosition-1 else currentPosition = min end
        end
        if (rightPressed) then -- right
            if currentPosition < maxPosition-1 then currentPosition = currentPosition+1 elseif currentPosition == maxPosition-1 then currentPosition = 0 else currentPosition = maxPosition-1 end
        end
    end

    if(currentOption <= GUI.maxVisOptions and optionCount <= GUI.maxVisOptions) then
        bar.y = (menuYOptionAdd + (optionCount / menuYOptionDiv) * menuYModify)
        DrawRect(bar.x, bar.y, bar.width.background_box, bar.height, GUI.optionRect[1], GUI.optionRect[2], GUI.optionRect[3], GUI.optionRect[4]) -- Background
        local new_x = (bar.x - ((bar.width.background_box - bar.width.scroller)/2)) + (((bar.width.background_box - bar.width.scroller) / (maxPosition-1)) * currentPosition)
        if new_x < (bar.x - ((bar.width.background_box - bar.width.scroller)/2)) then new_x = (bar.x - ((bar.width.background_box - bar.width.scroller)/2)) end  ---- SCROLLER MIN
        if new_x > (bar.x + ((bar.width.background_box - bar.width.scroller)/2)) then new_x = (bar.x + ((bar.width.background_box - bar.width.scroller)/2)) end  ---- SCROLLER MAX
        DrawRect(new_x,bar.y,bar.width.scroller,bar.height, GUI.scroller[1], GUI.scroller[2]-36, GUI.scroller[3]-72, GUI.scroller[4])    -- Scroller
    elseif (optionCount > currentOption - GUI.maxVisOptions and optionCount <= currentOption) then
        bar.y = (menuYOptionAdd + ((optionCount - (currentOption - GUI.maxVisOptions)) / menuYOptionDiv) * menuYModify)
        DrawRect(bar.x, bar.y, bar.width.background_box, bar.height, GUI.optionRect[1], GUI.optionRect[2], GUI.optionRect[3], GUI.optionRect[4]) -- Background
        local new_x = (bar.x - ((bar.width.background_box - bar.width.scroller)/2)) + (((bar.width.background_box - bar.width.scroller) / (maxPosition-1)) * currentPosition)
        if new_x < (bar.x - ((bar.width.background_box - bar.width.scroller)/2)) then new_x = (bar.x - ((bar.width.background_box - bar.width.scroller)/2)) end  ---- SCROLLER MIN
        if new_x > (bar.x + ((bar.width.background_box - bar.width.scroller)/2)) then new_x = (bar.x + ((bar.width.background_box - bar.width.scroller)/2)) end  ---- SCROLLER MAX
        DrawRect(new_x,bar.y,bar.width.scroller,bar.height, GUI.scroller[1], GUI.scroller[2]-36, GUI.scroller[3]-72, GUI.scroller[4])    -- Scroller
    end

    if (optionCount == currentOption and leftPressed) then cb(currentPosition) return true
    elseif (optionCount == currentOption and rightPressed) then cb(currentPosition) return true end
    return false
end

function Menu.GarageArray(option, array, position, cb)

	Menu.Option(option);
	local amount = 0
	if position <= 9 then  -- 1
		amount = 0.043
	elseif position >= 10 then 
		amount = 0.0425
	end
	if (optionCount == currentOption) then
		local max = tablelength(array)
		local min = 1
		if (leftPressed) then
			if(position > min) then position = position - 1 else position = max end
		end
		if (rightPressed) then
			if(position < max) then position = position + 1 else position = min end
		end
	end

	if (currentOption <= GUI.maxVisOptions and optionCount <= GUI.maxVisOptions) then
		GUI.Text(array[position], GUI.optionText, { menuX + menuXOtherOption + amount, ((menuYOptionAdd - 0.018) + (optionCount / menuYOptionDiv) * menuYModify)}, optionTextSize, true)
	elseif (optionCount > currentOption - GUI.maxVisOptions and optionCount <= currentOption) then
		GUI.Text(array[position], GUI.optionText, { menuX + menuXOtherOption + amount, ((menuYOptionAdd - 0.018) + ((optionCount - (currentOption - GUI.maxVisOptions)) / menuYOptionDiv) * menuYModify)}, optionTextSize, true)
	end

	if (optionCount == currentOption and selectPressed) then cb(position) return true
    elseif (optionCount == currentOption and leftPressed) then cb(position) return true
    elseif (optionCount == currentOption and rightPressed) then cb(position) return true end

	return false
end

function Menu.updateSelection()
	selectPressed = false;
	leftPressed = false;
	rightPressed = false;

	if IsControlJustPressed(1, 173)  then
		if(currentOption < optionCount) then
			currentOption = currentOption + 1
		else
			currentOption = 1
		end
	elseif IsControlJustPressed(1, 172) then
		if(currentOption > 1) then
			currentOption = currentOption - 1
		else
			currentOption = optionCount
		end
	elseif IsControlJustPressed(1, 174) then
		leftPressed = true
	elseif IsControlJustPressed(1, 175) then
		rightPressed = true
	elseif IsControlJustPressed(1, 176)  then
		selectPressed = true
		if isCustomsOpen then
			UpdateCar()
		end
	elseif IsControlJustPressed(1, 177) then
		if (prevMenu == nil) then
			Menu.Switch(nil, "")
			menuOpen = false
			if isCarshopOpen then
				isCarshopOpen = false
				closeCarshop()
			end
			if isCarRentalOpen then
				isCarRentalOpen = false
				closeCarRental()
			end
			if isCustomsOpen then
				isCustomsOpen = false 
				closeCustoms()
			end
			if carshop_menu then
            	carshop_menu = false
            elseif garage_menu then
            	garage_menu = false
            elseif gun_menu then
            	gun_menu = false
            elseif item_menu then
            	item_menu = false
            elseif license_menu then
            	license_menu = false
            elseif customs_menu then
            	customs_menu = false
            elseif carrental_menu then
            	carrental_menu = false
            elseif clothing_menu then
            	clothing_menu = false
            	save()
            elseif tow_menu then
            	tow_menu = false
            end
			currentOption = 1
		end
		if not (prevMenu == nil) then
			if not Menus[prevMenu].previous == nil then
				currentOption = 1
				Menu.Switch(nil, prevMenu)
				Citizen.Trace("IS NOT NIL BUT NIL? "..prevMenu)
			else
				if Menus[prevMenu].optionCount < currentOption then
					currentOption = Menus[prevMenu].optionCount
				end
				Menu.Switch(Menus[prevMenu].previous, prevMenu)
			end
			if isCustomsOpen then
				UpdateCar()
			end
		end
	end
	optionCount = 0
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if not IsEntityDead(GetPlayerPed(-1)) then
	        if player_menu then
	            carshop_menu = false
	            garage_menu = false
	            gun_menu = false
	            item_menu = false
	            license_menu = false
	            customs_menu = false
	            sellgun_menu = false
	            carrental_menu = false
	            clothing_menu = false
	            tow_menu = false
	            Menu.DisplayCurMenu()
	        elseif carshop_menu then
	        	player_menu = false
	            garage_menu = false
	            gun_menu = false
	            item_menu = false
	            license_menu = false
	            customs_menu = false
	            sellgun_menu = false
	            carrental_menu = false
	            clothing_menu = false
	            tow_menu = false
	            Menu.DisplayCurMenu()
	        elseif garage_menu then
	        	player_menu = false
	            carshop_menu = false
	            gun_menu = false
	            item_menu = false
	            license_menu = false
	            customs_menu = false
	            sellgun_menu = false
	            carrental_menu = false
	            clothing_menu = false
	            tow_menu = false
	            Menu.DisplayCurMenu()
	        elseif gun_menu then
	        	player_menu = false
	            carshop_menu = false
	            garage_menu = false
	            item_menu = false
	            license_menu = false
	            customs_menu = false
	            sellgun_menu = false
	            carrental_menu = false
	            clothing_menu = false
	            tow_menu = false
	            Menu.DisplayCurMenu()
	        elseif item_menu then
	        	player_menu = false
	            carshop_menu = false
	            garage_menu = false
	            gun_menu = false
	            license_menu = false
	            customs_menu = false
	            sellgun_menu = false
	            carrental_menu = false
	            clothing_menu = false
	            tow_menu = false
	            Menu.DisplayCurMenu()
	        elseif license_menu then
	        	player_menu = false
	            carshop_menu = false
	            garage_menu = false
	            gun_menu = false
	            item_menu = false
	            customs_menu = false
	            sellgun_menu = false
	            carrental_menu = false
	            clothing_menu = false
	            tow_menu = false
	            Menu.DisplayCurMenu()
	        elseif customs_menu then
	        	player_menu = false
	            carshop_menu = false
	            garage_menu = false
	            gun_menu = false
	            item_menu = false
	            license_menu = false
	            sellgun_menu = false
	            carrental_menu = false
	            clothing_menu = false
	            tow_menu = false
	            Menu.DisplayCurMenu()
		    elseif sellgun_menu then
	        	player_menu = false
	            carshop_menu = false
	            garage_menu = false
	            gun_menu = false
	            item_menu = false
	            license_menu = false
	            customs_menu = false
	            carrental_menu = false
	            clothing_menu = false
	            tow_menu = false
	            Menu.DisplayCurMenu()
	        elseif carrental_menu then
	        	player_menu = false
	            carshop_menu = false
	            garage_menu = false
	            gun_menu = false
	            item_menu = false
	            license_menu = false
	            customs_menu = false
	            sellgun_menu = false
	            clothing_menu = false
	            tow_menu = false
	            Menu.DisplayCurMenu()
	        elseif clothing_menu then
	        	player_menu = false
	            carshop_menu = false
	            garage_menu = false
	            gun_menu = false
	            item_menu = false
	            license_menu = false
	            customs_menu = false
	            sellgun_menu = false
	            carrental_menu = false
	            tow_menu = false
	            Menu.DisplayCurMenu()
	        elseif tow_menu then
	        	player_menu = false
	            carshop_menu = false
	            garage_menu = false
	            gun_menu = false
	            item_menu = false
	            license_menu = false
	            customs_menu = false
	            sellgun_menu = false
	            clothing_menu = false
	            carrental_menu = false
	            Menu.DisplayCurMenu()
	        end
	    else
	        player_menu = false
	        carshop_menu = false
	        garage_menu = false
	        gun_menu = false
	        item_menu = false
	        license_menu = false
	        customs_menu = false
	        sellgun_menu = false
	        carrental_menu = false
	        clothing_menu = false
	        tow_menu = false    	
	    end
	end
end)

