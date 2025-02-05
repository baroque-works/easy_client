# EasyClient

A Ruby gem for interacting with the EasyBroker API, focused on property management and querying.

## Installation

TODO: Replace `UPDATE_WITH_YOUR_GEM_NAME_IMMEDIATELY_AFTER_RELEASE_TO_RUBYGEMS_ORG` with your gem name right after releasing it to RubyGems.org. Please do not do it earlier due to security reasons. Alternatively, replace this section with instructions to install your gem from git if you don't plan to release to RubyGems.org.

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add 'easy_client'
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install 'easy_client'
```

## Configuration

```Ruby
EasyClient.configure do |config|
  config.api_key = 'your_easybroker_api_key'
end
```

## Usage

```Ruby
# Initialize the client
client = EasyClient::Client.new

# List properties with pagination (optional)
properties = client.list_properties(page: 1, limit: 20)
properties.items.each do |property|
  puts property.title
  puts property.address
end

# Print all property titles across all pages
client.print_all_property_titles
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/baroque-works/easy_client.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
