---
title: "Inheritance as a form of tightest coupling"
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

Gof stated this 100 years ago but it seems like most of people haven't gotten it and still
do inheritance to share code. It leads to troubles. The code looks good and perfect at the first glance.
But evolves into a chimera within no time.

Some warmly accepted frameworks (Spring) and languages (Go) refused of inheritance at all.
And most of us still doing this because it makes our code to look more professional and elaborated.

We try to design our code to be future proof. Flexible. Ready for unpredictable changes. We want to blame business
with it's capricious requirements standing on the way of the perfect system based on our perfectly-crafted `BaseResolver` class.

And again and again our `AbstractWorker` turns into something we would like to burn... and build on it's ashes a new, better `BaseAbstractWorker`.

# How it works

Here is the diagram showing the way it usually starts

-- diagram goes here --

It looks good and nice: 2 instances. Similar in essence. Different in implementation. Share some methods.

The other day business decides to add the 3rd instance. And it needs only half of our `BaseSolver`'s methods.
"No problem" we say and create another `SuperBaseSolver` with only half of methods implemented:

-- another diagram goes here --

The next day shit hits the fan. Stupid business needs half of `SuperBasicSolver` and half of `BasicSolver`.
"Okay", we say. We create `StupidBasicSolver extends SuperBasicSolver` and copy and paste missing methods from `BasicSolver`.
And `// Todo: Refactor this`.


