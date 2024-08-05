--全局设置
range={10000000,10010000}--检索范围
Tag=true--搜索结果携带来源标签
Wait=0--搜索结果打印延迟
Tips=false--每次开始都打印指令列表
DESC=true--显示描述
SearchDESC=true--启用描述搜索
Screen=false--标签筛选开关
AdminList=""--管理员名单(房主默认为最高级管理员)


function CSH(event)
  AdminAll=false
  if event==true then
    LastMsg={}
  end
  ItemList={NameList={},IdList={},AllList={},DescList={}}
  LocalList={}
  ItemTitle=0
  for i=range[1],range[2] do
    local result,name=Item:getItemName(i)
    local result,desc=Item:getItemDesc(i)
    if result==0 then
      ItemTitle=ItemTitle+1
      ItemList["AllList"][i]=i..""
      ItemList["NameList"][""..name]=i
      ItemList["IdList"][i]=name
      ItemList["DescList"][i]=desc
    end
  end
  print("#cff5c2c┌初始化完成")
  print("#cff5c2c├检索范围:#c66ccff"..range[1].."#cff5c2c~#c66ccff"..range[2])
print("#cff5c2c└有效道具:#c66ccff"..#ItemList["AllList"].."#cff5c2c个#n")
end
CSH(true)
function SearchTips(event)
  print("#cff5c2c┌指令列表:")
  print("#cff5c2c├┬搜索物品")
  print("#cff5c2c│├┬按名称/ID")
  print("#cff5c2c││├#c66ccff/search [string]")
  print("#cff5c2c││└string为道具名/ID;可模糊匹配")
  print("#cff5c2c│└┬列表")
  print("#cff5c2c│　├#c66ccff/search [ID] [ID]")
  print("#cff5c2c│　└(将搜索结果打印至控制台)")
  print("#cff5c2c├┬添加物品")
  print("#cff5c2c│├┬按ID")
  print("#cff5c2c││└#c66ccff/give [string] [number]")
  print("#cff5c2c│├┬批量")
  print("#cff5c2c││└#c66ccff/give list [string] ... [string] [number]")
  print("#cff5c2c││└#c66ccff/give list [string] to [string] [number]")
  print("#cff5c2c│├┬按ID给某人")
  print("#cff5c2c││└#c66ccff/give to [playerID] [string] [number]")
  print("#cff5c2c│├┬批量给某人")
  print("#cff5c2c││└#c66ccff/give list to [playerID] [string] ... [string] [number]")
  print("#cff5c2c│└(string必须精准输入;number可忽略,默认为1)")
  print("#cff5c2c├┬设置(不稳定,请谨慎使用)")
  print("#cff5c2c│├┬调整检索范围")
  print("#cff5c2c││└#c66ccff/range [number] [number]")
  print("#cff5c2c│├┬调整等待时间")
  print("#cff5c2c││└#c66ccff/wait [number]")
  print("#cff5c2c│├┬是否启用描述搜索")
  print("#cff5c2c││└#c66ccff/SearchDesc [true/false]")
  print("#cff5c2c│├┬搜索结果显示描述")
  print("#cff5c2c││└#c66ccff/desc [true/false]")
  print("#cff5c2c│├┬搜索结果启用筛选")
  print("#cff5c2c││└#c66ccff/screen [true/false]")
  print("#cff5c2c│└┬是否携带标签")
  print("#cff5c2c│　└#c66ccff/tag [true/false]")
  print("#cff5c2c├┬查看指令列表")
  print("#cff5c2c│└#c66ccff/help")
  print("#cff5c2c├┬使用上一个指令(指令记忆功能)")
  print("#cff5c2c│└#c66ccff/ [参数] #cff5c2c例:/ list 1 2 3 100")
  print("#cff5c2c├┬设置管理员权限(仅房主可用)")
  print("#cff5c2c│└#c66ccff/admin add/remove all/playerID")
  print("#cff5c2c├┬查看脚本data")
  print("#cff5c2c│└#c66ccff/data")
  print("#cff5c2c└┬调试信息")
  print("　#cff5c2c└#c66ccff/ItemList [key]")

end
if Tips==true then
  SearchTips()
end
function SearchMain(event)
r,AdminA=Player:getHostUin()
--AdminList=AdminList..tostring(AdminA)..','
if string.find(AdminList,tostring(event.eventobjid))~=nil or AdminA==event.eventobjid or AdminAll==true then
  msg=event.content
  MsgTab={}
  Separator=" "
  msg=msg..Separator
  MsgId=1
  for i=1,#msg-1 do
    string=string.sub(msg,i,i)
    if string==Separator then
      MsgId=MsgId+1
     else
      if MsgTab[MsgId]==nil or MsgTab[MsgId]=="" then
        MsgTab[MsgId]=string
       else
        MsgTab[MsgId]=MsgTab[MsgId]..string
      end
    end
  end
  if MsgTab[1]=="/" and LastMsg[#LastMsg]~=nil then
    MsgTab[1]=LastMsg[#LastMsg]
    Player:notifyGameInfo2Self(event.eventobjid,"#cff5c2c[指令记忆]["..LastMsg[#LastMsg].."][ok]")
   elseif MsgTab[1]=="/" and LastMsg[#LastMsg]==nil then
    Player:notifyGameInfo2Self(event.eventobjid,"#cff5c2c[指令记忆][error][找不到上一个指令]")
  end
  if MsgTab[1]~="/" then
    LastMsg[#LastMsg+1]=MsgTab[1]
  end
  if MsgTab[1]=="/search" then
    if #MsgTab==2 then
      Player:notifyGameInfo2Self(event.eventobjid,"#cff5c2c[search][ok]")
      print("#cff5c2c搜索#c66ccff"..MsgTab[2].."#cff5c2c的结果#n")
      for i=range[1],range[2] do
        if ItemList["IdList"][i]~=nil then
          local s=string.find(ItemList["IdList"][i],MsgTab[2])
          if s~=nil then
            LocalList[#LocalList+1]=ItemList["IdList"][i]
            if Wait>0 then
              Trigger:wait(Wait)
            end
            if Tag==true then
            if Screen==false then
              print("#cff5c2c[按名称]ID：#c66ccff"..i.."#cff5c2c丨名称：#c66ccff"..ItemList["IdList"][i].."#n")
              else
              UI:Print2WndWithTag('按名称',"ID：#c66ccff"..i.."#cff5c2c丨名称：#c66ccff"..ItemList["IdList"][i].."#n")
              end
              if DESC==true then
              
                if Screen==false then
                print("#cff5c2c描述：#c66ccff"..ItemList["DescList"][i].."\n#n")
                print(nil)
                else
                UI:Print2WndWithTag('描述',"#c66ccff"..ItemList["DescList"][i].."\n#n")
                end
              end
             elseif Tag==false then
              print("#cff5c2cID：#c66ccff"..i.."#cff5c2c丨名称：#c66ccff"..ItemList["IdList"][i].."#n")
              if DESC==true then
                if Screen==false then
                print("#cff5c2c描述：#c66ccff"..ItemList["DescList"][i].."\n#n")
                print(nil)
                else
                UI:Print2WndWithTag('描述',"#c66ccff"..ItemList["DescList"][i].."\n#n")
                end                
              end
            end
          end
        end
        ----
        if SearchDESC==true then
          if ItemList["DescList"][i]~=nil then
            local s=string.find(ItemList["DescList"][i],MsgTab[2])
            if s~=nil then
              LocalList[#LocalList+1]=ItemList["DescList"][i]
              if Wait>0 then
                Trigger:wait(Wait)
              end
              if Tag==true then
              if Screen==false then
                print("#cff5c2c[按描述]ID：#c66ccff"..i.."#cff5c2c丨名称：#c66ccff"..ItemList["IdList"][i].."#n")
                else
                UI:Print2WndWithTag('按描述',"ID：#c66ccff"..i.."#cff5c2c丨名称：#c66ccff"..ItemList["IdList"][i].."#n")
                end
                if DESC==true then
                  if Screen==false then
                print("#cff5c2c描述：#c66ccff"..ItemList["DescList"][i].."\n#n")
                print(nil)
                else
                UI:Print2WndWithTag('描述',"#c66ccff"..ItemList["DescList"][i].."\n#n")
                end                  
                end
               elseif Tag==false then
                print("#cff5c2cID：#c66ccff"..i.."#cff5c2c丨名称：#c66ccff"..ItemList["IdList"][i].."#n")
                if DESC==true then
                  if Screen==false then
                print("#cff5c2c描述：#c66ccff"..ItemList["DescList"][i].."\n#n")
                print(nil)
                else
                UI:Print2WndWithTag('描述',"#c66ccff"..ItemList["DescList"][i].."\n#n")
                end                  
                end
              end
            end
          end
        end
        ----

        if ItemList["AllList"][i]~=nil then
          local s=string.find(ItemList["AllList"][i].."",""..MsgTab[2])
          if s~=nil then
            LocalList[#LocalList+1]=ItemList["IdList"][i]
            if ItemList["IdList"][i]~=nil then
              if Wait>0 then
                Trigger:wait(Wait)
              end
              if Tag==true then
              if Screen==false then
                print("#cff5c2c[按ID]ID：#c66ccff"..i.."#cff5c2c丨名称：#c66ccff"..ItemList["IdList"][i].."#n")
                else
                UI:Print2WndWithTag('按ID',"ID：#c66ccff"..i.."#cff5c2c丨名称：#c66ccff"..ItemList["IdList"][i].."#n")
                end
                if DESC==true then
                  if Screen==false then
                print("#cff5c2c描述：#c66ccff"..ItemList["DescList"][i].."\n#n")
                print(nil)
                else
                UI:Print2WndWithTag('描述',"#c66ccff"..ItemList["DescList"][i].."\n#n")
                end                  
                end
               elseif Tag==false then
                print("#cff5c2cID：#c66ccff"..i.."#cff5c2c丨名称：#c66ccff"..ItemList["IdList"][i].."#n")
                if DESC==true then
                  if Screen==false then
                print("#cff5c2c描述：#c66ccff"..ItemList["DescList"][i].."\n#n")
                print(nil)
                else
                UI:Print2WndWithTag('描述',"#c66ccff"..ItemList["DescList"][i].."\n#n")
                end                  
                end
              end
            end
          end
        end
      end
      print("#cff5c2c共#c66ccff"..#LocalList.."#cff5c2c个结果#n")
      LocalList={}
    end

    if #MsgTab==3 then
      if tonumber(MsgTab[2])~=nil and tonumber(MsgTab[3])~=nil then
        if tonumber(MsgTab[2])>=range[1] and tonumber(MsgTab[2])<=range[2] then
          if tonumber(MsgTab[3])<=range[2] and tonumber(MsgTab[3])>=range[1] then
            if tonumber(MsgTab[2])<=tonumber(MsgTab[3]) then
              Player:notifyGameInfo2Self(event.eventobjid,"#cff5c2c[search][ok]")
              print("#cff5c2c从ID#c66ccff"..MsgTab[2].."#cff5c2c~#c66ccff"..MsgTab[3].."#cff5c2c的列表结果#n")
              for i=tonumber(MsgTab[2]),tonumber(MsgTab[3]) do
                if ItemList["IdList"][i]~=nil then
                  if Wait>0 then
                    Trigger:wait(Wait)
                  end
                  print("#cff5c2cID：#c66ccff"..i.."#cff5c2c丨名称：#c66ccff"..ItemList["IdList"][i].."#n")
                  if DESC==true then
                    if Screen==false then
                print("#cff5c2c描述：#c66ccff"..ItemList["DescList"][i].."\n#n")
                print(nil)
                else
                UI:Print2WndWithTag('描述',"#c66ccff"..ItemList["DescList"][i].."\n#n")
                end                    
                  end
                  LocalList[#LocalList+1]=ItemList["IdList"][i]
                end
              end
              print("#cff5c2c共#c66ccff"..#LocalList.."#cff5c2c个结果#n")
              LocalList={}
            end
          end
        end
      end
    end
  end
  if MsgTab[1]=="/ItemList" and MsgTab[2]~=nil then
    Player:notifyGameInfo2Self(event.eventobjid,"#cff5c2c[ItemList][ok]")
    print("#cff5c2cItemList数组中#c66ccff"..MsgTab[2].."#cff5c2c为索引的数据")
    print(ItemList[MsgTab[2]])
    print("#n")
  end
  if MsgTab[1]=="/give" and MsgTab[2]~="list" and MsgTab[2]~="to" and MsgTab[4]~="to" then
    if MsgTab[3]==nil then
      num=1
     else
      num=tonumber(MsgTab[3])
    end
    if tonumber(MsgTab[2])==nil then
      id=ItemList["NameList"][""..MsgTab[2]]
     elseif tonumber(MsgTab[2])~=882828858540 then
      id=tonumber(MsgTab[2])
    end
    local r,success=Backpack:addItem(event.eventobjid,id,num)
    if success<num then
      local r,x,y,z=Actor:getPosition(event.eventobjid)
      World:spawnItem(x,y,z,id,num-success)
    end
    if r==0 then
      Player:notifyGameInfo2Self(event.eventobjid,"#cff5c2c[give][ok]")
      id,num=nil,nil
    end
  end
  if MsgTab[1]=="/range" then
    if #MsgTab==3 then
      if tonumber(MsgTab[2])~=nil and tonumber(MsgTab[3])~=nil then
        if tonumber(MsgTab[2])<=tonumber(MsgTab[3]) then
          range[1],range[2]=tonumber(MsgTab[2]),tonumber(MsgTab[3])
          CSH(false)
          Player:notifyGameInfo2Self(event.eventobjid,"#cff5c2c[set][range][ok]")
        end
      end
    end
  end
  if MsgTab[1]=="/help" then
    SearchTips()
    Player:notifyGameInfo2Self(event.eventobjid,"#cff5c2c[help][ok]")
  end
  if MsgTab[1]=="/wait" then
    if tonumber(MsgTab[2])~=nil then
      Wait=tonumber(MsgTab[2])
      Player:notifyGameInfo2Self(event.eventobjid,"#cff5c2c[set][wait][ok]")
    end
  end
  if MsgTab[1]=="/tag" then
    if MsgTab[2]=="true" then
      Tag=true
     else
      Tag=false
    end
    Player:notifyGameInfo2Self(event.eventobjid,"#cff5c2c[set][tag][ok]")
  end
  if MsgTab[1]=="/desc" then
    if MsgTab[2]=="true" then
      DESC=true
     else
      DESC=false
    end
    Player:notifyGameInfo2Self(event.eventobjid,"#cff5c2c[set][desc][ok]")
  end
  if MsgTab[1]=="/screen" then
    if MsgTab[2]=="true" then
      Screen=true
     else
      Screen=false
    end
    Player:notifyGameInfo2Self(event.eventobjid,"#cff5c2c[set][screen][ok]")
  end
  if MsgTab[1]=="/SearchDesc" then
    if MsgTab[2]=="true" then
      SearchDESC=true
     else
      SearchDESC=false
    end
    Player:notifyGameInfo2Self(event.eventobjid,"#cff5c2c[set][SearchDesc][ok]")
  end
if MsgTab[1]=="/admin" then
if event.eventobjid==AdminA then
    if MsgTab[2]=="add" then
       if MsgTab[3]=="all" then
         AdminAll=true
Player:notifyGameInfo2Self(event.eventobjid,"#cff5c2c[set][Admin][AddAll][ok]")
       else
         AdminList=AdminList..MsgTab[3]..','
Player:notifyGameInfo2Self(event.eventobjid,"#cff5c2c[set][Admin][add][ok]")
       end
   elseif MsgTab[2]=='remove' then
       if MsgTab[3]=="all" then
AdminAll=false
Player:notifyGameInfo2Self(event.eventobjid,"#cff5c2c[set][Admin][RemoveAll][ok]")
          AdminList=''
       else
          AdminList=string.gsub(AdminList,MsgTab[3],'')
Player:notifyGameInfo2Self(event.eventobjid,"#cff5c2c[set][Admin][Remove][ok]")
       end
    end
else
Player:notifyGameInfo2Self(event.eventobjid,"#cff5c2c[set][Admin][err][没有最高管理权限]")
end
  end
  if MsgTab[1]=="/give" and MsgTab[2]=="to" and MsgTab[4]~="to" then
    if MsgTab[5]==nil then
      num=1
     else
      num=tonumber(MsgTab[5])
    end
    if tonumber(MsgTab[4])==nil then
      id=ItemList["NameList"][""..MsgTab[4]]
     elseif tonumber(MsgTab[4])~=882828858540 then
      id=tonumber(MsgTab[4])
    end
    if tonumber(MsgTab[3])~=nil then
      objid=tonumber(MsgTab[3])
    end
    local r,success=Backpack:addItem(objid,id,num)
    if success<num then
      local r,x,y,z=Actor:getPosition(objid)
      World:spawnItem(x,y,z,id,num-success)
    end
    if r==0 then
      Player:notifyGameInfo2Self(event.eventobjid,"#cff5c2c[give][ok]")
      objid,id,num=nil,nil,nil
    end
  end

  if MsgTab[1]=="/give" and MsgTab[2]=="list" and MsgTab[3]~="to" and MsgTab[4]~="to" then
    for i=3,#MsgTab-1 do
      if MsgTab[#MsgTab]==nil then
        num=1
       else
        num=tonumber(MsgTab[#MsgTab])
      end
      if tonumber(MsgTab[i])==nil then
        id=ItemList["NameList"][""..MsgTab[i]]
       elseif tonumber(MsgTab[i])~=882828858540 then
        id=tonumber(MsgTab[i])
      end
      local r,success=Backpack:addItem(event.eventobjid,id,num)
      if success<num then
        local r,x,y,z=Actor:getPosition(event.eventobjid)
        World:spawnItem(x,y,z,id,num-success)
      end
      if r==0 then
        Player:notifyGameInfo2Self(event.eventobjid,"#cff5c2c[give][ok]")
        id,num=nil,nil
      end
    end
  end
  if MsgTab[1]=="/give" and MsgTab[2]=="list" and MsgTab[3]=="to" and MsgTab[4]~="to" then
    if tonumber(MsgTab[4])~=nil then
      objid=tonumber(MsgTab[4])
    end
    for i=5,#MsgTab-1 do
      if MsgTab[#MsgTab]==nil then
        num=1
       else
        num=tonumber(MsgTab[#MsgTab])
      end
      if tonumber(MsgTab[i])==nil then
        id=ItemList["NameList"][""..MsgTab[i]]
       elseif tonumber(MsgTab[i])~=882828858540 then
        id=tonumber(MsgTab[i])
      end
      local r,success=Backpack:addItem(objid,id,num)
      if success<num then
        local r,x,y,z=Actor:getPosition(objid)
        World:spawnItem(x,y,z,id,num-success)
      end
      if r==0 then
        Player:notifyGameInfo2Self(event.eventobjid,"#cff5c2c[give][ok]")
        id,num=nil,nil
      end
    end
  end
  if MsgTab[1]=="/give" and MsgTab[2]=="list" and tonumber(MsgTab[3])~=nil and MsgTab[4]=="to" and tonumber(MsgTab[5])~=nil and tonumber(MsgTab[6])~=nil then
    for i=tonumber(MsgTab[3]),tonumber(MsgTab[5]) do
      local r,success=Backpack:addItem(event.eventobjid,i,tonumber(MsgTab[6]))
      if success<tonumber(MsgTab[6]) then
        local r,x,y,z=Actor:getPosition(event.eventobjid)
        World:spawnItem(x,y,z,i,tonumber(MsgTab[6])-success)
      end
      if r==0 then
        Player:notifyGameInfo2Self(event.eventobjid,"#cff5c2c[give][ok]")
        id,num=nil,nil
      end
    end
  end
  if MsgTab[1]=="/data" then
    Player:notifyGameInfo2Self(event.eventobjid,"#cff5c2c[data][ok]")
    print("#cff5c2c┌脚本data")
    print("#cff5c2c├检索范围  >>>  #c66ccff"..range[1].."#cff5c2c~#c66ccff"..range[2].."#cff5c2c,可用的道具共#c66ccff"..#ItemList["AllList"].."#cff5c2c个")
    print("#cff5c2c├是否携带标签  >>>  #c66ccff"..tostring(Tag))
    print("#cff5c2c├是否启用搜索描述  >>>  #c66ccff"..tostring(SearchDESC))
    print("#cff5c2c├是否显示描述  >>>  #c66ccff"..tostring(DESC))
    print("#cff5c2c├是否启用筛选  >>>  #c66ccff"..tostring(Screen))
    print("#cff5c2c├管理员权限  >>>  #c66ccff"..tostring(AdminList))
    print("#cff5c2c├记录的指令数量  >>>  #c66ccff"..#LastMsg)
    print("#cff5c2c└等待时间  >>>  #c66ccff"..tostring(Wait).."#cff5c2cs")
  end
elseif string.sub(event.content,0,1)=='/' then
Player:notifyGameInfo2Self(event.eventobjid,"#cff5c2c[NoPermission][无权限,请向最高级管理员索要指令权限]")
end
end
ScriptSupportEvent:registerEvent([=[Player.NewInputContent]=],SearchMain)

