# Release Note for 0.5

## New features

### ZQL Language Core

1. New "word" (Do). This word will take "callable" as a first argument of the function, call this function passing the rest of the arguments and keyword parameters and push the result into a stack

Example query:
```bash
(ZBX) (Do Time.time) (Out)
```
This query will push the timestamp into a stack.

2. Python module "time" exposed to ZQL under namespace "Time"

Example query:
```bash
(ZBX) (Setv "tsigel" (Time.time)) (Getv "tsigel")
```
This query will store current timestamp in the global variable "tsigel" which you can query with (Getv)

3. generators for the (Loop) "word" are exposed into a "loop" namespace in the globals

* loop.Range - generating sequences within the range. First parameter - start, second - stop, third - step.
Example query:
```bash
(ZBX) (Do loop.Range 1 20 3 ) (Out)
```
will return: [1, 4, 7, 10, 13, 16, 19]
* loop.UUID - generating secuence of uuid4 strings. Parameter - number of UUID's
```bash
(ZBX) (Do loop.UUID 10 ) (Out)
```

* loop.IP4NET - generating sequence of IP adresses from the network. Parameter - IPv4 network address
Example query:
```bash
(ZBX) (Do loop.IP4NET "10.0.1.0/28" ) (Out)
```
Will generate list of the addresses from 10.0.1.0/28 skipping network and broadcast IP's


## Updated features

### ZQL Language Core

1. (Getv ....) accepts a keyword parameters.
2. (Getv ....) changes the behaviour:
* By default or if you pass (Getv ... :keep False), (Getv) "word" will remove variable. In essentiality, one (Setv) is one (Getv)
* If you want to change that behaviour, you must pass keyword parameter (Getv ... :keep True)


## Removed features
