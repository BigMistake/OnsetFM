tracks = {}
tracksamount = 0
streams = {}
streamsamount = 0

function GetTracks()
    local directory = "packages\\OnsetFM\\tracks"
    local i, t, popen = 0, {}, io.popen
    local pfile = popen('dir "'..directory..'"')
    for filename in pfile:lines() do
        i = i + 1
        t[i] = filename
        if string.find( t[i],".mp3") then
            trackname = string.match(t[i], "(%d+%-.+mp3)")
            tracksamount = tracksamount + 1
            table.insert(tracks,trackname)
        elseif string.find( t[i],".wav") then
            trackname = string.match(t[i], "(%d+%-.+wav)")
            tracksamount = tracksamount + 1
            table.insert(tracks,trackname)
        elseif string.find( t[i],".ogg") then
            trackname = string.match(t[i], "(%d+%-.+ogg)")
            tracksamount = tracksamount + 1
            table.insert(tracks,trackname)
        elseif string.find( t[i],".oga") then
            trackname = string.match(t[i], "(%d+%-.+oga)")
            tracksamount = tracksamount + 1
            table.insert(tracks,trackname)
        elseif string.find( t[i],".flac") then
            trackname = string.match(t[i], "(%d+%-.+flac)")
            tracksamount = tracksamount + 1
            table.insert(tracks,trackname)
        end
    end
    pfile:close()
    return
end

function GetStreams()
    local file = "packages\\OnsetRadio\\tracks\\streams.txt"
    lines = {}
    for line in io.lines(file) do 
      lines[#lines + 1] = line
      streamsamount = streamsamount + 1
      table.insert(streams, line)
    end
    return lines
end

GetTracks()
GetStreams()

AddEvent("OnPlayerSpawn", function(playerid)
    CallRemoteEvent(playerid, "ExchangingAudio", tracks, tracksamount, streams, streamsamount)
end)