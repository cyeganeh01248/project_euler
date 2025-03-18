function main()
	local sum = 0
	for i = 1, 1000 - 1 do
		if i % 3 == 0 or i % 5 == 0 then
			sum = sum + i
		end
	end

	return sum
end
local fns = {
	problem = main,
}
return fns
