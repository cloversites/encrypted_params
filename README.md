# EncryptedParams

ActionController::Base includes two new methods.

encrypt_params takes a hash like object and adds metadata to it. It then encrypts the whole thing using the symmetric-encryption gem.

decrypt_params does the reverse, but also adds the key, value pairs from the hash like object to the params object. It's indended to be used as before_action in your controllers.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'encrypted_params', github: 'cloversites/encrypted_params'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install encrypted_params

## Usage

Setup the symmetric-encryption gem by following the steps on the configuration page https://reidmorrison.github.io/symmetric-encryption/configuration.html
Before sending your params encrypt them using encrypt_params. By default decrypt_params will use EncryptedParams::ENCRYPTED_PARAM_KEY to find the encrypted data so it's best to send your request using this key.
Make decrypt_params a before_action for the actions you plan to send this data to. The params will be validated and added to the params hash availble in the action.

Example:
```ruby
class Sender
    include EncryptedParams
    def post_comment
        data = { thread: 1, text: 'Cool gem yo' }
        HTTParty.post 'https://example.com/api/comment', EncryptedParams::ENCRYPTED_PARAM_KEY => encrypt_params(data)
    end
end

class API
    include EncryptedParams
    before_action :decrypt_params, only: [:method]
    def method
        # Access params as you normally would. the :thread and :text keys will be there.
    end
end
```
    

## Contributing

1. Fork it ( https://github.com/cloversites/encrypted_params/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
