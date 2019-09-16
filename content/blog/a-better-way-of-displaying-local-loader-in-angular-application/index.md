---
title: "A better way of displaying local loader in Angular application"
date: 2018-12-12T16:16:23+01:00
description: How to show and hide loader automatically.
---

## Not so good

```typescript
displayLoader("Loading...");
this.productsService.getAll().pipe(finalize(() => hideLoader()));
```

You've probably seen the above construct in your project. I've been doing the
same either. This way doesn't look correct to me. Indeed this way of displaying
and hiding loaders produces so-called _temporal coupling_ by separating
display/hide actions and welding hide together with service function making it
impossible to call `this.productsService.getAll()` without preliminary calling
`displayLoader('loading')`.

The problem turns obvious as soon as the necessity of reusing
`this.productsService.getAll()` method in component emerges and we inevitably
wrap the call into separate function:

```typescript
public getAllProducts() {
  displayLoader('Loading...');
  this.productsService.getAll()
      .pipe(
          finalize(() => hideLoader())
      ).subscribe((products) => {
        this.products = products;
      });
}
```

One more drawback of this method is inability of using it with `async` pipe and
inevitably forcing developers to manage subscriptions manually.

## The better

The better way would be to automatically display loader on every subscription.
Unfortunately RxJS does not provide a ready-to-use operator for this.

That's why we're going to create our own `doOnSubscribe` pipe operator:

```typescript
// do-on-subscribe.operator.ts

import { defer, Observable } from "rxjs";

export const doOnSubscribe = (onSubscribe: () => void) => <T>(
  source: Observable<T>
) =>
  defer(() => {
    onSubscribe();
    return source;
  });
```

After `doOnSubscribe` operator is ready we can use it on HttpClient observables:

```typescript
this.allProducts$ = this.productsService.getAll().pipe(
  doOnSubscribe(() => displayLoader("Loading...")),
  finalize(() => hideLoader())
);
```

The above method guaranties loader would be properly displayed and hidden on
every subscription. The newly created "pure" observable could be used with
`async` pipe or in combination with other observables:

```html
<div *ngFor="let product of allProducts$ | async">
  {{ product.name }}
</div>
```
