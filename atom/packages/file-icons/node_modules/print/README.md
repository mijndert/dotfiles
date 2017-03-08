Print
=====

Generate a human-readable representation of a value. Focussed on producing clean
and *accurate* depictions of data. Suitable for debugging and generating diffs.


Usage
-----

```js
const print = require("print");
let output = print({
    foo: "bar",
    baz: "quux",
    list: [1, 2, 3, 4, "five"]
});
console.log(output);

print.out(obj); // Shortcut for console.log(print(obj));
```


### Comparison with built-in functions
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
print                JSON.stringify          util.inspect

{                    {                       { foo: 'bar',
    baz: "quux"          "foo": "bar",         baz: 'quux',
    foo: "bar"           "baz": "quux",        list:
    list: [              "list": [             [ 1,
        1                    1,                  2,
        2                    2,                  3,
        3                    3,                  4,
        4                    4,                  'five' ] }
        "five"               "five"
    ]                    ]
}                    }
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

`print` also handles circular references by showing a `->` pointing to where the
object was first mentioned. For example, the following code:

```js
const A = {};
const B = {foo: A};
print({A, B});
```

Will produce:
~~~
{
    A: {}
    B: {
        foo: -> A
    }
}
~~~



Options
-------
An optional second parameter can be passed to refine `print`'s output.

Available options and their default values are listed below:

```js
print(input, {
    ampedSymbols:     true,
    escapeChars:      /(?!\x20)\s|\\/g,
    maxArrayLength:   100,
    showArrayIndices: false,
    showArrayLength:  false,
    sortProps:        true
});
```


### ampedSymbols
[Boolean]  
Prefix [Symbol]-keyed properties with `@@`. Disable to show `Symbol(…)` instead.



### escapeChars
[RegExp] | [Function]  
What characters, if any, are escaped in string values.

By default, anything that alters the output's meaning or layout is escaped:

    \f \n \r \t \v \\

This can be overridden with a custom expression or callback, the latter of which
receives the entire string as an argument.

Passing falsey values to `escapeChars` disables escaping altogether, which isn't
recommended if your input contains line-breaks or tabulation.



### maxArrayLength
[Number]  
Maximum number of array values to show before truncating them:

~~~
[
    1
    2
    3

    … 7 more values not shown
]
~~~

Note this excludes any named properties stored on the Array object:

```js
const input = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
input.foo = "bar";
print(input, { maxArrayLength: 3 })
```

~~~
[
    1
    2
    3
	
    … 7 more values not shown

    foo: "bar"
]
~~~



### showArrayIndices
[Boolean]  
Show the index of each element in an array.

~~~
[                  [
    "A"                0: "A"
    "B"      ->        1: "B"
    "C"                2: "C"
]                  ]
~~~


### showArrayLength
[Boolean]  
Display an array's `length` property after its values:

~~~
[
    "A"
    "B"
    "C"
    length: 3
]
~~~


### sortProps
[Boolean]  
Alphabetise the enumerable properties of printed objects.

To display properties in the order they were enumerated, set this to `false`.

Note that alphabetisation is case-insensitive.



[Referenced links]: ____________________________________________________________
[Boolean]:   http://mdn.io/JavaScript/Reference/Global_Objects/Boolean
[Function]:  http://mdn.io/JavaScript/Reference/Global_Objects/Function
[Number]:    http://mdn.io/JavaScript/Reference/Global_Objects/Number
[RegExp]:    http://mdn.io/JavaScript/Reference/Global_Objects/RegExp
[Symbol]:    http://mdn.io/JavaScript/Reference/Global_Objects/Symbol
