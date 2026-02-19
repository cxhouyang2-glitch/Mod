BPRefresh = GameMain:GetMod("BPRefresh");
----Setting(设置)弃用!------
--BPRefresh.BPCount = 15;---修改该值将会影响每次淬体后可供选择的词条数。
-----------------------

function BPRefresh:OnSetHotKey()  --更新了热键方法
	local HotKey = 
	{
		{ID = "BPRefresh" , Name = "体修淬体助手" , Type = "Mod", InitialKey1 = "Home",InitialKey2 = "LeftShift+A"}--,
--		{ID = "ModifierMains" , Name = "MOD版修改器-备用" , Type = "Mod", InitialKey1 = "LeftShift+F4"}
	};
	print("体修淬体助手:主快捷键注册成功！");
	return HotKey;
end
function BPRefresh:OnHotKey(ID,state)
	local logicBool=false;
	logicBool=(ID == "BPRefresh" and state == "down");
	if logicBool then
		if BPRefresh.IsOnShow then
			BPRefresh_MainWidow:Hide();
		else
			BPRefresh_MainWidow:Show();
		end
	end
end