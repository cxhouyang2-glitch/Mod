print("sortThink_333~~~~~~~~~~~~~~~~~")
local sortThink_333 = GameMain:GetMod("sortThink_333")

function sortThink_333:OnInit()
	local tbEventMod = GameMain:GetMod("_Event")
	tbEventMod:RegisterEvent(g_emEvent.WindowEvent, self.OnWindowEvent, self)
end

function sortThink_333:OnWindowEvent(pThing, pObjs)
	local pWnd = pObjs[0]
	local iArg = pObjs[1]
	if (pWnd == CS.Wnd_A2HCreateAgg.Instance and iArg == 1) then
		local listAllNpc = Map.Things:GetPlayerActiveNpcs(g_emNpcRaceType.Animal)
		for _, Npc in pairs(listAllNpc) do
			if(Npc.A2H ~= nil) then
				--思绪碎片
				if(Npc.A2H.thinkFrags ~= nil) then
					Npc.A2H.thinkFrags = sortThink_333:Sort(Npc.A2H.thinkFrags)
				end
				--记忆
				if(Npc.A2H.thinkFragCaches ~= nil) then
					Npc.A2H.thinkFragCaches = sortThink_333:Sort(Npc.A2H.thinkFragCaches)
				end
			end
		end
	end
end


function  sortThink_333:Sort(list)
    local len = list.Count
    for i = 1, len do
        local flag = ture
        for j = 1 , len-i do
            local xSize =  sortThink_333.GetThinkList():IndexOf(tostring(list[j-1].frags[0]))
            local ySize =  sortThink_333.GetThinkList():IndexOf(tostring(list[j].frags[0]))
            if(xSize > ySize ) then
                local c = list[j-1]
                list[j-1] = list[j]
                list[j] = c
                flag = false
            end
        end
        if(flag) then
            break
        end
    end
    return list
end


function sortThink_333:GetThinkList()
    if(sortThink_333.thinkList == null) then
        local hem =CS.XiaWorld.HumanoidEvolutionMgr.Instance.Fragments;
        local initThink = CS.System.Collections.Generic.List(CS.System.String)()
        for localKey,localValue in pairs(hem.ForEachKey) do 
            initThink:Add(tostring(localValue.Name))
        end
        sortThink_333.thinkList = initThink
        print("sortThink_333初始化成功")
    end
    return sortThink_333.thinkList
end