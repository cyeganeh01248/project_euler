function main()
	local utils = require("src/utils")
	local palindromes = {}
	for a = 999, 100, -1 do
		for b = a - 1, 100, -1 do
			if utils.is_palindrome(a * b) then
				table.insert(palindromes, a * b)
			end
		end
	end
	table.sort(palindromes)
	return palindromes[#palindromes]
end
local fns = {
	problem = main,
}
return fns
