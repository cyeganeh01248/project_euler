local fns = {}

function fibs_until(max)
	local fibs = {}

	local a, b = 0, 1

	while a < 4000000 do
		table.insert(fibs, a)
		a, b = b, a + b
	end
	return fibs
end

function sum(nums)
	local sum = 0
	for _, num in ipairs(nums) do
		sum = sum + num
	end
	return sum
end

function filter(nums, predicate)
	local filtered = {}
	for _, num in ipairs(nums) do
		if predicate(num) then
			table.insert(filtered, num)
		end
	end
	return filtered
end

fns.fibs_until = fibs_until
fns.sum = sum
fns.filter = filter

return fns
