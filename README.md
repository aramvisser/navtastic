# Navtastic

[![Build Status](https://img.shields.io/circleci/project/github/aramvisser/navtastic.svg)](https://circleci.com/gh/aramvisser/navtastic)
[![Code Coverage](https://img.shields.io/codeclimate/coverage/github/aramvisser/navtastic.svg)](https://codeclimate.com/github/aramvisser/navtastic)
[![Inline docs](https://inch-ci.org/github/aramvisser/navtastic.svg?branch=master)](https://inch-ci.org/github/aramvisser/navtastic)
[![MIT License](https://img.shields.io/github/license/aramvisser/navtastic.svg)](https://github.com/aramvisser/navtastic/blob/master/LICENSE)

Navtastic is way to create and render complex navigation menus. It allows for runtime configurations
of menus.

- Keep menu content and rendering logic separate
- Automatically highlight the current page

## Table of Contents

- [Installation](#installation)
- [Example](#example)
- [Documentation](#documentation)
  - [Current item](#current-item)
  - [Runtime parameters](#runtime-parameters)

## Installation

Add it to your Gemfile:

```ruby
gem 'navtastic'
```

Run the following command to install it:

```console
bundle install
```

## Example

Define a menu somwhere:

```ruby
Navtastic.define :main_menu do |menu|
  menu.item "Home", '/'
  menu.item "Posts", '/posts'
  menu.item "About", '/about'
end
```

Render it in your partials:

```erb
<%= Navtastic.render :main_menu, current_url %>
```

Using the default renderer, assuming that the current url starts with `/posts`, will result in:

```html
<ul>
  <li>
    <a href="/">Home</a>
  </li>
  <li class="current">
    <a href="/posts">Posts</a>
  </li>
  <li>
    <a href="/about">About</a>
  </li>
</ul>
```

## Documentation

### Current item

The current active item is decided by the `current_url` parameter when rendering a menu. It is the
item with the longest url that starts with the current_url.

For example, if there is a menu containing these urls:

- `/`
- `/posts`
- `/posts/featured`

If the current_url is `/posts/featured/2017`, the `/posts/featured` item will be highlighted. If the
current_url is `/posts/123`, then `/posts` is highlighted.

The root url `/` will always match, if no other items match the current _url. If there is no item
with `/` as url in the menu and no other urls match, nothing will be highlighted.

### Runtime parameters

You can pass runtime parameters when defining a menu. For example, passing the current user and
change the menu accordingly.

```ruby
# Define the menu
Navtastic.define :main_menu do |menu, params|
  menu.item "Home", "/"

  if params[:current_user]
    menu.item "Profile", "/users/#{params[:current_user].id}"
    menu.item "Logout", "/logout"
  else
    menu.item "Login", "/login"
  end
end

# Render it with the current user as a parameter
Navtastic.render :main_menu, current_url, current_user: User.current
```
