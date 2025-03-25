local function main()
	for a = 1, (1000 - 2) do
		for b = (a + 1), (1000 - 1) do
			for c = (b + 1), 1000 do
				if a + b + c == 1000 and a * a + b * b == c * c then
					return a * b * c
				end
			end
		end
	end
	return 0
end
return {
	problem = main,
}
