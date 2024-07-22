## 搜索物品
- 按名称/ID/描述
  - /search `string`
   - (string为道具名/ID/道具描述;可模糊匹配)
- 列表
  - /search `ID` `ID`
## 给予物品
- 按ID
  - /give `string` `number`
- 批量
  - /give `list` `string` ... `string` `number`
  - /give `list` `string` `to` `string` `number`
- 按ID给某人
  - /give `to` `playerID` `string` `number`
- 批量给某人
  - /give `list` `to` `playerID` `string` ... `string` `number`

(string必须精准输入;number可忽略,默认为1)

## 设置(不稳定,请谨慎使用)
- 调整检索范围
  - /range `number` `number`
- 调整等待时间
  - /wait `number`
- 是否启用描述搜索
  - /SearchDesc `true/false`
- 搜索结果显示描述
  - /desc `true/false`
- 搜索结果启用筛选
  - /screen `true/false`
 - 是否携带标签
   - /tag `true/false`

## 查看指令列表
 - /help
## 使用上一个指令(指令记忆功能)
- / `参数`
  - (例如:发送`/search [string/id]`后，下次只需要发送`/ [string/ID]`即可实现同样效果)
## 查看脚本data
- /data

## 调试信息
- /ItemList `key`    
