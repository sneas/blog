---
title: "Some unit testing mistakes and religious beliefs"
date: 2018-11-03T09:06:08+01:00
lastmod: 2018-11-03T09:06:08+01:00
draft: true
---
![build passing](/images/build-passing.svg)
![coverage 100%](/images/coverage-100.svg)
![the code is bug free i swear](/images/the_code_is_bug_free-i_swear.svg)

I made a small scientific research with the query "why my unit  tests suck" and found this interesting document:
[Why Most Unit Testing is Waste](https://rbcs-us.com/documents/Why-Most-Unit-Testing-is-Waste.pdf). It's worth reading.


## Tests prevent bugs

```javascript
// plus.js
function plus(a, b) {
  return a - b;
}

// plus.spec.js
it('should correctly add two numbers', () => {
  expect(plus(7, 5)).toBe(2);
})
```

Is this code bug free?

Duplicating logic in different files doesn't prove anything.

## Tests protect from accidental code changes

Consider the next scenario:

1. developer changed the code on purpose and unintentionally made a mistake
1. unit tests *expectedly* failed, because code has changed
1. developer *fixed* the failing unit test
1. PR created

What is the chance the erroneous change to be approved by another developer during the code review? I'd say errors
backed up by unit tests have better chance to be approved. Especially if approving person also has religious beliefs
about unit testing. 
