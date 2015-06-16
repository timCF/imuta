#Imuta = {
window.Imuta = {
	clone: (some) -> 
		switch Object.prototype.toString.call(some)
			when "[object Undefined]" then undefined
			when "[object Boolean]" then some
			when "[object Number]" then some
			when "[object String]" then some
			when "[object Function]" then some.bind({})
			when "[object Null]" then null
			when "[object Array]" then some.map (el) -> Imuta.clone(el)
			when "[object Object]" then Object.keys(some).reduce ((acc, k) -> acc[Imuta.clone(k)] = Imuta.clone(some[k]); acc), {}
	equal: (a, b) ->
		[type_a, type_b] = [Object.prototype.toString.call(a), Object.prototype.toString.call(b)]
		if type_a == type_b
			switch type_a
				when "[object Undefined]" then a == b
				when "[object Boolean]" then a == b
				when "[object Number]" then a == b
				when "[object String]" then a == b
				when "[object Function]" then a.toString() == b.toString()
				when "[object Null]" then a == b
				when "[object Array]"
					len_a = a.length
					len_b = b.length
					if len_a == len_b
						[0..len_a].every (n) -> Imuta.equal(a[n], b[n])
					else
						false
				when "[object Object]"
					keys_a = Object.keys(a).sort()
					keys_b = Object.keys(b).sort()
					if Imuta.equal(keys_a, keys_b)
						keys_a.every (k) -> Imuta.equal(a[k], b[k])
					else
						false
		else
			false
	is_undefined: (some) -> Object.prototype.toString.call(some) == "[object Undefined]"
	is_boolean: (some) -> Object.prototype.toString.call(some) == "[object Boolean]"
	is_number: (some) -> Object.prototype.toString.call(some) == "[object Number]"
	is_string: (some) -> Object.prototype.toString.call(some) == "[object String]"
	is_function: (some) -> Object.prototype.toString.call(some) == "[object Function]"
	is_null: (some) -> Object.prototype.toString.call(some) == "[object Null]"
	is_list: (some) -> Object.prototype.toString.call(some) == "[object Array]"
	is_map: (some) -> Object.prototype.toString.call(some) == "[object Object]"
	flatten: (some) ->
		if Imuta.is_list(some)
			some.reduce(((acc, el) ->
				if Imuta.is_list(el)
					acc.concat(Imuta.flatten(el))
				else
					acc.push(Imuta.clone(el))
					acc),[])
		else
			throw(new Error("Get not list input in Imuta.flatten func"))
}
#module.exports = Imuta