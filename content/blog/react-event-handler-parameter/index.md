---
title: "An alternative way of passing parameter into event handler in React"
date: 2019-03-02T13:07:35+01:00
---

There are two popular ways of passing parameters into event handlers in React. Let have a look at them first.

## Currying

```jsx
class List extends Component {
  handleClick = (index) => (e) => {
    // Do something with index
  }

  render() {
    return (
      <ul>
        {this.props.items.map((itemText, index) => (
          <li
            key={index}
            onClick={this.handleClick(index)}
          >
            {{itemText}}
          </li>
        ))}
      </ul>
    );
  }
}
```


**Pros**

* Clean and simple syntax

**Cons**

* The solution generates a new function for each list item which increases memory consumption


## Sub components

```jsx
var List = createReactClass({
  render() {
    return (
      <ul>
        {this.props.items.map(item =>
          <ListItem key={item.id} item={item} onItemClick={this.props.onItemClick} />
        )}
      </ul>
    );
  }
});

var ListItem = createReactClass({
  render() {
    return (
      <li onClick={this._onClick}>
        ...
      </li>
    );
  },
  _onClick() {
    this.props.onItemClick(this.props.item.id);
  }
});
```

**Pros**

* Absence of bindings

**Cons**

* New class instance for every item which increases memory consumption
* Creates coupling between List and ListItem components:
    - replacing `<ul>` with another tag requires inevitable `ListItem` refactoring which complicates `ListItem` reusage
    - `ListItem` become container-dependent which limits it's reusage outside of `List`
    
It's time to discuss a perfomant alternative to above methods. Which is
    
## Parameter in tag's attribute

What if we pass parameter right into tag's attribute while rendering. And extract that param in handler?

```jsx
class List extends Component {
  handleClick = (e) => {
    const index = e.target.getAttribute('data-index');
    // Do something with index
  }

  render() {
    return (
      <ul>
        {this.props.items.map((itemText, index) => (
          <li
            key={index}
            data-index={index}
            onClick={this.handleClick}
          >
            {{ itemText }}
          </li>
        ))}
      </ul>
    );
  }
}
```

This seems reasonable. But the above solution has following limitations:

* target of event could be different if list item element contains children
* the parameter is stored in attribute as a string

It is possible to gracefully solve the first problem and limit the second one.
Please welcome [react-event-param](https://github.com/sneas/react-event-param).

The library provides an easy way to pass a callback param right into to a tag and
get it back in a callback handler:

```jsx
import React, { Component } from "react";
import { setEventParam, getEventParam } from "react-event-param";

class List extends Component {
  onItemClick = e => {
    const index = getEventParam(e.target);
    // Do something with index
  };

  render() {
    return (
      <ul>
        {this.props.items.map((itemText, index) => (
          <li
            key={index}
            {...setEventParam(index)}
            onClick={this.onItemClick}
          >
            {{ itemText }}
          </li>
        ))}
      </ul>
    );
  }
}
```

**Pros**

* No extra bindings and class instances

**Cons**

* Param gets serialized while rendering and deserialized in callback which brings certain limitations:
    - no function or class instance could be passed into attribute and successfully retrieved in event handler
    - parameter looses it's reference which is not a big deal for sacalar values, but could be misleading
        in case of objects and arrays
 
