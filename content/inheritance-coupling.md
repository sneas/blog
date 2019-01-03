---
title: "Inheritance as a tightest form of coupling"
date: 2018-12-17T09:21:00+01:00
lastmod: 2018-12-17T09:21:00+01:00
tags:
 - oop
 - design
 - inheritance
categories:
 - OOP
 - Design
draft: true
---
<blockquote class="blockquote text-right">
  <p class="mb-0">Favor object composition over class inheritance.</p>
  <footer class="blockquote-footer">Gang of Four in <cite title="Design Patterns: Elements of Reusable Object-Oriented Software">Design Patterns: Elements of Reusable Object-Oriented Software</cite></footer>
</blockquote>

[GoF](http://wiki.c2.com/?GangOfFour) stated this over two decades ago.
Some warmly accepted languages (Go, Rust) refused of inheritance at all.
But it seems many developers haven't gotten it and still do inheritance to share code between classes.
The code looks professional and elaborated at the first glance.
But evolves into a chimera in no time.

We try to design our code to be future proof. Flexible. Ready for unpredictable changes. We want to blame business
with it's capricious requirements standing on the way of the perfect system based on our perfectly-crafted `BaseSolver` class.

And again and again our `AbstractWorker` turns into something we would like to burn... and build a new, better `BaseAbstractWorker`.

Here is the diagram showing the way it normally starts

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
There a multiple ways of providing this but none of them are semantically correct.



