---
title: "Angular and RxJS mistakes"
date: 2019-05-21T10:15:19+02:00
lastmod: 2019-05-21T10:15:19+02:00
tags:
 - angular
 - rxjs
categories:
 - Angular
 - RxJS
draft: true
---
Here is a list of popular Angular mistakes.


* Too complex components
* Global app state in services
* Unsubscribing
* Avoiding observables


## Too complex components

TBD

## Global app state in services

#### Situation

Let's say we would like to load an app-related data on the application start.
And later on we plan to use the loaded data across the application. A straightforward
solution would be to create a special service for this.

```typescript
@Injectable({ providedIn: 'root' })
export class ApplicationState {
    public data: Data;
    
    constructor(private http: HttpClient) {}

    loadData() {
        this.http.get<Data>('/app-data')
            .subscribe((data) => {
                this.data = data;
            });
    }
}
```

Thus we do `this.applicationState.loadData()` somewhere in, let's say,
[APP_INITIALIZER](https://www.intertech.com/Blog/angular-4-tutorial-run-code-during-app-initialization/).
And later on we refer to the data somewhere in the code
as `const specificParam = this.applicationState.data.param`.

This approach looks simple, but it has drawbacks which would be revealed during
the application's lifetime.

#### Problem

Utilizing global variables considers to be a bad practice in any programming
language. And `applicationState.data` is a **global variable** by it's nature.
