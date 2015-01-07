import "joelpurra/jq-object-sorting" as ObjectSorting;


# Create a new key counter object.
# Yes, it's as simple as an empty object.
def create:
	{};


# Increment a single key by a certain count.
def incrementBy(obj; value):
	obj as $obj
	| value as $value
	| .[$obj] = ((.[$obj] // 0) + $value);

def increment(obj):
	obj as $obj
	| incrementBy($obj; 1);

def decrement(obj):
	obj as $obj
	| incrementBy($obj; -1);


# Add two key counter objects together.
# Keys that exist in both have their counts added.
# Keys that exist in only one of the objects are kept.
def add(obj):
	. as $keyCounterObject
	| obj
	| to_entries
	| reduce .[] as $item
	(
		$keyCounterObject;
		incrementBy($item.key; $item.value)
	);


# Use the values in an array as keys to increment.
def incrementByArray(arr):
	. as $keyCounterObject
	| arr as $arr
	| reduce $arr[] as $item
	(
		$keyCounterObject;
		increment($item)
	);


# Get values with a minimum count.
def minimum(n):
	n as $n
	| with_entries(
		select(.value >= $n)
	);

def minimumTwo:
	minimum(2);


# Get top counts.
def top(n):
	n as $n
	# TODO: Use a stable primarily value (desc), secondarily key (asc) sort.
	| ObjectSorting::byValueDesc
	| to_entries
	| .[0:$n]
	| from_entries;

def topTen:
	top(10);
