local StarterGui = game:GetService('StarterGui')



-- They are RobloxScript Protected L
pcall(function()
	StarterGui:RegisterSetCore('ClickAtPosition', function(args)
		if not args then
			warn('Missing Args!')
			
			return
		end
		
		local Position = nil
		
		
		if not (type(args) == 'table') then
			warn('Args must be a table!')
			
			return
		end
		
		
		
		pcall(function()
			if args.Position and typeof(args.Position) == 'Vector2' then
				Position = args.Position
			end
			
			
			
			local ClickTypes = {
				[0] = 'Left',
				[1] = 'Right',
				[2] = 'Middle'
			}
			
			
			local clickType = 0
			
			if args.type and type(args.type) == 'string' then
				for i, v in pairs(ClickTypes) do
					if args.type == v then
						clickType = i
					end
				end
			end
			
			
			
			local VirtualInputManager = game:GetService('VirtualInputManager')
			local Platform = game:GetService('UserInputService'):GetPlatform()



			if (Platform == Enum.Platform.Windows or Platform == Enum.Platform.UWP) and game:GetService('UserInputService').MouseEnabled == true then
				VirtualInputManager:SendMouseButtonEvent(
					Position.X, -- The X Position
					Position.Y, -- The Y Position
					clickType,
					true,
					nil,
					0
				)
				
				VirtualInputManager:SendMouseButtonEvent(
					Position.X, -- The X Position
					Position.Y, -- The Y Position
					clickType,
					false,
					nil,
					0
				)
			end
		end)
	end)
	
	
	
	local CommandConnections = {}
	
	
	StarterGui:RegisterSetCore('Chat.AddChatCommand', function(inputTable)
		if not inputTable or not (typeof(inputTable) == 'table') then
			warn('Missing Input Table')
		end
		
		
		if not inputTable.Command then
			warn('Missing Command')
		end
		
		
		if not inputTable.Function then
			warn('Missing Command Function/Callback')

            return
		end
		
		
		local CommandInputTypes = {
			[1] = 'Normal'
		}
		
		
		local CommandType = ''
		
		
		if inputTable.CommandInputType and typeof(inputTable.CommandInputType) == 'string' then
			for i, v in pairs(CommandInputTypes) do
				if inputTable.CommandInputType == v then
					CommandType = inputTable.CommandInputType
					
					break
				end
			end
			
			
			if CommandType == '' then
				warn('Unexspected error: Command Type is Invalid: ' .. tostring(inputTable.CommandInputType) .. ' is not a valid Command Type. Valid Types: ' .. tostring(table.concat(CommandInputTypes, ', ')))
			end
		end
		
		
		
		pcall(function()
			local TextChatService = game:GetService('TextChatService')
			local Players = game:GetService('Players')
			
			
			
			if CommandType == '' then
				CommandType = 'Normal'
			end
			
			
			
			if CommandConnections[inputTable.Command] then
				warn('Command: ' .. tostring(inputTable.Command) .. ' is already defined!')

				return
			end
			
			
			if CommandType == 'Normal' then
				if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then	
					local TextChatCommand = Instance.new('TextChatCommand')
					TextChatCommand.Name = 'TPJSUAASJU2972348FUDHJP23'
					TextChatCommand.PrimaryAlias = inputTable.Command
					TextChatCommand.Triggered:Connect(function(e, r)
						print(e, e.UserId, Players:GetPlayerByUserId(e.UserId) == Players.LocalPlayer)
						if r and (e and Players:GetPlayerByUserId(e.UserId) == Players.LocalPlayer) then
							if r:split(' ')[1] == inputTable.Command then
								local retriveTable = {}
								
								
								for i, v in pairs(r:split(' ')) do
									if i == 1 then
										continue
									end
									
									retriveTable[i - 1] = v
								end;
								
								
								(inputTable.Function)(retriveTable)
							end
						end
					end)
					TextChatCommand.Parent = TextChatService:WaitForChild('TextChatCommands')
				elseif TextChatService.ChatVersion == Enum.ChatVersion.LegacyChatService then
					CommandConnections[inputTable.Command] = Players.LocalPlayer.Chatted:Connect(function(e, r)
						if e then
							if e:split(' ')[1] == inputTable.Command then
								local retriveTable = {}
								
								
								for i, v in pairs(e:split(' ')) do
									if i == 1 then
										continue
									end
									
									retriveTable[i - 1] = v
								end;
								
								
								(inputTable.Function)(retriveTable)
							end
						end
					end)
				end
			end
		end)
	end)
	
	StarterGui:RegisterSetCore('Chat.RemoveChatCommand', function(command)
		if CommandConnections[command] then
			CommandConnections[command]:Disconnect()
		end
	end)


	StarterGui:RegisterSetCore('SendChatSystemMessageV2', function(t)
		local TextChatService = game:GetService('TextChatService')


		if TextChatService.ChatVersion == Enum.ChatVersion.LegacyChatService then
			StarterGui:SetCore('ChatMakeSystemMessage', {
				Text = t.Text,
				Color = t.Color
			})
		elseif TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
			TextChatService.ChatInputBarConfiguration.TargetTextChannel:DisplaySystemMessage("<font color='#" .. tostring(t.Color:ToHex()) .. "'>" .. (t.Text) .. "</font>")
		end
	end)
end)



local TextChatService = game:GetService('TextChatService')
local Players = game:GetService('Players')



StarterGui:SetCore('Chat.RemoveChatCommand', '/Report')

StarterGui:SetCore('Chat.AddChatCommand', {
    Command = '/TP',
    Function = function(t)
        local playerName = t and t[1] or ''

		for i, v in pairs(t) do
			print(i, v)
		end


        if playerName == '' then
            -- TextChatService.ChatInputBarConfiguration.TargetTextChannel:DisplaySystemMessage('[System]: [Teleport Failed]: Player was not defined.')

			StarterGui:SetCore('SendChatSystemMessageV2', {
				Text = '[System]: [Teleport Failed]: Player was not defined.',
				Color = Color3.new(1, 0, 0)
			})

            return
        end


        if not Players:FindFirstChild(playerName) then
			-- TextChatService.ChatInputBarConfiguration.TargetTextChannel:DisplaySystemMessage('[System]: [Teleport Failed]: Player: ' .. tostring(playerName) .. ' does not exsist in this game.')

			StarterGui:SetCore('SendChatSystemMessageV2', {
				Text = ('[System]: [Teleport Failed]: Player: ' .. tostring(playerName) .. ' does not exsist in this game.'),
				Color = Color3.new(1, 0, 0)
			})


            return
        end



        Players.LocalPlayer.Character:WaitForChild('HumanoidRootPart', 10).CFrame = Players:FindFirstChild(playerName).Character:WaitForChild('HumanoidRootPart').CFrame

		StarterGui:SetCore('SendChatSystemMessageV2', {
			Text = ('[System]: Successfully Teleported to: ' .. tostring(playerName)),
			Color = Color3.fromRGB(0, 255, 30)
		})
    end
})


StarterGui:SetCore('Chat.AddChatCommand', {
	Command = '/WalkSpeed',
	Function = function(t)
		if not t then
			StarterGui:SetCore('SendChatSystemMessageV2', {
				Text = ('[System]: WalkSpeed needs its arg to be a number!'),
				Color = Color3.new(1, 0, 0)
			})

			return
		end


		Players.LocalPlayer.Character:WaitForChild('Humanoid', 10).WalkSpeed = tonumber(t[1])

		StarterGui:SetCore('SendChatSystemMessageV2', {
			Text = ('[System]: Successfully Set WalkSpeed to: ' .. tostring(t[1])),
			Color = Color3.fromRGB(0, 255, 30)
		})
	end
})



StarterGui:SetCore('SendChatSystemMessageV2', {
	Text = ('[System]: Commands has Successfully Loaded!'),
	Color = Color3.fromRGB(0, 255, 30)
})