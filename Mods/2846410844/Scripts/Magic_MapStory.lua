--大衍神算
local tbTable = GameMain:GetMod("MagicHelper");
local tbMagic = tbTable:GetMagic("Magic_MapStory");



function tbMagic:Init()
end

function tbMagic:TargetCheck(k, t)	
	return true;
end

function tbMagic:MagicEnter(IDs, IsThing)
end

function tbMagic:MagicStep(dt, duration)--返回值  0继续 1成功并结束 -1失败并结束		
	self:SetProgress(duration/self.magic.Param1);
	if duration >= self.magic.Param1 then	
		return 1;	
	end
	return 0;
end

function tbMagic:MagicLeave(success)
	if success == true then
		local LuaHelper = self.bind.LuaHelper;
		local daohang = LuaHelper:GetDaoHang();
		local rate = daohang / 4000 * (LuaHelper:GetIntelligence() + LuaHelper:GetLuck());
		    gl = math.random(10)
        			
		if gl/10 >= 0.5 then
			SECRET = {70,76}
		else 
			SECRET = {58,60}
		end
		--world:ShowStoryBox(XT(gl/10), XT(gl/10));
		if world:CheckRate(rate) then					
			world:ShowStoryBox(XT("大衍神算施展成功，获得一条秘闻。"), XT("大衍神算"));
			GameEventMgr:TriggerEvent(world:RandomInt(SECRET[1],SECRET[2]))	
		else
			world:ShowStoryBox(XT("大衍神算施展失败。"), XT("大衍神算"));
		end
	end
end

function tbMagic:OnGetSaveData()
	return nil;	
end

function tbMagic:OnLoadData(tbData,IDs, IsThing)	

end
