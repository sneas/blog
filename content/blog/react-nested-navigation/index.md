---
title: "Regarding nested routes and breadcrumbs in React apps"
date: 2019-09-08T11:00:00+02:00
descriptions: "How to create React application with nested routes and breadcrumbs."
---

Demo: https://sneas.github.io/react-nested-routes-example.

Surprisingly, Google and GitHub search does not provide an
example of a React app with nested navigation and breadcrumbs.

This article is intended to fix the problem.

Our precondition would be for the application to have single source
of truth for navigation. A tree structure which will be looking similar to:


```jsx
const navigation = [
  {
    path: "/",
    label: "Home",
    routes: [
      {
        path: "/electronics",
        label: "Electronics",
        routes: [
          {
            path: "/accessories",
            label: "Accessories",
          },
          {
            path: "/headphones",
            label: "Headphones",
          }
        ]
      },
      {
        path: "/books",
        label: "Books",
        routes: [
          {
            path: "/fiction",
            label: "Fiction",
            routes: [
              {
                path: "/sci-fi",
                label: "Science Fiction",
              },
              {
                path: "/romance",
                label: "Romance",
              },
            ]
          },
          {
            path: "/fiction",
            label: "Non-fiction",
          },
        ],
      },
    ],
  },
];
```

Pages paths will be stacked in depth: `/page-1/sub-page-1/sub-sub-page-1`.

We can achieve the desired outcome with the technique of rendering routes in cycle:

```jsx 
import {Route, Router} from "react-router-dom";

const pages = [
  {
    route: '/',
    content: () => <HomePage/>
  },
  {
    route: '/about',
    content: () => <About/>
  }
];

const App = () => (
  <Router>
    {pages.map(page => <Route route={page.route} render={() => page.content}/>)}
  </Router>
);

```

Considering router does not support tree structure out of the box, we have to flatten
our nested routes structure:

```jsx
export const flattenNavigation = navigation =>
  navigation
    .map(route => [route, route.routes ? flattenNavigation(route.routes) : []])
    .flat(Infinity);
```

Also we need to recursively stack all the sub-paths together:

```jsx
export const combinePaths = (parent, child) =>
  `${parent.replace(/\/$/, "")}/${child.replace(/^\//, "")}`;

export const buildPaths = (navigation, parentPath = "") =>
  navigation.map(route => {
    const path = combinePaths(parentPath, route.path);

    return {
      ...route,
      path,
      ...(route.routes && { routes: buildPaths(route.routes, path) })
    };
  });
```

By combining `flattenRoutes` and `nestPaths` together we can render our nested
navigation structure in one go:

```jsx
const routes = flattenRoutes(nestPaths(navigation));
return (<Router>
  {routes.reverse().map((route, index) => (
    <Route
      key={index}
      path={route.path}
      render={() => rouete.content}
    ></Route>
  ))}
</Router>);
```

Now it's time for navigation and breadcrumbs.

To travers back and forth through our routes tree and render
navigation and breadcrumbs, it would be convenient to have not only
`children` for each page, but each page has to know it's parent:

```jsx
export const setupParents = (navigation, parentRoute = null) =>
  navigation.map(route => {
    const withParent = {
      ...route,
      ...(parentRoute && { parent: parentRoute })
    };

    return {
      ...withParent,
      ...(withParent.routes && {
        routes: setupParents(withParent.routes, withParent)
      })
    };
  });
``` 

Parents provided us with enough flexibility to render every page individually as standalone
component:

```jsx
const Page = ({ route }) => (
  <Fragment>
    <NestedMenu route={route} />
    {route.parent && <Breadcrumbs route={route} />}
    {route.content()}
  </Fragment>
);
```

Let's create a helper function to traverse through routes tree
from leaf to the root:

```js
export const flattenParents = route => {
  if (!route.parent) {
    return [];
  }

  return [route.parent, ...flattenParents(route.parent)].flat(Infinity);
};
```

And here is the code of nested menu component:

```jsx
const NestedMenu = ({ route }) => (
  <Fragment>
    {[...flattenParents(route).reverse(), route]
      .filter(r => r.routes)
      .map((r, index) => (
        <Menu key={index} routes={r.routes} />
      ))}
  </Fragment>
);
```

and breadcrumbs:

```jsx
const Breadcrumbs = ({ route }) => (
  <nav className="breadcrumbs">
    {[...flattenParents(route).reverse(), route].map(
      (crumb, index, breadcrumbs) => (
        <div key={index} className="item">
          {index < breadcrumbs.length - 1 && (
            <NavLink to={crumb.path}>{crumb.label}</NavLink>
          )}
          {index === breadcrumbs.length - 1 && crumb.label}
        </div>
      )
    )}
  </nav>
);
```

The final result is available here: https://github.com/sneas/react-nested-routes-example
