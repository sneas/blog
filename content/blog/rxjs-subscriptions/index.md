---
title: "On RxJS subscriptions"
date: 2019-09-15T10:00:00+02:00
descriptions: "Something developer should understand about RxJS' subscriptions before building the first Angular app."
---

Here is the list of RxJS' `subscribe` method facts a developer should be aware of to build
a robust Angular app.

- Subscription is a way to run observable. We can think of observable as a recipe. And `subscribe`
  as a way to execute the recipe. In other words, we can see observable as a function definition
  and `subscribe` as a function invocation:

```js
// The line below does not produce HTTP request
const observable = this.httpClient.get("https://api.github.com/users");

// Do request:
observable.subscribe(users => console.log(users));
```

- Every time we call `subscribe`, we execute observable:

```js
const observable = this.httpClient.get("https://api.github.com/users");

// Do request:
observable.subscribe();
// Do request one more time (simultaneously):
observable.subscribe();
```

- We can use `share` operator to prevent multiple executions:

```js
const observable = this.httpClient
  .get("https://api.github.com/users")
  .pipe(share());

// Do request:
observable.subscribe(users => {
  this.users = users;
});
// Use result of the previous request:
observable.subscribe(users => console.log(users));
```

- `pipe` function "wraps" an observable into another observable and returns a new observable.
  `pipe` is an immutable operation. It does not change existing observable.

```js
const observable = this.httpClient.get("https://api.github.com/users");
const observableWithTap = observable.pipe(tap(console.log));

// Does request:
observable.subscribe();

// Does request and outputs data in console:
observableWithTap.subscribe();
```

- Manual unsubscription is required when calling subscribe in component.

Omitting unsubscription could be a cause of memory leaks.

Most of the time RxJS 'forgives' us for omitting unsubscription. Because an observer completes
automatically after the first emission. But it's not always the case and there is no way
to tell whether observer will be completed after the first emission or not. Especially if the observer's
creation has been encapsulated in a service.

The below example illustrates the problem:

```typescript
// user.service.ts
export interface User {
  id: number;
  login: string;
}

@Injectable({ providedIn: "root" })
export class UserService {
  constructor(private httpClient: HttpClient) {}

  // The function returns "never-ending" observable:
  getUsers(): Observable<User[]> {
    // Poll for users every 5 seconds.
    return interval(5000).pipe(
      startWith(0),
      switchMap(() =>
        this.httpClient.get<User[]>("https://api.github.com/users")
      )
    );
  }
}

//my.component.ts
@Component({
  selector: "my-component",
  template: `
    <div *ngFor="let user of users">{{ user.login }}</div>
  `,
})
export class MyComponent {
  private users: User[];

  constructor(usersService: UserService) {
    // We've just subscribed for never-ending observable.
    // The component is going to listen to this subscription even after destroy.
    usersService.getUsers().subscribe(users => (this.users = users));
  }
}
```

We have to unsubscribe manually to fix the problem:

```typescript
import { Subscription } from "rxjs";

@Component({
  selector: "my-component",
  template: `
    <div *ngFor="let user of users">{{ user.login }}</div>
  `,
})
export class MyComponent implements OnDestroy {
  private users: User[];

  private usersSubscription: Subscription;

  constructor(usersService: UserService) {
    this.usersSubscription = usersService
      .getUsers()
      .subscribe(users => (this.users = users));
  }

  ngOnDestroy() {
    this.usersSubscription.unsubscribe();
  }
}
```

Or we can use `async` pipe and and Angular will manage the subscription automatically and
unsubscribe whenever needed:

```typescript
@Component({
  selector: "my-component",
  template: `
    <div *ngFor="let user of users$ | async">{{ user.login }}</div>
  `,
})
export class MyComponent {
  public users$ = this.usersService.getUser();

  constructor(private usersService: UserService) {}
}
```

We can also automate observable completion process. This could be useful in case of
multiple subscriptions in one component:

```typescript
import { Subject } from "rxjs";
import { takeUntil } from "rxjs/operators";

export class MyComponent implements OnDestroy {
  public someData: any;
  public someOtherData: any;

  private hasDestroyed$ = new Subject();

  constructor(someService: SomeService, someOtherService: SomeOtherService) {
    // The first subscription
    someService
      .getSomeData()
      .pipe(takeUntil(this.hasDestroyed$))
      .subscribe(data => (this.someData = data));

    // The second subscription
    someOtherService
      .getSomeOtherData()
      .pipe(takeUntil(this.hasDestroyed$))
      .subscribe(data => (this.someOtherData = data));
  }

  ngOnDestroy() {
    this.hasDestroyed$.next();
    this.hasDestroyed$.complete();
  }
}
```

Hopefully, this information will shed some light on dealing with subscriptions help in building
memory-efficient Angular applications.
