require "encrypted_params/version"
require 'digest'
require 'json'
require 'openssl'
require 'symmetric-encryption'

module EncryptedParams
  VALID_TIME = 60.seconds
  ENCRYPTED_PARAM_KEY = :encrypted_param
    
  def encrypt_params(params_hash={})
    
    data = {}.tap do |hsh|
      hsh[:params] = params_hash
      hsh[:checksum] = hash_digest params_hash
      hsh[:timestamp] = Time.now
      hsh[:version] = VERSION
    end
    
    cypher_text = SymmetricEncryption.encrypt data.to_json, random_iv: true, type: :json
    return Rack::Utils.escape_path cypher_text
  end
  
  def decrypt_params(param_key=ENCRYPTED_PARAM_KEY)
    # Get our secure param.
    param = params.delete(param_key)
    return head :unauthorized if param.nil?
    
    # Decrypt it into a json string.
    begin
      json = SymmetricEncryption.decrypt param
    rescue OpenSSL::Cipher::CipherError => error
      return head :unauthorized
    else
      return head :unauthorized if json.nil?
    end
    
    # Try to parse the json string and symbolize the keys.
    begin
      secure_data = JSON.parse json
    rescue => error
      return head :unauthorized
    else
      secure_data.deep_symbolize_keys!
    end
    
    # Validate the timestamp inside the request. To prevent replay attacks we don't allow requests after a certain point.
    begin
      timestamp = Time.parse secure_data[:timestamp]
    rescue
      return head :unauthorized
    else
      return head :unauthorized if (Time.now - timestamp) > VALID_TIME
    end
    
    # Check the version. In the future this can be used to choose the unpacking method.
    if secure_data[:version].to_i != VERSION
      return head :unauthorized
    end
    
    original_params = secure_data[:params]
    checksum = hash_digest original_params
    return head :unauthorized unless checksum == secure_data[:checksum]

    original_params.each_pair do |key, value|
      params[key] = value
    end
  end
  
  private
  
  def hash_digest(hsh)
    hash = Digest::SHA256.new
    hash << hsh.to_json
    return hash.base64digest
  end
end

# Include the encrypted params functions in the base action controller.
ActionController::Base.send :include, EncryptedParams
