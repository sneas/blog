---
title: "The problem with class inheritance"
date: 2019-01-03T09:21:00+01:00
lastmod: 2019-01-03T09:21:00+01:00
tags:
 - oop
 - design
 - inheritance
categories:
 - OOP
 - Design
---
<blockquote class="blockquote text-right">
  <p class="mb-0">Favor object composition over class inheritance.</p>
  <footer class="blockquote-footer">Gang of Four in <cite title="Design Patterns: Elements of Reusable Object-Oriented Software">Design Patterns: Elements of Reusable Object-Oriented Software</cite></footer>
</blockquote>

[GoF](http://wiki.c2.com/?GangOfFour) stated this over two decades ago.
Some warmly accepted languages (Go, Rust) refused of inheritance at all.
But it seems many developers haven't gotten the problem and still do inheritance to share code between classes.
The code looks advanced at the first glance.
But evolves into a chimera in no time.

The intention of code's design is to be future proof and flexible. Ready for unpredictable changes. And inheritance in combination with changing business
requirements stand on the way of the perfect system based on our perfectly-crafted `BaseSolver` class.

Here is the diagram showing the beginning of disaster:

<figure class="figure">
    <img class="figure-img" src="/images/inheritance/base-class.png" alt="The class diagram showing keeping common methods in Base class" width="600" />
    <figcaption class="figure-caption text-center">Figure 1. Sharing common methods in base class.</figcaption>
</figure>

It looks good and nice: 2 instances. Similar in essence. Different in implementation. Share some base class' methods.

The other day business decides to add the 3rd instance. And it needs only half of our `BaseSolver`'s methods.
"No problem" we say and create another `VeryBaseSolver` with only half of methods implemented:


<figure class="figure">
    <img class="figure-img" src="/images/inheritance/very-base-class.png" alt="The class diagram showing creating VeryBase class out of the necessity to borrow couple of methods from Base class" width="800" />
    <figcaption class="figure-caption text-center">Figure 2. Establishing a new base class.</figcaption>
</figure>

But something smells in this design. It doesn't look that good anymore.
Shit hits the fan as soon as business needs a `ConcreteSolver4` with `method1` and `method2`.
There are multiple ways of providing this but none of them are semantically correct.



