# Override Class::Hash
class Hash
  # Add access_token to options for API call
  def add_access_token_to_options(access_token)
    self[:access_token] = access_token
  end
end