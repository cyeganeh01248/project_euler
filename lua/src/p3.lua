local function main()
	local utils = require("src/utils")

	local number = 600851475143
	local max_prime = -1

	while number % 2 == 0 do
		max_prime = 2
		number = number // 2
	end

	local factor = 3
	while (factor * factor) <= number do
		if number % factor == 0 then
			max_prime = factor
			number = number // factor
		else
			factor = factor + 2
			while not utils.prime.is_prime(factor) do
				factor = factor + 2
			end
		end
	end

	if number > 2 then
		max_prime = number
	end

	return max_prime
end
return {
	problem = main,
}
