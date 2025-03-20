local function main()
	local utils = require("src/utils")
	local facts = {}
	for i = 1, 20 do
		local facts_sub = utils.prime.prime_factors(i)
		local fact_count = {}
		for _, f in ipairs(facts_sub) do
			fact_count[f] = (fact_count[f] or 0) + 1
			facts[f] = math.max(facts[f] or 0, fact_count[f])
		end
	end
	local r = 1
	for i, v in pairs(facts) do
		for j = 1, v do
			r = r * i
		end
	end
	return r
end
return {
	problem = main,
}
