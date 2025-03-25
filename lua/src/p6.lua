local utils = require("src/utils")

local function main()
	local sum_square = utils.functools.sum(utils.functools.map(utils.functools.range(1, 100), function(n)
		return math.floor(n ^ 2)
	end))
	local square_sum = math.floor((utils.functools.sum(utils.functools.range(1, 100)) ^ 2))
	return square_sum - sum_square
end
return {
	problem = main,
}
