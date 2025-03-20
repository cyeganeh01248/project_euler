local function sum(iter, initial)
	local cur_sum = initial or 0
	for num in iter do
		cur_sum = cur_sum + num
	end
	return cur_sum
end

local function zip(...)
	local iterators = { ... }
	local function next()
		local results = {}
		for _, iter in ipairs(iterators) do
			local result = iter()
			if result == nil then
				return nil
			end
			table.insert(results, result)
		end
		return results
	end
	return next
end

local function filter(iter, predicate)
	local function next()
		while true do
			local num = iter()
			if num == nil then
				return nil
			end
			if predicate(num) then
				return num
			end
		end
	end

	return next
end

local function map(iter, func)
	local function next()
		local result = iter()
		if result == nil then
			return nil
		end
		return func(result)
	end
	return next
end

local function is_palindrome(num)
	local str = tostring(num)
	return str == str:reverse()
end

local function is_prime(num)
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

local function prime_iter()
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

local function prime_n(n)
	local p_iter = prime_iter()
	local primes = {}
	local p = p_iter()
	for _ = 1, n - 1 do
		table.insert(primes, p_iter())
	end
	return primes
end

local function prime_sieve(num)
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

local function prime_factors(n)
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

local function fib(n)
	local bn = require("nums").bn
	local function fib_helper(a, b, n)
		if n == 0 then
			return a
		elseif n == 1 then
			return b
		else
			return fib_helper(b, a + b, n - 1)
		end
	end
	return fib_helper(bn(0), bn(1), n)
end

local function fibs_until(max)
	local bn = require("nums").bn
	max = bn(max)
	local a, b = bn(0), bn(1)
	local fibs = {}

	while a < max do
		table.insert(fibs, a)
		a, b = b, a + b
	end
	return fibs
end

local function fib_n(n)
	local bn = require("nums").bn

	local fibs = {}
	local a, b = bn(0), bn(1)

	while n > 0 do
		table.insert(fibs, a)
		a, b = b, a + b
		n = n - 1
	end
	return fibs
end

local function fib_iter(max)
	local bn = require("nums").bn
	local a, b = bn(0), bn(1)

	local function next()
		local result = a
		if max ~= nil and a > max then
			return
		end
		a, b = b, a + b
		return result
	end
	return next
end

local function polygonal_number(s, n)
	return (s - 2) * (n * (n - 1)) // 2 + n
end

local function polygonal_number_iter(s)
	local i = 1
	local function next()
		local result = polygonal_number(s, i)
		i = i + 1
		return result
	end
	return next
end

local function range(a, b, c)
	local start = 1
	local stop = 1
	local step = 1

	if a == nil and b == nil and c == nil then
		start = 1
		stop = 1
		step = 1
	elseif b == nil and c == nil then
		start = 1
		stop = a
		step = 1
	elseif c == nil then
		start = a
		stop = b
		step = 1
	else
		start = a
		stop = b
		step = c
	end

	if step == 0 then
		error("step cannot be zero")
	end

	local i = start
	local function next()
		local result = i
		if stop ~= nil and (step > 0 and i > stop) or (step < 0 and i < stop) then
			return
		end
		i = i + step
		return result
	end
	return next
end

local function collect(iter)
	local result = {}
	for item in iter do
		table.insert(result, item)
	end
	return result
end
local function table_iter(t)
	local i = 1
	local function next()
		if i > #t then
			return
		end
		local result = t[i]
		i = i + 1
		return result
	end
	return next
end

return {
	functools = {
		sum = sum,
		zip = zip,
		filter = filter,
		map = map,
	},
	general = {
		is_palindrome = is_palindrome,
	},
	prime = {
		is_prime = is_prime,
		prime_iter = prime_iter,
		prime_n = prime_n,
		prime_sieve = prime_sieve,
		prime_factors = prime_factors,
	},
	fibonacci = {
		fib = fib,
		fibs_until = fibs_until,
		fib_n = fib_n,
		fib_iter = fib_iter,
	},
	polygonal_num = {
		polygonal_number = polygonal_number,
		polygonal_number_iter = polygonal_number_iter,
		triangle_number = function(n)
			return polygonal_number(3, n)
		end,
		triangle_number_iter = function()
			return polygonal_number_iter(3)
		end,
	},
	tools = {
		range = range,
		collect = collect,
		table_iter = table_iter,
	},
}
