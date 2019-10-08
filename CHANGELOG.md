## Changelog

### v0.3.0

Add find by num_code to Moeda module.

### v0.2.1

Refactoring for better understanding and compliance to the ISO 4217 standard.

### v0.2.0

Implementation of the methods sum/1 and sum!/1.

### v0.1.9

Refactoring to raising exceptions with no trailing punctuation to suit the Elixir conventions.

### v0.1.8

Implementation of the method is_dinheiro?/1.

Implementation of `build` and `build_travis` tasks.

Refactoring of `.travis.yml` to run `build_travis` task.

Adding `CHANGELOG.md` on `:ex_dinheiro` documentation.

### v0.1.7

Update of the documentation and more test cases added.

Refactoring to suit the Elixir conventions.

Changed self-references to __MODULE__.

Returns changed to `{:ok, result}` and `{:error, reason}` in `Dinheiro` module:
 - compare/2
 - divide/2
 - multiply/2
 - new/1
 - new/2
 - subtract/2
 - sum/2
 - to_float/1
 - to_string/2

Functions that returns the unwrapped `result` or raises an error in `Dinheiro` module.
- compare!/2
- divide!/2
- multiply!/2
- new!/1
- new!/2
- subtract!/2
- sum!/2
- to_float!/1
- to_string!/2

Returns changed to `{:ok, result}` and `{:error, reason}` in `Moeda` module:
- find/1
- get_atom/1
- get_factor/1
- to_string/3

Functions that returns the unwrapped `result` or raises an error in `Moeda` module.
- find!/1
- get_atom!/1
- get_factor!/1
- to_string!/3

### v0.1.6

Refector of the code:
 - Creation of a bag of currencies `Moeda.Moedas` to separate the logic to manipulate currencies of the repository of them.
 - Change the lines length to 80 in `.formatter.exs` to compliance with credo.

Update of documentation:
 - Adding more exemples.
 - Adding badge of Travis.CI.
 - Adding badge of Coveralls.IO.

### v0.1.5

New feactures to permit:
 - Compliance with ISO 4217.
 - To work with no official ISO currency code adding it in the system Mix config.
 - To override some official ISO currency code adding it in the system Mix config.

Implementation of the method equals?/2.

### v0.1.4

Implementation of the wrapper method to_string/2.

Refactor of the method to_float/1.

### v0.1.3

Implementation of the method to_string/3.

Refactor to normalize the code to de credo patterns.

### v0.1.2

Implementation of the methods:
 - compare/2
 - divide/2
 - multiply/2
 - new/1
 - new/2
 - subtract/2
 - sum/2
 - to_float/1

### v0.1.1

Configuration of Continuous Integration, Delivery, and Deployment.

### v0.1.0

Library creation.
