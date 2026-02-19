local GreatPainter = GameMain:GetMod("GreatPainter");--先注册一个新的MOD模块
local GlobleDataMgr = CS.XiaWorld.GlobleDataMgr.Instance;

function GreatPainter:OnEnter()

	local data = PracticeMgr.m_mapSpellDefs;
	local count = 0;
	local realvalue = 100/100;
	local newvalue = realvalue/0.95;
	for k, v in pairs(data) do
		local s , cv = GlobleDataMgr.FuSaves:TryGetValue(k)
		if s and cv > newvalue then
			GlobleDataMgr.FuSaves:Remove(k)
		end
		GlobleDataMgr:SaveFuValue(k,newvalue);	
		local spelldef = PracticeMgr:GetSpellDef(k)
		local spellname = spelldef.DisplayName;
		print(spellname , " 快速画符品质已修改为：" , newvalue);
		count = count + 1;
	end
	
	CS.XiaWorld.GameDefine.SOULCRYSTALYOU_BASE = 1;
	print("幽粹成功率设置为: 100% ");

	CS.XiaWorld.GameDefine.SOULCRYSTALLING_BASE = 1;
	print("灵粹成功率设置为: 100% ");

end


