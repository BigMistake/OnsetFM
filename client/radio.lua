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

function PlayAudio()
    carplaying = GetPlayerVehicle(player)
    local x, y, z = GetVehicleLocation(carplaying)
    AddPlayerChat("Car: "..carplaying..". X, Y, Z: "..x.." "..y.." "..z..".")
    

    if channels[selectedchannel][1] == "stream" then
        local file = tostring(channels[selectedchannel][2])
        radio = CreateSound3D(file, x, y, z, RadioRadius)
        SetVolume()

    elseif channels[selectedchannel][1] == "tracks" then
        local duration = tonumber(string.match(channels[selectedchannel][2][currenttrack], "(%d+)%-")) * 1000
        local file = tostring("OnsetFM/tracks/"..channels[selectedchannel][2][currenttrack])
        radio = CreateSound3D(file, x, y, z, RadioRadius)
        SetVolume()
    end
end

function AddChatNotification(text)
    if ShowChatNotifications then
        AddPlayerChat(text)
    end
end

function SetVolume()
    SetSoundVolume(radio, radiovolume)
end

function IncreaseTrack()
    if currenttrack == tracksamount then
        DestroySound(radio)
        currenttrack = 1
        PlayAudio()
    else
        DestroySound(radio)
        currenttrack = currenttrack + 1
        PlayAudio()
    end
end

function DecreaseTrack()
    if currenttrack == 1 then
        DestroySound(radio)
        currenttrack = tracksamount
        PlayAudio()
    else
        DestroySound(radio)
        currenttrack = currenttrack - 1
        PlayAudio()
    end
end

AddEvent("OnSoundFinished", function(sound)
    if radio ~= nil and sound == radio then
        IncreaseTrack()
    end
end)

AddEvent("OnKeyPress", function (key)
    if IsPlayerInVehicle() then
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
                    SetVolume()
                    AddChatNotification("Raising radio volume to "..radiovolume..".")
                end
            elseif key == LowerVolume then
                if radiovolume ~= 0.0 then
                    radiovolume = radiovolume - 0.1
                    SetVolume()
                    AddChatNotification("Lowering radio volume to "..radiovolume..".")
                end
            elseif key == NextTrack and EnableTrackControl then
                IncreaseTrack()
            elseif key == PreviousTrack and EnableTrackControl then
                DecreaseTrack()
            end 
        end
    end
end)

AddEvent("OnGameTick", function()
    if radio ~= nil then
        local x, y, z = GetVehicleLocation(carplaying)
        SetSound3DLocation(radio, x, y, z)
    end
end)

AddEvent("OnPackageStop", function()
    if radio ~= nil then
        DestroySound(radio)
    end

    tracks = {}
    tracksamount = 0
    streams = {}
    streamsamount = 0
    channels = {}
    channelsamount = 0
    selectedchannel = 1
    radioStatus = 0
    currenttrack = 1
    radiovolume = 1.0
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