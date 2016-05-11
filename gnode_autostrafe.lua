/*
The MIT License (MIT)

Copyright (c) 2016 Desutin sumisu

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

local gnode_strafe = { }
gnode_strafe.MetaPlayer = FindMetaTable( "Player") 
gnode_strafe.oldKeyDown = gnode_strafe.MetaPlayer['KeyDown']
gnode_strafe.On = true
gnode_strafe.SOn = true
gnode_strafe.Hooks = { hook = { }, gnode = { } }
gnode_strafe.jump = false
function gnode_strafe.AddHook(bhop, gnode, func)
	table.insert( gnode_strafe.Hooks.hook, bhop )
	table.insert( gnode_strafe.Hooks.gnode, gnode )
	hook.Add( bhop, gnode, func )
end
gnode_strafe.MetaPlayer['KeyDown'] = function( self, key )
	if self ~= LocalPlayer() then return end
	
	if (key == IN_MOVELEFT) and gnode_strafe.left then
		return true
	elseif (key == IN_MOVERIGHT) and gnode_strafe.right then
		return true
	elseif (key == IN_JUMP) and gnode_strafe.jump then
		return true
	else
		return gnode_strafe.oldKeyDown( self, key )
	end
end

local oldEyePos = LocalPlayer():EyeAngles()
function gnode_strafe.CreateMove( cmd )
	gnode_strafe.jump = false
	if (cmd:KeyDown( IN_JUMP )) then
	
		if (not gnode_strafe.jump) then
			if (gnode_strafe.On and not LocalPlayer():OnGround()) then
				cmd:RemoveKey( IN_JUMP )
			end
		else
			gnode_strafe.jump = false
		end

		if(gnode_strafe.SOn ) then--auto strafer
			local traceRes = LocalPlayer():EyeAngles()
								   
			if( traceRes.y > oldEyePos.y ) then
				oldEyePos = traceRes
				cmd:SetSideMove( -1000000 )
				gnode_strafe.left = true
				gnode_strafe.right = false 
			elseif( oldEyePos.y > traceRes.y )  then
				oldEyePos = traceRes
				cmd:SetSideMove( 1000000 )
				gnode_strafe.right = true
				gnode_strafe.left = false
			end
		end
	elseif (not gnode_strafe.jump) then
		gnode_strafe.jump = true
	end		 
end
		   
gnode_strafe.AddHook( "CreateMove", tostring(math.random(0, 133712837)), gnode_strafe.CreateMove )

concommand.Add( "gnode_strafe", function ()
	gnode_strafe.On = not gnode_strafe.On	
	local state = "off"
	if gnode_strafe.On then state = "on" end
	chat.AddText(Color(204, 40, 40, 255), "[", Color(23, 196, 134, 255), "Bhop", Color(204, 40, 40, 255), "]" .. " ", Color(33, 167, 196, 255), state)
end)
	
concommand.Add( "gnode_strafe_strafe",  function ()
	gnode_strafe.SOn = not gnode_strafe.SOn
	local state = "off"
	if gnode_strafe.SOn then state = "on" end
	chat.AddText(Color(204, 40, 40, 255), "[", Color(23, 196, 134, 255), "strafe", Color(204, 40, 40, 255), "]" .. " ", Color(33, 167, 196, 255), state)
end)

concommand.Add("gnode_strafe_unload", function()
	for i = 1, #gnode_strafe.Hooks.hook do
		hook.Remove( gnode_strafe.Hooks.hook[i], gnode_strafe.Hooks.gnode[i] )
		print( "Unhooked "..gnode_strafe.Hooks.hook[i].." using gnode "..gnode_strafe.Hooks.gnode[i] )
	end
	
	concommand.Remove("gnode_strafe_strafe")
	concommand.Remove("gnode_strafe")
	concommand.Remove( "gnode_strafe_unload" )
	gnode_strafe = nil
	
	chat.AddText(Color(204, 40, 40, 255), "[", Color(23, 196, 134, 255), "Autostrafe", Color(204, 40, 40, 255), "]" .. " ", Color(33, 167, 196, 255), "has been unloaded!")
end)
		   
chat.AddText(Color(204, 40, 40, 255), "[", Color(23, 196, 134, 255), "Autostrafe", Color(204, 40, 40, 255), "]" .. " ", Color(33, 167, 196, 255), "initialized!")
