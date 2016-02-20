# [![Sean Huber](https://cloud.githubusercontent.com/assets/2419/6550752/832d9a64-c5ea-11e4-9717-6f9aa6e023b5.png)](https://github.com/shuber) owners

[![Build Status](https://secure.travis-ci.org/shuber/owners.svg)](http://travis-ci.org/shuber/owners) [![Code Climate](https://codeclimate.com/github/shuber/owners/badges/gpa.svg)](https://codeclimate.com/github/shuber/owners) [![Coverage](https://codeclimate.com/github/shuber/owners/badges/coverage.svg)](https://codeclimate.com/github/shuber/owners) [![Gem Version](https://badge.fury.io/rb/owners.svg)](http://badge.fury.io/rb/owners)

Take ownership of your code.

Knowing who owns a project or section of a code base is very helpful when asking questions or requesting feedback. This gem allows developers to define `OWNERS` files throughout their repository to provide a human and machine readable way to determine who the maintainers are for specific files of code.

These files can be used to:

* find the right people to ask when you have questions
* notify maintainers when changes occur in the files that they care about
* enforce approval from the appropriate people in pull requests


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

The `OWNERS` file also supports filtering paths with regular expressions. Any whitespace between these filters and their corresponding subscribers is ignored.

```
@data         app/models/.*
@ui           \.(css|haml|js|scss)$
bob@demo.com  lib/bobs_special_file.rb
#whitespace   path/with spaces/is all part/of the filter.txt
```

Subscribers can be listed multiple times in an `OWNERS` file.

```
@data app/models
@data db
```

Multiple comma separated subscribers can be listed for the same filter.

```
@data,@team-leads db
```

Find the owners for specific files by passing them to the `Owners.for` method.

```ruby
Owners.for("app/models/user.rb", "db/schema.rb") #=> ["@data", "@team-leads"]
```

To find the owners for files changed with `git diff` use the `Owners.for_diff` method.

```ruby
Owners.for_diff("your-feature-branch-or-ref", "optional-base-ref-defaults-to-master")
```


## CLI

This gem also comes with a convenient `owners` command line interface. Each owner is printed out and separated by newlines.

```bash
owners for .env app/controllers/posts_controller.rb app/models/user.rb
```

```
@infrastructure
@api
@data
```

The `git diff` integration works in the command line as well.

```bash
owners for_diff my-feature-branch
```

See `owners help` for more information.


## API

[YARD Documentation](http://www.rubydoc.info/github/shuber/owners)

* `Owners.file`
* `Owners.file=`
* `Owners.for`
* `Owners.for_diff`


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
