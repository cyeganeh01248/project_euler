function main()
	local utils = require("src/utils")
	local fibs = utils.fibs_until(4000000)
	local even_fibs = utils.filter(fibs, function(num)
		return num % 2 == 0
	end)
	local sum = utils.sum(even_fibs)
	print(sum)
end
local fns = {
	problem = main,
}
return fns
