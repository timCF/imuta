#Imuta = {
window.Imuta = {
	clone: (some) -> 
		switch Object.prototype.toString.call(some)
			when "[object Undefined]" then undefined
			when "[object Boolean]" then some
			when "[object Number]" then some
			when "[object String]" then some
			when "[object Function]" then new () -> some
			when "[object Null]" then null
			when "[object Array]" then some.map (el) -> Imuta.clone(el)
			when "[object Object]" then Object.keys(some).reduce ((acc, k) -> acc[Imuta.clone(k)] = Imuta.clone(some[k]); acc), {}
	equal: (a, b) ->
		if a == b 
			true
		else
			[type_a, type_b] = [Object.prototype.toString.call(a), Object.prototype.toString.call(b)]
			if type_a == type_b
				switch type_a
					when "[object Undefined]" then true
					when "[object Boolean]" then a == b
					when "[object Number]" then a == b
					when "[object String]" then a == b
					when "[object Function]" then false
					when "[object Null]" then true
					when "[object Array]"
						len_a = a.reduce(((acc, _) -> acc+1), 0)
						len_b = b.reduce(((acc, _) -> acc+1), 0)
						if (len_a == len_b) then [0..len_a].every (n) -> Imuta.equal(a[n], b[n]) else false
					when "[object Object]"
						[keys_a, keys_b] = [a,b].map((obj) -> lst = []; lst.push(k) for k, _ of obj; lst.sort() )
						if Imuta.equal(keys_a, keys_b) then keys_a.every (k) -> Imuta.equal(a[k], b[k]) else false
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
	put_in: (obj, path, value) ->
		if (path.length == 0) then throw(new Error("put_in func failed, empty path"))
		[head, tail...] = path
		if (tail.length == 0)
			obj[head] = Imuta.clone(value)
			obj
		else
			if obj.hasOwnProperty(head)
				obj[head] = Imuta.put_in(obj[head], tail, value)
				obj
			else
				throw(new Error("put_in func failed, obj has no property "+head))
	get_in: (obj, path) ->
		if (path.length == 0) then throw(new Error("get_in func failed, empty path"))
		[head, tail...] = path
		if obj.hasOwnProperty(head) then (if (tail.length == 0) then Imuta.clone(obj[head]) else Imuta.get_in(obj[head], tail)) else undefined
	update_in: (obj, path, func) ->
		if (path.length == 0) then throw(new Error("update_in func failed, empty path"))
		[head, tail...] = path
		if obj.hasOwnProperty(head)
			if (tail.length == 0)
				if Imuta.is_function(func) and (func.length == 1)
					obj[head] = Imuta.clone(func(obj[head]))
					obj
				else
					throw(new Error("Get not function/1 handler in update_in func"))
			else
				obj[head] = Imuta.update_in(obj[head], tail, func)
				obj
		else
			throw(new Error("update_in func failed, obj has no property "+head))
}
#module.exports = Imuta