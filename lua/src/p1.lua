local function main()
	local utils = require("src/utils")

	return utils.functools.sum(utils.functools.filter(utils.tools.range(1, 1000 - 1), function(x)
		return x % 3 == 0 or x % 5 == 0
	end))
end
return {
	problem = main,
}
