asserts
=======

This directory contains assertions that users may want to use in their unit
tests. All assertions come in two flavors an affirmative assert and a negative
assert. For example:

```
ct_assert_defined(AN_IDENTIFIER)       # Fails if AN_IDENTIFIER is not defined
ct_assert_not_defined(AN_IDENTIFIER)   # Fails if AN_IDENTIFIER is defined
```

Assertion Summaries:

- `asserts.cmake` : Convenience header for including all assertions
- `defined.cmake` : Determines if a variable is defined
- `equal.cmake` : Assertions for comparing values
- `list.cmake` : Determines if an identifier contains a list
- `string.cmake` : Asserts that an identifier contains a string
