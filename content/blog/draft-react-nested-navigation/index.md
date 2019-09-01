---
title: "About nested routes and breadcrumbs in React apps"
date: 2019-09-01T11:00:00+02:00
descriptions: "How to create React application with nested routes and breadcrumbs."
---

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

