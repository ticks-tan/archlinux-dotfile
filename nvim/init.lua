-- load module
function Load(module)
	if (type(module) == 'string') then
		local ok, err = pcall(require, module)
		if not ok then
			print("Load Module[" .. module .. "] Error !" .. err)
		end
	else
		print("Param module must a string type !")
	end
end

-- 加载基础配置
Load('basic')
-- 加载插件
Load('plugins')
-- 加载插件配置
Load('plugin-config')
-- 加载快捷键
Load('keybindings')
