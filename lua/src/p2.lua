local function main()
	local utils = require("src/utils")
	local bn = utils.bn

	return utils.functools.sum(
		utils.functools.filter(utils.tools.iter(utils.fibonacci.fibs_until(4000000)), function(n)
			return n % bn(2) == bn(0)
		end),
		bn(0)
	)
end
return {
	problem = main,
}
