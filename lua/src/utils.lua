---@class BN

local bc = require("bc")
local bn = bc.new

---@param iter fun():any
---@return fun():any
local function cycle(iter)
	local vals_scene = {}
	local index = 1

	for val in iter do
		table.insert(vals_scene, val)
	end

	return function()
		local result = vals_scene[index]
		index = (index % #vals_scene) + 1
		return result
	end
end

---@param val any The value to repeat
---@param n number | nil The number of times to repeat the value
---@return fun():any
local function rep(val, n)
	local i = 1
	return function()
		if n ~= nil and i <= n then
			i = i + 1
			return val
		end
	end
end

local function chain(...)
	local iterators = { ... }
	local index = 1
	local function next()
		if index > #iterators then
			return nil
		end
		local result = iterators[index]()
		if result == nil then
			print("iter done")
			index = index + 1
			return next()
		end
		return result
	end
	return next
end

---@param iter fun():any
---@param predicate fun(val:any):boolean
---@return fun():any iter
local function dropwhile(iter, predicate)
	local dropping = true
	return function()
		while dropping do
			local result = iter()
			if result == nil or not predicate(result) then
				dropping = false
				return result
			end
		end
		return iter()
	end
end
---@param iter fun():any
---@param predicate fun(val:any):boolean
---@return fun():any iter
local function takewhile(iter, predicate)
	local taking = true
	return function()
		if taking then
			local result = iter()
			if result == nil or not predicate(result) then
				taking = false
				return nil
			end
			return result
		end
		return nil
	end
end

---@generic T
---@param iter fun():T An iterator of a type that supports add
---@param initial T|nil The default value to start with
---@return T
local function sum(iter, initial)
	local cur_sum = initial or 0
	for num in iter do
		cur_sum = cur_sum + num
	end
	return cur_sum
end

---@param ... fun():any Any iterators to zip
---@return fun():any[]|nil iter
local function zip(...)
	local iterators = { ... }
	return function()
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
end

---@generic T
---@param iter fun():T An iterator of a type that supports add
---@param predicate fun(val:T):boolean A function to return a bool for be kept
---@return fun():T iter
local function filter(iter, predicate)
	return function()
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
end

---@generic T
---@generic V
---@param iter fun():T An iterator of a type that supports add
---@param func fun(val:T):V A function to transform the type to the new value
---@return fun():V iter
local function map(iter, func)
	return function()
		local result = iter()
		if result == nil then
			return nil
		end
		return func(result)
	end
end

---@param num number The number to check
---@return boolean
local function is_palindrome(num)
	local str = tostring(num)
	return str == str:reverse()
end

---@param num number The number to check
---@return boolean
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

---@return fun():number iter A iterator over prime numbers
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

---@param n number The number of primes to return
---@return number[]
local function prime_n(n)
	local p_iter = prime_iter()
	local primes = {}
	local p = p_iter()
	for _ = 1, n do
		table.insert(primes, p_iter())
	end
	return primes
end

---@param n number The max number to check up to
---@return number[]
local function prime_sieve(n)
	local nums = {}
	for i = 2, n do
		nums[i] = true
	end
	for i = 2, math.sqrt(n) do
		if nums[i] then
			for j = i * i, n, i do
				nums[j] = false
			end
		end
	end
	local primes = {}
	for i = 2, n do
		if nums[i] then
			table.insert(primes, i)
		end
	end
	return primes
end

---@param n number The number to check
---@return number[]
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

---@param n number The nth fib to get
---@return BN
local function fib(n)
	local function fib_helper(a, b, num_remaining)
		if num_remaining == 0 then
			return a
		elseif num_remaining == 1 then
			return b
		else
			return fib_helper(b, a + b, num_remaining - 1)
		end
	end
	return fib_helper(bn(0), bn(1), n)
end

---@param max number The max number of the fibs to get
---@return BN[]
local function fibs_until(max)
	max = bn(max)
	local a, b = bn(0), bn(1)
	local fibs = {}

	while a < max do
		table.insert(fibs, a)
		a, b = b, a + b
	end
	return fibs
end

---@param n number The number of fibs to get
---@return BN[]
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

---@param max number|nil The max number to go to
---@return fun():BN|nil iter
local function fib_iter(max)
	local bn = require("nums").bn
	local a, b = bn(0), bn(1)

	return function()
		local result = a
		if max ~= nil and a > max then
			return
		end
		a, b = b, a + b
		return result
	end
end

---@param s number|BN The number of sides
---@param n number|BN The nth number to get
---@return number|BN
local function polygonal_number(s, n)
	return (s - 2) * (n * (n - 1)) // 2 + n
end

---@param s number|BN The number of sides
---@return fun():BN iter
local function polygonal_number_iter(s)
	local i = bn(1)
	return function()
		local result = polygonal_number(bn(s), i)
		i = i + bn(1)
		assert(type(result) == "BN")
		return result
	end
end

local function triangle_number(n)
	return polygonal_number(3, n)
end
local function triangle_number_iter()
	return polygonal_number_iter(3)
end

---@param n number|BN The nth number to get
---@return number|BN
local function square_number(n)
	return n * n
end

---@return fun():BN iter
local function square_number_iter()
	local i = 1
	return function()
		local result = i * i
		i = i + 1
		assert(type(result) == "BN")
		return result
	end
end

---@param a number|nil
---@param b number|nil
---@param c number|nil
---@return fun():number|nil iter
local function range(a, b, c)
	local start = 1
	local stop = 1
	local step = 1

	if a == nil and b == nil and c == nil then
		start = 1
		stop = 1
		step = 1
	elseif b == nil and c == nil then
		assert(type(a) == "number")
		start = 1
		stop = a
		step = 1
	elseif c == nil then
		assert(type(a) == "number")
		assert(type(b) == "number")
		start = a
		stop = b
		step = 1
	else
		assert(type(a) == "number")
		assert(type(b) == "number")
		assert(type(c) == "number")
		start = a
		stop = b
		step = c
	end

	if step == 0 then
		error("step cannot be zero")
	end

	local i = start
	return function()
		local result = i
		if stop ~= nil and (step > 0 and i > stop) or (step < 0 and i < stop) then
			return
		end
		i = i + step
		return result
	end
end

---@generic T
---@param iter fun():T
---@return T[]
local function collect(iter)
	local result = {}
	for item in iter do
		table.insert(result, item)
	end
	return result
end

---@generic T
---@param t T[] An array of t
---@return fun():T|nil iter
local function iter(t)
	local i = 1
	return function()
		if i > #t then
			return
		end
		local result = t[i]
		i = i + 1
		return result
	end
end

return {
	functools = {
		cycle = cycle,
		rep = rep,
		chain = chain,
		dropwhile = dropwhile,
		takewhile = takewhile,
		sum = sum,
		zip = zip,
		filter = filter,
		map = map,
		range = range,
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
		triangle_number = triangle_number,
		triangle_number_iter = triangle_number_iter,
		square_number = square_number,
		square_number_iter = square_number_iter,
	},
	tools = {
		collect = collect,
		iter = iter,
	},
	nums = nums,
	bn = bn,
}
