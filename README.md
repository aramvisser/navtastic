# Navtastic

[![Build Status](https://img.shields.io/circleci/project/github/aramvisser/navtastic.svg)](https://circleci.com/gh/aramvisser/navtastic)
[![Code Coverage](https://img.shields.io/codeclimate/coverage/github/aramvisser/navtastic.svg)](https://codeclimate.com/github/aramvisser/navtastic)
[![Inline docs](https://inch-ci.org/github/aramvisser/navtastic.svg?branch=master)](https://inch-ci.org/github/aramvisser/navtastic)
[![MIT License](https://img.shields.io/github/license/aramvisser/navtastic.svg)](https://github.com/aramvisser/navtastic/blob/master/LICENSE)

Navtastic is way to create and render complex navigation menus. It allows for runtime configurations
of menus.

- Keep menu content and rendering logic separate
- Automatically highlight the item for the current page

## Table of Contents

- [Installation](#installation)
- [Example](#example)
- [Usage](#usage)

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

Using the default renderer, assuming that `/posts` is the current url, will result in:

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

## Usage

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
