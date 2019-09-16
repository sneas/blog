---
title: "On unit testing"
date: 2018-11-03T09:06:08+01:00
---

<img alt="build passing" src="./build-passing.svg">
<img alt="coverage 100%" src="./coverage-100.svg">
<img alt="the code is bug free i swear" src="./the_code_is_bug_free-i_swear.svg">

While unit testing _may_ contribute to overall product's quality and help
preventing some refactoring mistakes most organisations suffer because of unit
testing by doing it incorrectly being biased by certain beliefs and
misconceptions.

## Beliefs and misconceptions

Let's start with some beliefs and misconceptions.

### TDD is about unit testing

_TDD_ is a design process intended to improve code's quality and it's about
creating tests before writing code. Contrarily, _unit testing_ is a process of
covering existing code with tests. Unit testing does not supply overall code's
quality but _may_ lead to further refactoring of existing code.

TDD helps in creating decoupled, cohesive, and modular code. Unit testing may
contribute to code coupling and create problems for further refactoring.

[This article](https://xebia.com/blog/tdd-not-unit-tests/) explains why TDD is
not about unit testing.

### Tests prevent bugs

```javascript
// plus.js
function plus(a, b) {
  return a - b;
}

// plus.spec.js
it("should correctly add two numbers", () => {
  expect(plus(7, 5)).toBe(2);
});
```

The above code isn't bug free but it's tested.

The point is duplicating logic in different files doesn't prove the code works
correctly.

The next misconception derives from the current but it's worth listing
separately

### 100% coverage make code absolutely bug free

While previous example shows why code coverage can not guarantee code quality,
**100% coverage** misconception derives from another bias created by combination
of facts:

_our code is not fully covered_ **+** _we have bugs_ **=** _covering our code
will free us from bugs_.

It's easy to dive into this conclusion being backed up the previous belief of
_Tests prevent bugs_.

The disappointment in unit testing may arise as soon as organisation reaches the
magical 100% in code coverage but still suffers of bugs.

### Tests protect from accidental code changes

Consider the next scenario:

1. developer changed the code on purpose and unintentionally made a mistake
1. unit tests _expectedly_ failed, because code has changed
1. developer _fixed_ the failing unit test
1. PR created

What is the chance the erroneous change to be approved by another developer
during the code review? Errors defended by unit tests have better chance to be
approved. Especially if approving person also has religious beliefs about unit
testing.

## Typical mistakes

The below mistakes indicate problems with code. While the best solution might be
refactoring of existing code, the overall observation is: **your project doesn't
need that kind of tests**.

#### Expose code's internal structure

Symptoms:

- mock the response of internally-called function
- it's difficult to give the assertion proper name and most of the time one
  assertion test _everything_ `it('should work correctly', () => {})`

#### Test 3rd party libraries

Symptoms:

- insuring 3rd party library works as expected
- too many mocks, pre and post conditions

Most of the time it reveals by testing view and controller layer of the app.

#### Testing for the sake of testing

Symptom: testing of a trivial code.

#### Conditional logic in unit tests

Symptom: conditional logic in unit tests (`if`, `switch`, `while`, etc).
