---
title: "About OOP without classes in JS/TS"
date: 2019-09-19T10:00:00+02:00
descriptions: "We don't need classes in JS/TS and this articles explains why"
---

This is a controversial topic describing how to OOP without classes. It's easier
than it looks like and provides some benefits while keeping benefits of OOP.

First, let's answer the question **what is a class?** In OOP, class is a
blueprint for creating objects. Providing initial values and behaviours.

Let's think a bit what benefits do we get while baking data and methods
together?

Gorilla-banana problem.

When we want to reuse a method we get get class with all the methods values.

We can overcome gorilla-banana problem by preferring objects over classes:

```typescript
class Person {
  public firstName: string;
  public lastName: string;

  getFullName() {
    return `${this.firstName} ${this.lastName}`;
  }
}
```

The above class could be converted to:

```typescript
interface Person {
  firstName: string;
  lastName: string;
}

function getFulleName(p: Person) {
  return `${p.firstName} ${p.lastName}`;
}
```

This gives us opportunity to use `getFullName()` method on any object with
`firstName` and `lastName` properties.

The other problem of classes: they provide solid base for the Single
Responsibility principle violation.

It is too darn tempting to add extra to the class.

```typescript
class Person {
  public firstName: string;
  public lastName: string;

  getFullName() {
    return `${this.firstName} ${this.lastName}`;
  }

  greeting() {
    return `Hello ${this.firstName}!`;
  }
}
```

Interfaces (or plain objects)

The other benefit of preferring JSON data-objects over classes is the ability to
serialize/deserialize.
