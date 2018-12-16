---
title: "Unit testing mistakes, beliefs and misconceptions"
date: 2018-11-03T09:06:08+01:00
lastmod: 2018-12-16T12:41:08+01:00
tags:
 - unit-testing
 - tdd
categories:
 - Unit testing
 - TDD
---
![build passing](/images/build-passing.svg)
![coverage 100%](/images/coverage-100.svg)
![the code is bug free i swear](/images/the_code_is_bug_free-i_swear.svg)

While unit testing *may* contribute to overall product's quality and help preventing some refactoring mistakes most
organisations suffer because of unit testing by doing it incorrectly being biased by certain beliefs and
misconceptions.

## Beliefs and misconceptions

Let's start with some beliefs and misconceptions. 

### TDD is about unit testing

*TDD* is a design process intended to improve code's quality and it's about creating tests before writing code.
On the other hand *unit testing* is a process of covering existing code with tests. And it doesn't supply
overall code's quality but *may* lead to further refactoring of existing code.

While TDD helps in creating decoupled, cohesive, modular code unit testing
may contribute to code coupling and create problems for further refactoring.

[This article](https://xebia.com/blog/tdd-not-unit-tests/) explains why TDD is not about unit tests.

### Tests prevent bugs

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

The above code isn't bug free but it's tested.

The point is duplicating logic in different files doesn't prove the code works correctly.

The next misconception derives from the current but it's worth listing separately

### 100% coverage make code absolutely bug free

While previous example shows why code coverage can not guarantee code quality, **100% coverage** misconception derives
from another bias created by combination of facts:

*our code is not fully covered* **+** *we have bugs* **=** *covering our code will free us from bugs*.

It's easy to dive into this conclusion being backed up the previous belief of *Tests prevent bugs*.

The disappointment in unit testing may arise as soon as organisation reaches the magical 100% in code coverage but
still suffers of bugs.

### Tests protect from accidental code changes

Consider the next scenario:

1. developer changed the code on purpose and unintentionally made a mistake
1. unit tests *expectedly* failed, because code has changed
1. developer *fixed* the failing unit test
1. PR created

What is the chance the erroneous change to be approved by another developer during the code review? Errors defended by unit tests have better chance to be approved. Especially if approving person also has religious beliefs
about unit testing.

## Typical mistakes

The below mistakes indicate problems with code. While the best solution might be refactoring of existing code, the overall
observation is: **your project doesn't need that kind of tests**.

#### Expose code's internal structure

Symptoms:

* mock the response of internally-called function
* it's difficult to give the assertion proper name and most of the time one assertion test *everything*
`it('should work correctly', () => {})`

#### Test 3rd party libraries

Symptoms:

* insuring 3rd party library works as expected
* too many mocks, pre and post conditions

Most of the time it reveals by testing view and controller layer of the app.

#### Testing for the sake of testing

Symptom: test simple code.

#### Conditional logic in unit tests

Symptom: conditional logic in unit tests (`if`, `switch`, `while`, etc).
