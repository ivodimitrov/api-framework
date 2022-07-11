class AuthorisePayload
  attr_accessor :username, :password

  def initialize(&)
    instance_eval(&) if block_given?
  end

  def to_json(*_args)
    { username: username,
      password: password }.to_json
  end
end
