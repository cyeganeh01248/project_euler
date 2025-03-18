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

function zip(...)
	local iterators = { ... }
	local function next()
		local results = {}
		for _, iterator in ipairs(iterators) do
			local result = iterator()
			if result == nil then
				return nil
			end
			table.insert(results, result)
		end
		return results
	end
	return next
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

function map(iter, func)
	local function next()
		local result = iter()
		if result == nil then
			return nil
		end
		return func(result)
	end
	return next
end

function is_palindrome(num)
	local str = tostring(num)
	return str == str:reverse()
end

function is_prime(num)
	if num <= 1 then
		return false
	end
	if num <= 3 then
		return true
	end
	if num % 2 == 0 or num % 3 == 0 then
		return false
	end

	local i = 5
	while (i * i) <= num do
		if num % i == 0 or num % (i + 2) == 0 then
			return false
		end
		i = i + 6
	end

	return true
end

function prime_iter()
	local i = 2
	local primes_seen = {}
	local function next()
		for _, prime in ipairs(primes_seen) do
			if i % prime == 0 then
				i = i + 1
				return next()
			end
		end
		table.insert(primes_seen, i)
		i = i + 1
		return i - 1
	end
	return next
end

function prime_sieve(num)
	local nums = {}
	for i = 2, num do
		nums[i] = true
	end
	for i = 2, math.sqrt(num) do
		if nums[i] then
			for j = i * i, num, i do
				nums[j] = false
			end
		end
	end
	local primes = {}
	for i = 2, num do
		if nums[i] then
			table.insert(primes, i)
		end
	end
	return primes
end

function prime_factors(n)
	local factors = {}
	local piter = prime_iter()
	local p = piter()
	while n > 1 do
		while n % p == 0 do
			table.insert(factors, p)
			n = n // p
		end
		p = piter()
	end
	return factors
end

function polygonal_number(s, n)
	return (s - 2) * (n * (n - 1)) // 2 + n
end

function polygonal_number_iter(s)
	local i = 1
	local function next()
		local result = polygonal_number(s, i)
		i = i + 1
		return result
	end
	return next
end

fns.fibs_until = fibs_until
fns.sum = sum
fns.zip = zip
fns.filter = filter
fns.map = map
fns.is_palindrome = is_palindrome
fns.is_prime = is_prime
fns.prime_iter = prime_iter
fns.prime_sieve = prime_sieve
fns.prime_factors = prime_factors
fns.polygonal_number = polygonal_number
fns.polygonal_number_iter = polygonal_number_iter
fns.triangle_number = function(n)
	return polygonal_number(3, n)
end
fns.triangle_number_iter = function()
	return polygonal_number_iter(3)
end

return fns
