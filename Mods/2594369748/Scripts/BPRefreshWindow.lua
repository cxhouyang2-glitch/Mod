BPRefresh_MainWidow = CS.Wnd_Simple.CreateWindow("BPRefresh_MainWidow");
local MyName="ModModifiers_BPRefresh";
function BPRefresh_MainWidow:OnShown()
	BPRefresh_MainWidow.IsOnShow=true;
end
function BPRefresh_MainWidow:OnHide()
	BPRefresh_MainWidow.IsOnShow=false;
end
function BPRefresh_MainWidow:OnInit()
	self.sx = 480;
	self.sy = 300;
	self:SetTitle("体修词条助手");
	self:SetSize(self.sx,self.sy);
	self.ShowLable = BPRefresh_MainWidow:AddLable2(self,"ShowLable","此处为提示.",self.sx/10*1,self.sy/10*1.5,self.sx/10*8,35);
	self.ShowLable:SetSize(self.sx/10*8,self.sy/10*1.2);
	
	local ky = 3;
	ky = ky + 0.4;
	BPRefresh_MainWidow:AddLable2(self,"lable61","可选词条数:",self.sx/10*1,self.sy/10*ky,200,35);
	ky = ky + 0.1;
	self.input61 = BPRefresh_MainWidow:AddInput(self,"input61","10",self.sx/10*3,self.sy/10*ky);
	self.input61:SetSize(self.sx/10*1.8, 25, false);
	BPRefresh_MainWidow:AddButton(self,"bnt6_1","修改",self.sx/10*5,self.sy/10*ky,nil,nil,"体修进行淬体时，每次可供选择的词条数量。（注意：实际数目可能会因基础词条重复而低于该值。）"):SetSize(self.sx/10*1.0, 25, false);
	self.CheckBox61 = self:AddCheckBox("BPBox61","开局自动修改",self.sx/10*7,self.sy/10*ky);
	self.CheckBox61.selected = BPRefresh_MainWidow.CheckValue(101);
	ky = ky + 2;
	BPRefresh_MainWidow:AddLable2(self,"lable62","刷新按钮:",self.sx/10*1,self.sy/10*ky,100,35);
	ky = ky + 0.1;
	self.bnt6_2=BPRefresh_MainWidow:AddButton(self,"bnt6_2","已关闭",self.sx/10*4,self.sy/10*ky,nil,nil,"体修进行淬体时，选择词条界面是否添加刷新按钮。（注意：需在游戏中进入一次词条选择窗口才能成功开启该功能!也可在那个界面直接快捷键打开该窗口来按该按钮。）");
	self.bnt6_2:SetSize(self.sx/10*2, 25, false);
	self.bnt6_2Bool=false;
	self.window:Center();
end
function BPRefresh_MainWidow:OnShown()
	if BPRefresh_MainWidow.HadInt == true then
		return;
	end
	--function BPRefresh_MainWidow.LoadDll()
	local dllType=1;
	local Me = CS.ModsMgr.Instance:FindMod(MyName, nil, true);
	local Path=Me.Path;
	local MePath,MeDll,RAsm;
	if Me==nil or Me=="" then
		if Path==nil then
			dllType=0;
		else
			MePath=Path;
		end
	else
		MePath = Me.Path;
	end
	if dllType<=0 or MePath==nil or MePath=="" then
		dllType=-1;
	else
		MeDll = MePath.."//Scripts//QFLib.dll";
	end
	if dllType<=0 or MeDll==nil or MeDll=="" then
		dllType=-2;
	else
		RAsm = CS.System.Reflection.Assembly.LoadFrom(MeDll);
	end
	if dllType<=0 or RAsm==nil or RAsm=="" then
		BPRefresh_MainWidow.lib = nil;
		print("体修词条助手:载入动态库失败！","错误编号:",tostring(dllType));
	else
		BPRefresh_MainWidow.lib = RAsm:GetType("QFLib.QFLib");
		if BPRefresh_MainWidow.lib==nil then
			dllType=-3;
			print("体修词条助手:载入动态库失败！","错误编号:",tostring(dllType));
		else
			print("体修词条助手:载入动态库成功！");
		end
	end
	BPRefresh_MainWidow:GameIn();
	BPRefresh_MainWidow.HadInt =true;
	return true;
end
function BPRefresh_MainWidow:OnObjectEvent(t,obj,context)
	print(t,obj,obj.name)
	if t == "onClick" then
------------
		if obj.name == "bnt6_1" then
			local SEttingBPricticeLableCB,LC=BPRefresh_MainWidow:FSEttingBPricticeLableC();
			if SEttingBPricticeLableCB then
				BPRefresh_MainWidow.ShowLable.text = "修改成功数："..tostring(LC);
			else
				BPRefresh_MainWidow.ShowLable.text = "修改失败!";
			end
			return;
		end
		if obj.name == "BPBox61" then
			if BPRefresh_MainWidow.CheckBox61.selected then
				QFForeInte.SetValue(101,1);
				BPRefresh_MainWidow.ShowLable.text = "开局自动修改可选词条数已开启!";
			else
				QFForeInte.SetValue(101,2);
				BPRefresh_MainWidow.ShowLable.text = "开局自动修改可选词条数已关闭!";
			end
			return;
		end
		if obj.name == "bnt6_2" then
			if BPRefresh_MainWidow.bnt6_2Bool then
				BPRefresh_MainWidow.RemoveBPBtn();
				
				BPRefresh_MainWidow.bnt6_2Bool=false;
				BPRefresh_MainWidow.bnt6_2.m_title.text = "已关闭";
				BPRefresh_MainWidow.ShowLable.text = "已关闭该功能!";
			else
				local lv,t=BPRefresh_MainWidow.AddBPBtn();
				if lv~=nil then
					BPRefresh_MainWidow.bnt6_2Bool=true;
					BPRefresh_MainWidow.bnt6_2.m_title.text = "已开启";
					BPRefresh_MainWidow.ShowLable.text = "已开启该功能!";
				else
					--local lv2=BPRefresh_MainWidow.TryShow();
					----GameMain:GetMod("_Event"):RegisterEvent(g_emEvent.WindowEvent,BPRefresh_MainWidow.TryShow, "BPRefresh_MainWidow");
					--
					--if lv2 then
					--	lv=BPRefresh_MainWidow.AddBPBtn();
					--	if lv then
					--		BPRefresh_MainWidow.ShowLable.text = "尝试开启成功!可能会有窗口一闪而过。";
					--	else
					if t==1 then
						BPRefresh_MainWidow.ShowLable.text = "开启失败!未知错误。";
					else
						BPRefresh_MainWidow.ShowLable.text = "开启失败!未开启过词条选择界面。";
					end
					--	end
					--end
					
				end
				
			end
			return;
		end
	end
end
------------------------------------------------------
function BPRefresh_MainWidow:GameIn()
	if BPRefresh_MainWidow.CheckValue(101) then
		BPRefresh_MainWidow.SEttingBPricticeLableC();
		return true;
	--else
		--BPRefresh_MainWidow.SetValue(101,1);
		--BPRefresh_MainWidow.SetValue(100,tonumber(BPRefresh_MainWidow.BPCount));
		--BPRefresh_MainWidow.SEttingBPricticeLableC();
		--return true;
	end
	return false;
end
function BPRefresh_MainWidow.FSEttingBPricticeLableC()
	local num = tonumber(BPRefresh_MainWidow.input61.text);
	if num~=nil then
		BPRefresh_MainWidow.SetValue(100,num);
		return BPRefresh_MainWidow.SEttingBPricticeLableC();
	else
		return false,0;
	end
end
function BPRefresh_MainWidow.SEttingBPricticeLableC()
	if BPRefresh_MainWidow.lib~=nil then
		local func=BPRefresh_MainWidow.lib:GetMethod("SEttingBPricticeLableC");
		QFStr="0";
		local str2=BPRefresh_MainWidow.GetValue(100);
		--print("Value:"..tostring(str2));
		if str2==nil then
			str2=10;
		end
		QFStr2=tostring(str2-1);
		
		local count=func:Invoke();
		return true,count;
	end
	return false,0;
end
function BPRefresh_MainWidow.RemoveBPBtn()
	if BPRefresh_MainWidow.BPLableRefreshBtn==nil then
		return false;
	end
	local func=BPRefresh_MainWidow.lib:GetMethod("GetBodyRollLabelUI");
	local windowUI=func:Invoke();
	windowUI:RemoveChild(BPRefresh_MainWidow.BPLableRefreshBtn);
	BPRefresh_MainWidow.BPLableRefreshBtn=nil;
	return true;
end
function BPRefresh_MainWidow.TryShow(W,S)
	--print(tostring(W),tostring(W[0]),tostring(W[1]),tostring(W[S]))
	if CS.XiaWorld.Wnd_BodyRollLabel~=nil and CS.XiaWorld.Wnd_BodyRollLabel.Instance~=nil then
		xlua.private_accessible("Wnd_BodyRollLabel");
		local window=CS.XiaWorld.Wnd_BodyRollLabel.Instance;
		window:OnInit();
		--local list={};
		--window:Show(list);
		--window:Hide();
		return true;
	end
	return false;
end
function BPRefresh_MainWidow.AddBPBtn()
	if BPRefresh_MainWidow.BPLableRefreshBtn~=nil then
		return BPRefresh_MainWidow.BPLableRefreshBtn;
	end
	local t=0;
	if CS.XiaWorld.Wnd_BodyRollLabel~=nil and CS.XiaWorld.Wnd_BodyRollLabel.Instance~=nil and CS.XiaWorld.UI.InGame~=nil and CS.XiaWorld.UI.InGame.UI_WindowBodyRollLabel~=nil and CS.XiaWorld.UI.InGame.UI_Button~=nil then
		local window=CS.XiaWorld.Wnd_BodyRollLabel.Instance;
		local windowUI=nil;
		if BPRefresh_MainWidow.lib~=nil then
			local func=BPRefresh_MainWidow.lib:GetMethod("GetBodyRollLabelUI");
			windowUI=func:Invoke();
		end
		local BtnUI=CS.XiaWorld.UI.InGame.UI_Button;
		if windowUI~=nil then
			--local LGTextField=windowUI.m_n76;
			BPRefresh_MainWidow.BPLableRefreshBtn=BtnUI:CreateInstance();
			local btn=BPRefresh_MainWidow.BPLableRefreshBtn;
			
			BPRefresh_MainWidow.SetBPRBtnSize(btn,windowUI.width/10*4,windowUI.height/10*9.56,windowUI.width/10*2,windowUI.height/10*0.4)
			BPRefresh_MainWidow.SetBPRBtnText(btn,"刷新x"..tostring(0));
			btn.onClick:Add(BPRefresh_MainWidow.BPLableRefreshFunc);
			windowUI:AddChild(btn);
			t=1;
		end
	end
	--BPRefresh_MainWidow.BPLableRefreshBtnCount=0;
	return BPRefresh_MainWidow.BPLableRefreshBtn,t;
	--print("2");
end
function BPRefresh_MainWidow.BPLableRefreshFunc()
	local window=CS.XiaWorld.Wnd_BodyRollLabel.Instance;
	local btn=BPRefresh_MainWidow.BPLableRefreshBtn;
	local lbool;--npc=CS.XiaWorld.WorldMgr.Instance.curWorld.map.Things:GetPlayerActiveNpcs();;
	--npc.PropertyMgr.Practice.BodyPracticeData.GetDoingQuenching(npc.Key);
	--window:SelectLabel(npc, 3);
	if BPRefresh_MainWidow.lib~=nil then
		local func=BPRefresh_MainWidow.lib:GetMethod("BodyRollLabelUIRefresh");
		lbool=func:Invoke();
		BPRefresh_MainWidow.BPLableRefreshBtnCount=BPRefresh_MainWidow.BPLableRefreshBtnCount+1;
		BPRefresh_MainWidow.SetBPRBtnText(btn,"刷新x"..tostring(BPRefresh_MainWidow.BPLableRefreshBtnCount));
	end
	--print("3");
	return true;
end
function BPRefresh_MainWidow.SetBPRBtnSize(btn,x,y,w,h)
	if btn==nil then
		return fasle;
	end
	if x==nil then
		x=0;
	end
	if y==nil then
		y=0;
	end
	if w==nil then
		w=40;
	end
	if h==nil then
		h=25;
	end
	btn:SetSize(w, h, false);
	btn:SetXY(x, y);
	--print("0");
end
function BPRefresh_MainWidow.SetBPRBtnText(btn,text)
	if btn==nil then
		return false;
	end
	btn.m_title.text=text;
	--print("1");
	return true;
end
--------------------------------------------------
function BPRefresh_MainWidow.SetValue(num,value)
	local head=78000
	World:SetFlag(head+num, value);
	return true;
end
function BPRefresh_MainWidow.CheckValue(num)
	local head=78000
	local num=World:GetFlag(head+num);
	if num==1 then
		return true;
	else
		return false;
	end
end
function BPRefresh_MainWidow.GetValue(num)
	local head=78000
	local num=World:GetFlag(head+num);
	return num;
end
function BPRefresh_MainWidow:AddInput(objs,name,value,x,y,w,h,topText)
	local obj = objs:AddObjectFromUrl("ui://0xrxw6g7hdhl1c",x,y);
	obj.m_title.text = value;
	obj.m_title.singleLine=true;
	obj.name = name;
	if w~=nil and h~=nil then
		obj:SetSize(w, h);
	end
	if tostring(topText)~=nil and tostring(topText)~="nil" then
		obj.tooltips=topText;
	end
	return obj;
end
function BPRefresh_MainWidow:AddLable(objs,name,value,x,y,w,h,topText)
	local obj = objs:AddObjectFromUrl("ui://0xrxw6g7gtsug9",x,y);
	obj.m_title.text = value;
	obj.m_title.singleLine=true;
	obj.name = name;
	if tostring(topText)~=nil and tostring(topText)~="nil" then
		obj.tooltips=topText;
	end
	if w==nil or h==nil then
		w=80;
		h=25;
	end
	obj:SetSize(w, h);
	return obj;
end
function BPRefresh_MainWidow:AddLable2(objs,name,value,x,y,w,h,topText)
	local obj = objs:AddObjectFromUrl("ui://0xrxw6g7snk12s",x,y);
	obj.m_title.text = value;
	obj.m_title.singleLine=true;
	obj.name = name;
	obj.m_icon.visible=false;
	obj.m_icon.width=0;
	obj.m_title.align = CS.FairyGUI.AlignType.Left;
	obj.m_title.x=0;
	if tostring(topText)~=nil and tostring(topText)~="nil" then
		obj.tooltips=topText;
	end
	if w==nil or h==nil then
		w=80;
		h=25;
	end
	obj:SetSize(w, h);
	return obj;
end
function BPRefresh_MainWidow:AddButton(objs,name,value,x,y,w,h,topText)
	local obj = objs:AddObjectFromUrl("ui://0xrxw6g7hdhl18",x,y);
	if w==nil or h==nil then
		w=60;
		h=25;
	end
	obj:SetSize(w, h);
	obj.m_title.singleLine=true;
	obj.m_title.textFormat.bold=false;
	obj.m_title.textFormat.size=11;
	obj.m_title.autoSize=CS.FairyGUI.AutoSizeType.Both;--Both--Shrink
	obj.m_title.text = value;
	if tostring(topText)~=nil and tostring(topText)~="nil" then
		obj.tooltips=topText;
	end
	obj.name = name;
	return obj;
end
function BPRefresh_MainWidow:AddCheckBox(name,value,x,y)
	local obj = self:AddObjectFromUrl("ui://0xrxw6g7hdhl1a",x,y);
	obj.m_title.text = value;
	obj.name = name;
	return obj;
end