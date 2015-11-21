# [![Sean Huber](https://cloud.githubusercontent.com/assets/2419/6550752/832d9a64-c5ea-11e4-9717-6f9aa6e023b5.png)](https://github.com/shuber) owners

[![Build Status](https://secure.travis-ci.org/shuber/owners.svg)](http://travis-ci.org/shuber/owners) [![Code Climate](https://codeclimate.com/github/shuber/owners/badges/gpa.svg)](https://codeclimate.com/github/shuber/owners) [![Coverage](https://codeclimate.com/github/shuber/owners/badges/coverage.svg)](https://codeclimate.com/github/shuber/owners) [![Gem Version](https://badge.fury.io/rb/owners.svg)](http://badge.fury.io/rb/owners)

Take ownership of your code.


## Installation

```
gem install owners
```


## Usage

Define an `OWNERS` file in any directory within your repository. This file should contain a newline separated list of subscribers to notify when files within the directory have changed. The `OWNERS` files are searched recursively up the tree to make organizing owners more convenient.

Subscribers can be anything that suits your needs e.g. emails, GitHub handles, Slack channels, etc.

```
bob@your-org.com
jane@your-org.com
@some_github_handle
@your_github_org/group
#some_slack_channel
```

The `OWNERS` file also supports limiting paths with regular expressions or exact matches. Any whitespace that separates the subscriber from the path limiters are ignored.

```
@data         app/models/.*
@ui           \.(css|haml|js|scss)$
bob@demo.com  lib/bobs_special_file.rb
```

Once your `OWNERS` files are defined, you can search for a list of owners by calling `Owners.for` with a list of paths e.g. output from `git diff --name-only`.

```ruby
Owners.for(".env", "app/controllers/posts_controller.rb", "app/models/user.rb")
```

This method returns a unique array of all the owners who have subscribed to changes for the specified files. These subscribers can then be notified however you see fit!

## API

[YARD Documentation](http://www.rubydoc.info/github/shuber/owners)

* `Owners.file`
* `Owners.file=`
* `Owners.for`


## Testing

```
bundle exec rspec
```


## Contributing

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a future version unintentionally.
* Commit, do not mess with the version or history.
* Send me a pull request. Bonus points for topic branches.


## License

[MIT](https://github.com/shuber/owners/blob/master/LICENSE)  - Copyright © 2015 Sean Huber
