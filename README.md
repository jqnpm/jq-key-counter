<p align="center">
  <a href="https://github.com/joelpurra/jqnpm"><img src="https://rawgit.com/joelpurra/jqnpm/master/resources/logotype/penrose-triangle.svg" alt="jqnpm logotype, a Penrose triangle" width="100" border="0" /></a>
</p>

# [jq-key-counter](https://github.com/joelpurra/jq-key-counter)

Count occurances of values across objects and arrays.

This is a package for the command-line JSON processor [`jq`](https://stedolan.github.io/jq/). Install the package in your jq project/package directory with [`jqnpm`](https://github.com/joelpurra/jqnpm):

```bash
jqnpm install joelpurra/jq-key-counter
```



## Usage


```jq
import "joelpurra/jq-key-counter" as KeyCounter;

# Create a new key counter object.
KeyCounter::create									# {}

# Increment the "a" key.
| KeyCounter::increment("a")						# { "a": 1 }

# Increment by an arbitrary (positive or negative) integer.
| KeyCounter::incrementBy("b"; 7)					# { "a": 1, "b": 7 }

# Decrement a single key.
| KeyCounter::decrement("b")						# { "a": 1, "b": 6 }

# Add two key counter objects.
| KeyCounter::add({ "a": 4, "c": 3 })				# { "a": 5, "b": 6, "c": 3 }

# Add an array of keys.
| KeyCounter::incrementByArray([ "b", "c", "d" ])	# { "a": 5, "b": 7, "c": 4, "d": 1 }

# Drop values below 3;
| KeyCounter::minimum(3)							# { "a": 5, "b": 7, "c": 4 }

# Get the top 2 values, sorted by values (descending):
| KeyCounter::top(2)								# { "b": 7, "a": 5 }
```



---

## License
Copyright (c) 2014, 2015, Joel Purra <http://joelpurra.com/>
All rights reserved.

When using **jq-key-counter**, comply to the MIT license. Please see the LICENSE file for details.
