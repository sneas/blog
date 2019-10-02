---
title: "About OOP without classes in JS/TS"
date: 2019-09-19T10:00:00+02:00
descriptions: "We don't need classes in JS/TS and this articles explains why"
---

This is a controversial topic describing how to OOP without classes. It's easier
than it looks like and provides some benefits while keeping benefits of OOP.

First, let's answer the question **what is a class?** In OOP, class is a
blueprint for creating objects. Providing initial values and behaviours.

Let's think a bit what benefits do we get by baking data and methods together?

Gorilla-banana problem.

When we want to reuse a method we get class with all the methods values.

We can overcome gorilla-banana problem by separating classes to JSON data
structures and functions:

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

function getFulleName(person: Person) {
  return `${person.firstName} ${person.lastName}`;
}
```

This gives us opportunity to use `getFullName()` method on any object with
`firstName` and `lastName` properties.

The other problem of classes: they provide solid base for the Single
Responsibility principle violation.

It is too tempting to add extra methods to a class.

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

The other benefit of preferring JSON data-objects over classes is the ability to
serialize/deserialize them whenever needed:

```typescript
const person = {
  firstName: "John",
  lastName: "Doe",
};

localStorage.setItem("person", JSON.stringify(person));

// Later on:

getFullName(JSON.parse(localStorage.getItem("person")));
```

It's not possible to do the same with classes.

## Inheritance

The most popular use-case for classes is, obviously, inheritance. We do
inheritance to share methods/data structures between classes.

The good news we don't need inheritance while using functions and JSON data
structures.

```typescript
interface Person {
  firstName: string;
  lastName: string;
}

function getFullName(person: Person): string {
  return `${person.firstName} ${person.lastName}`;
}
```

We don't have to create extra abstractions in order to use `Person` structure or
`getFullName()` method.
