
Imuta
=====

Simple js library to make your functional code better :)

Install
-------

```
bower install imuta --save
```

Main functions reference
------------------------

- Imuta.clone(any_term) -> any_term : recursively clone any js term and return its copy
- Imuta.equal(term_a,term_b) -> boolean : recursively compare any pair of js terms by values
- Imuta.flatten(list) -> list : recursively make new flatten list from any list(of lists of lists etc / or any terms), recursively clone all its elemets 
- Imuta.put_in(obj, path, value) -> puts clone of value to nested path of structure obj 
- Imuta.get_in(obj, path) -> gets clone of value from nested path of structure obj.. if not exisits returns undefined
- Imuta.update_in(obj, path, func) -> updates value in nested path of structure obj.. if not exisits - raise exception

And some simple boolean functions
---------------------------------

- is_undefined(t)
- is_boolean(t)
- is_number(t)
- is_string(t)
- is_function(t)
- is_null(t)
- is_list(t)
- is_map(t)

WARNING
-------

Cyclic references always gives stack overflow!!!