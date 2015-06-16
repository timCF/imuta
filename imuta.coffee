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
}
#module.exports = Imuta