tracks = {}
tracksamount = 0
streams = {}
streamsamount = 0
channels = {}
channelsamount = 0
selectedchannel = 1
radioStatus = 0
currenttrack = 1
player = GetPlayerId()
radiovolume = 1.0
muted = false

function PlayAudio()
    if channels[selectedchannel][1] == "stream" then
        local file = tostring(channels[selectedchannel][2])
        radio = CreateSound(file)
        SetVolume()

    elseif channels[selectedchannel][1] == "tracks" then
        local duration = tonumber(string.match(channels[selectedchannel][2][currenttrack], "(%d+)%-")) * 1000
        local file = tostring("OnsetFM/tracks/"..channels[selectedchannel][2][currenttrack])
        radio = CreateSound(file)
        SetVolume()

        Delay(duration,function()
            if radioStatus == 1 and channels[selectedchannel][1] == "tracks" then
                if currenttrack == tracksamount then
                    currenttrack = 1
                    PlayAudio()
                else
                    currenttrack = currenttrack + 1
                    PlayAudio()
                end
            end
        end)
        
    end
end

function AddChatNotification(text)
    if ShowChatNotifications then
        AddPlayerChat(text)
    end
end

function SetVolume()
    if muted then
        SetSoundVolume(radio, 0.0)
    else
        SetSoundVolume(radio, radiovolume)
    end
end

AddEvent("OnKeyPress", function (key)
    if IsPlayerInVehicle() then
        muted = false

        if key == OnOff then
            if radioStatus == 1 then
                AddChatNotification("Radio is turning off...")
                DestroySound(radio)
                radioStatus = 0
            else
                AddChatNotification("Radio is turning on, tuned to channel #"..selectedchannel..".")
                radioStatus = 1
                PlayAudio()
            end
        elseif radioStatus == 1 then
            if key == NextChannel then
                if selectedchannel == channelsamount then
                    DestroySound(radio)
                    selectedchannel = 1
                    AddChatNotification("Radio is switching to channel #"..selectedchannel..".")
                    PlayAudio()
                else
                    DestroySound(radio)
                    selectedchannel = selectedchannel + 1
                    AddChatNotification("Radio is switching to channel #"..selectedchannel..".")
                    PlayAudio()
                end
            elseif key == PreviousChannel then
                if selectedchannel == 1 then
                    DestroySound(radio)
                    selectedchannel = channelsamount
                    AddChatNotification("Radio is switching to channel #"..selectedchannel..".")
                    PlayAudio()
                else
                    DestroySound(radio)
                    selectedchannel = selectedchannel - 1
                    AddChatNotification("Radio is switching to channel #"..selectedchannel..".")
                    PlayAudio()
                end
            elseif key == RaiseVolume then
                if radiovolume ~= 2.0 then
                    radiovolume = radiovolume + 0.1
                    SetSoundVolume(radio, radiovolume)
                    AddChatNotification("Raising radio volume to "..radiovolume..".")
                end
            elseif key == LowerVolume then
                if radiovolume ~= 0.0 then
                    radiovolume = radiovolume - 0.1
                    SetSoundVolume(radio, radiovolume)
                    AddChatNotification("Lowering radio volume to "..radiovolume..".")
                end
            end 
        end
    end
end)

AddEvent("OnPlayerLeaveVehicle", function()
    if radio ~= nil and MuteOutOfCar then
        SetSoundVolume(radio, 0.0)
        muted = true
    end
end)

AddEvent("OnPlayerEnterVehicle", function(playerid, vehicle, seat)
    if radio ~= nil and MuteOutOfCar then
        SetSoundVolume(radio, radiovolume)
        mute = false
    end
end)

AddRemoteEvent("ExchangingAudio", function(arg1, arg2, arg3, arg4)
    tracks = arg1
    tracksamount = arg2
    streams = arg3
    streamsamount = arg4
    
    if streamsamount > 0 then
        for stream = 1, #streams do
            channelsamount = channelsamount + 1
            table.insert( channels, {"stream", streams[stream]})
        end
    end
    
    if tracksamount > 0 then
        channelsamount = channelsamount + 1
        table.insert( channels, {"tracks", tracks})
    end
end)