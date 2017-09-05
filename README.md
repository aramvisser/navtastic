# Navtastic

[![Build Status](https://img.shields.io/circleci/project/github/aramvisser/navtastic.svg)](https://circleci.com/gh/aramvisser/navtastic)
[![Code Coverage](https://img.shields.io/codeclimate/coverage/github/aramvisser/navtastic.svg)](https://codeclimate.com/github/aramvisser/navtastic)
[![Inline docs](https://inch-ci.org/github/aramvisser/navtastic.svg?branch=master)](https://inch-ci.org/github/aramvisser/navtastic)
[![Gem](https://img.shields.io/gem/v/navtastic.svg)](https://rubygems.org/gems/navtastic)
[![MIT License](https://img.shields.io/github/license/aramvisser/navtastic.svg)](https://github.com/aramvisser/navtastic/blob/master/LICENSE)

Navtastic is way to create and display complex navigation menus for websites. It allows for runtime
configurations of menus, depending on context.

- Keep menu content and rendering logic separate
- Automatically highlight the current page
- Different output structures supported (Simple, Bootstrap4, Bulma, Foundation6)
  - HTML structure only, bring your own CSS.
- Easily create your own renderer to fit your style.

_The current renderers only support vertical menus. Horizontal (navbar) menus are planned._

## Table of Contents

- [Installation](#installation)
- [Example](#example)
- [Documentation](#documentation)
  - [Submenus](#submenus)
  - [Current item](#current-item)
  - [Custom classes](#custom-classes)
  - [Runtime parameters](#runtime-parameters)
  - [Global Configuration](#global-configuration)
  - [Menu Configuration](#menu-configuration)
  - [Item Configuration](#item-configuration)
  - [Renderers](#renderers)
- [Development](#development)

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

Define a menu somewhere:

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

### Submenus

Every item can have a submenu. They can be nested as deeply as you want.

```ruby
Navtastic.define :main_menu do |menu|
  menu.item "Home", '/' do |submenu|
    submenu.item "Posts", '/posts'
    submenu.item "About", '/about'
  end

  menu.item "Settings" do |submenu|
    submenu.item "General", '/settings'
    submenu.item "Profile", '/settings/profile'
  end
end
```

By default, submenus will be rendered inside the `<li>` tag of the parent item.

```html
<ul>
  <li>
    <a href="/">Parent</a>
    <ul>
      <li>
        <a href="/child">Child</a>
      </li>
    </ul>
  </li>
</ul>
```

### Current item

The current active item is decided by the `current_url` parameter when rendering a menu. It is the
item with the longest url that starts with the current_url.

For example, if there is a menu containing these urls:

- `/`
- `/posts`
- `/posts/featured`

If the current_url is `/posts/featured/2017`, the `/posts/featured` item will be highlighted. If the
current_url is `/posts/123`, then `/posts` is highlighted.

The root url `/` will always match, if no other items match the current url. If there is no item
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

### Global Configuration

Some global settings that Navtastic uses can be configured. Make sure the configuration happens
before defining any menu (e.g. when using rails, add it to `config/initializers/navtastic.rb`).

These are the defaults values:

```ruby
Navtastic.configure do |config|
  # This url to prepend before every item url
  config.base_url = nil

  # Set the renderer to use, can be one of :simple, :bootstrap4, :bulma, :foundation6
  # Can also be a class if you want to use a custom renderer
  config.renderer = :simple

  # Options that are passed to the renderer
  config.renderer_options = {}
end
```

### Menu Configuration

Each individual menu can also be configured in some way:

```ruby
Navtastic.define :user_menu do |menu, params|
  # The url to put before every item
  menu.config.base_url = '/users/' + params[:user_id]

  menu.item "Profile", '/profile' # will link to: /users/123/profile
end
```

### Item Configuration

Every item can have options passed to it:

```ruby
Navtastic.define :menu do |menu|
  # Add a css class to the container (e.g. <li> tag)
  menu.item "Home", "/", class: 'highlight'

  # Add a css class the content inside the container (e.g. <a> tag)
  menu.item "Posts", "/posts", content_class: 'important'

  # If `root` is true, this item will ignore any base urls
  menu.item "Somewhere", '/', root: true
end
```

### Renderers

The following renders are currently available:

- **Simple** adds a `current` class to the basic list structure
- **Bootstrap4** is used with the [Bootstrap 4](https://getbootstrap.com) framework.
- **Bulma** is used with the [Bulma.io](http://bulma.io) framework.
- **Foundation6** is used with the [Foundation 6](http://foundation.zurb.com/sites.html) framework.

Some renderers also support extra options. You can set them globally in the configuration or pass
them at runtime when rendering a menu:

```ruby
# Global options
Navtastic.configure do |config|
  config.renderer_options = { option: value }
end
```

```erb
# Runtime options
<%= Navtastic.render :menu, current_url, renderer: { option: value } %>
```

Globally defined options and options given at runtime are merged together, with those at runtime
taking precedence.

#### Bulma Configuration

- **headers** (default: `false`)

  Top level items are styled differently. Works best if they are only text, not
  links.

  <div align="center">
    <figure>
      <img src="docs/bulma_headers_preview.png"><br>
      <figcaption>left: <code>headers: false</code>, right: <code>headers: true</code></legend>
    </figure>
  </div>

#### Foundation Configuration

- **active_class** (default: `nil`)

  CSS class to use for active items. Active items are items that have a child that is the current
  item. Useful to highlight the current item in a drilldown menu.

- **style** (default: `nil`)

  Set to `:drilldown` to generate [a drilldown
  menu](http://foundation.zurb.com/sites/docs/drilldown-menu.html). Make sure you include the
  required javascript files.

  <div align="center">
    <figure>
      <img src="docs/foundation_styles_preview.png"><br>
      <figcaption>left: default style, right: drilldown style</figcaption>
    </figure>
  </div>

## Development

1. Checkout Repository: `git clone https://github.com/aramvisser/navtastic.git`
2. Install Bundler: `gem install bundler`
3. Run `bundle install` inside the project root to install the gem dependencies
4. Run test cases: `bundle exec rake`

For testing visual changes, a test server is provided by running `bundle exec rake demo`. It's
accessibly on http://localhost:9090.

