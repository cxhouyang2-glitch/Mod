local RealEsotericaData = GameMain:GetMod("RealEsotericaData");
RealEsotericaData.agent = nil;
function RealEsotericaData:OnBeforeInit()
	print("RealEsotericaData:OnBeforeInit");
	if RealEsotericaData.agent == nil 
	then
		local mod = CS.ModsMgr.Instance:FindMod("RealData","",true);
		local assembly = CS.System.Reflection.Assembly.LoadFrom(mod.Path.."\\Library\\RealDataEntry.dll");
		local type = assembly:GetType("RealDataEntry.MainClass");
		RealEsotericaData.agent = CS.System.Activator.CreateInstance(type);
		
		self:ModifyEsotericaDesc();
		self:ModifyItemDesc();
	end
end


function RealEsotericaData:OnEnter()
	print("RealEsotericaData:OnEnter");
end

function RealEsotericaData:ModifyEsotericaDesc()
	local mapSysEsoterica = CS.XiaWorld.EsotericaMgr.m_mapSysEsoterica;
	for k, v in pairs(mapSysEsoterica) do
		if v.Modifier ~= nil and v.Modifier ~= "" then
			local def = CS.XiaWorld.ModifierMgr.Instance:GetDef(v.Modifier);
			if def ~= nil then
				local IsExist = false;
				if v.Desc ~= nil and string.find(v.Desc, XT("实际效果")) then
					IsExist = true;
				end
				
				if not IsExist then
					local VecDesc = def:GetSimpleDesc();
					local Desc = XT("[size=10][color=#D06508]实际效果:\n");
					for a, b in pairs(VecDesc) do
						Desc = Desc .. b .. "\n";
					end
					
					
					if v.Desc ~= nil then
						--print(string.format(XT("v.Desc = %s"), v.Desc));
						v.Desc = Desc .. "[/color][/size]" .. v.Desc
					else
						v.Desc = Desc .. "[/color][/size]"
					end
				end
			end
		end
	end
	print(XT("加载功法的实际效果完毕!"));
end

function RealEsotericaData:ModifyItemDesc()
	local s_mapThingDefs = CS.XiaWorld.ThingMgr.s_mapThingDefs;
	for Index, VecThingDefs in pairs(s_mapThingDefs) do
		for k, v in pairs(VecThingDefs) do
			if v.Type == CS.XiaWorld.g_emThingType.Item and v.Item ~= nil then
				if v.Item.Equip ~= nil then
					local ToolModifier = v.Item.Equip.ToolModifier;
					local Modifier = v.Item.Equip.Modifier;

					if ToolModifier ~= nil and ToolModifier ~= "" then
						local IsExist = false;
						if v.Desc ~= nil and string.find(v.Desc, XT("实际效果")) then
							IsExist = true;
						end
						
						if not IsExist then
							local def = CS.XiaWorld.ModifierMgr.Instance:GetDef(ToolModifier);
							local VecDesc = def:GetSimpleDesc();
							local Desc = XT("[size=10][color=#FFA500]实际效果:\n");
							for a, b in pairs(VecDesc) do
								Desc = Desc .. b .. "\n";
							end
							
							
							if v.Desc ~= nil then
								--print(string.format(XT("ToolModifier.Desc = %s"), v.Desc));
								v.Desc = Desc .. "[/color][/size]" .. v.Desc
							else
								v.Desc = Desc .. "[/color][/size]"
							end
						end
					end
					
					if Modifier ~= nil and Modifier ~= "" then
						local IsExist = false;
						if v.Desc ~= nil and string.find(v.Desc, XT("实际效果")) then
							IsExist = true;
						end
						
						if not IsExist then
							--print(string.format("Name = [%s], Modifier = [%s]", v.ThingName, Modifier))
							local def = CS.XiaWorld.ModifierMgr.Instance:GetDef(Modifier);
							local VecDesc = def:GetSimpleDesc();
							local Desc = XT("[size=10][color=#FFA500]实际效果:\n");
							
							if v.Desc ~= nil and string.find(v.Desc, XT("实际效果:")) then
								--print(string.format(XT("v.Desc != nil and find = %s"), v.Desc));
								Desc = ""
							end
							
							for a, b in pairs(VecDesc) do
								Desc = Desc .. b .. "\n";
							end
							
							
							if v.Desc ~= nil then
								--print(string.format(XT("Modifier.Desc = %s"), v.Desc));
								v.Desc = Desc .. "[/color][/size]\n" .. v.Desc
							else
								v.Desc = Desc .. "[/color][/size]" 
							end
						end
					end
				
				end
				
				if v.Item.Elixir ~= nil and v.Item.Elixir.Modifier ~= nil and v.Item.Elixir.Modifier ~= "" then
					--print(string.format("Name = [%s], Elixir.Modifier = [%s]", v.ThingName, Modifier))
					local IsExist = false;
					if v.Desc ~= nil and string.find(v.Desc, XT("食用效果")) then
						IsExist = true;
					end
					
					if not IsExist then
						local def = CS.XiaWorld.ModifierMgr.Instance:GetDef(v.Item.Elixir.Modifier);
						local VecDesc = def:GetSimpleDesc();
						local Desc = XT("[size=10][color=#FFA500]食用效果:\n");


						for a, b in pairs(VecDesc) do
							Desc = Desc .. b .. "\n";
						end
						
						
						if def.Modifiers ~= nil then
							for c, SubModifier in pairs(def.Modifiers) do
								local SubDef = CS.XiaWorld.ModifierMgr.Instance:GetDef(SubModifier);
								local VecSubDesc = SubDef:GetSimpleDesc();
								for a, b in pairs(VecSubDesc) do
									Desc = Desc .. b .. "\n";
								end
							end
						end
						
						
						if v.Desc ~= nil then
							v.Desc = Desc .. "[/color][/size]\n" .. v.Desc
						else
							v.Desc = Desc .. "[/color][/size]"
						end
					end
				end
				
			end
		end
	end
	
	
	print(XT("加载物品的实际效果完毕!"));
end