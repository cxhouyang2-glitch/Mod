print("calamitiesFast~~~~~~~~~~~~~~~~~")
local calamitiesFast = GameMain:GetMod("calamitiesFast")

function calamitiesFast:OnInit()
	local tbEventMod = GameMain:GetMod("_Event")
	tbEventMod:RegisterEvent(g_emEvent.JobEvent, self.OnJobEvent, self)
    tbEventMod:RegisterEvent(g_emEvent.NpcChangeHorse, self.OnJumpFlyFinish, self)
end

function calamitiesFast:OnJobEvent(pThing, pObjs)
    --ToilBase toil, g_emJobToilState state

    local function OnEventJobFinish(toil, state)
        print(1111111111111111111)
        print(toil)
        print(state)
    end


    --pThing.ViewRaceType == g_emNpcRaceType.Wisdom
    if(pThing ~= nil and pThing.ID == 16539)then
        if(pObjs ~= nil)then
            local pj = pObjs[0];
            print("工作")
            print(pj)
            print(pj:GetCurToil())
            if( pj ~= nil and pj:GetType().FullName == "XiaWorld.JobBrokenNeck" )then
                if(pj:GetCurToil() ~= nil and pj:GetCurToil():GetType().FullName == "XiaWorld.ToilBrokenNeck"  )then
                    pj:GetCurToil().waitcloud = 1.0;
                end
                if( pj:GetCurToil():GetType().FullName == "XiaWorld.ToilGoto" )then
                    local ct = pj:GetCurToil();
                    ct.FinishEvent = CS.System.Delegate.Combine(ct.FinishEvent ,self.OnJumpFlyFinish,self);
                    --ct.FinishEvent = OnEventJobFinish
                    print(ct.FinishEvent)
                    ct.FinishEvent(nil,CS.XiaWorld.g_emJobToilState.Interrupt)
                end
                pj.EventJobFinish = CS.System.Delegate.Combine(pj.EventJobFinish ,self.OnJumpFlyFinish,self);
            end
        end
    end 
end

function calamitiesFast:OnJumpFlyFinish(pThing, pObjs)
    print("22222222222222222")
    print(pThing)
    print(pObjs)
    if(pObjs ~= nil )then
        for i = 0, pObjs.Length-1 do
            print(pObjs[i])
        end
    end
end


