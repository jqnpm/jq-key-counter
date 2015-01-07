#!/usr/bin/env bash


fileUnderTest="${BASH_SOURCE%/*}/../jq/main.jq"


read -d '' fourLineTests <<-'EOF' || true
create New key counter
null
create
{}

incrementBy Empty "a" 1
{}
incrementBy("a"; 1)
{ "a": 1 }

incrementBy Empty "a" 2
{}
incrementBy("a"; 2)
{ "a": 2 }

incrementBy 1 "a" 1
{ "a": 1 }
incrementBy("a"; 1)
{ "a": 2 }

incrementBy 2 "a" -1
{ "a": 2 }
incrementBy("a"; -1)
{ "a": 1 }

incrementBy 2 "a" -3
{ "a": 2 }
incrementBy("a"; -3)
{ "a": -1 }

incrementBy 1 "b" 10
{ "a": 1 }
incrementBy("b"; 10)
{ "a": 1, "b": 10 }

increment Empty "a"
{}
increment("a")
{ "a": 1 }

increment Empty "a" twice
{}
increment("a") | increment("a")
{ "a": 2 }

increment 1 "b"
{ "a": 1 }
increment("b")
{ "a": 1, "b": 1 }

decrement 2 "a"
{ "a": 2 }
decrement("a")
{ "a": 1 }

decrement 1 "b"
{ "a": 1 }
decrement("b")
{ "a": 1, "b": -1 }

add a+b
{ "a": 1 }
add({ "b": 1 })
{ "a": 1, "b": 1 }

add a+b with overlap
{ "a": 1, "b": 1 }
add({ "b": 1 })
{ "a": 1, "b": 2 }

incrementByArray a+a
{ "a": 1 }
incrementByArray([ "a" ])
{ "a": 2 }

incrementByArray a+b
{ "a": 1 }
incrementByArray([ "b" ])
{ "a": 1, "b": 1 }

minimum a=1, 2
{ "a": 1 }
minimum(2)
{}

minimum a=3, 2
{ "a": 3 }
minimum(2)
{ "a": 3 }

minimum a=3, b=1, 2
{ "a": 3, "b": 1 }
minimum(2)
{ "a": 3 }

minimumTwo a=3, b=1
{ "a": 3, "b": 1 }
minimumTwo
{ "a": 3 }

top a=2, b=1, c=3, 1
{ "a": 2, "b": 1, "c": 3 }
top(1)
{ "c": 3 }

top a=2, b=1, c=3, 2
{ "a": 2, "b": 1, "c": 3 }
top(2)
{ "c": 3, "a": 2 }

topTen unique values
{ "a": 2, "b": 1, "c": 3, "d": 4, "e": 11, "f": 6, "g": 10, "h": -4, "i": 8, "j": 9, "k": 5, "l": 7, "m": -10 }
topTen
{ "e": 11, "g": 10, "j": 9, "i": 8, "l": 7, "f": 6, "k": 5, "d": 4, "c": 3, "a": 2 }
EOF

# The sort in jq is unstable; can't expect key with the same values to have the same order each time.
# https://github.com/stedolan/jq/issues/343
# topTen unstable non-unique values
# { "a": 2, "b": 1, "c": 3, "d": 3, "e": 1, "f": 6, "g": 2, "h": -4, "i": 8, "j": 3, "k": 5, "l": 7, "m": -10 }
# topTen
# { "i": 8, "l": 7, "f": 6, "k": 5, "j": 3, "c": 3, "d": 3, "a": 2, "g": 2, "e": 1 }


# TODO: break out and reuse test harnesss.
function runAllFourLineTests () {
	DONE=false
	until $DONE;
	do
		local name
		local input
		local code
		local expected

		read name
		read input
		read code
		read expected

		local expectedPretty=$(echo "$expected" | jq '.')

		local output=$(echo "$input" | jqnpm execute -f <(echo "$code" | cat "$fileUnderTest" -))
		
		assertEquals "$name" "$expectedPretty" "$output"

		read || DONE=true # Empty line between tests.
	done
}

# TODO: make each test a separate function recognizable to shUnit2?
function testAllFourLineTests () {
	echo "$fourLineTests" | runAllFourLineTests
}


source shunit2
