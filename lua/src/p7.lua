local utils = require("src/utils")

local function main()
	local p_iter = utils.prime.prime_iter()
	for i=1,10000 do
		p_iter()
	end	
	return p_iter()
end
return {
	problem = main,
}
