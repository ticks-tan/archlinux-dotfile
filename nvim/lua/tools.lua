function Load_Module(module)
	if type(module) == 'string' then
		local res,mod = pcall(require, module)
		if not res then
			print("Load Module[" .. module .."] Error !")
			return nil
		end
		return mod
	end
end
