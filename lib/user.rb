require_relative 'database_connection'
require 'bcrypt'

class User
  attr_reader :id, :username, :email

  def initialize(id:, username:, email:)
    @id = id
    @username = username
    @email = email
  end

  def self.create(username:, email:, password:)
    encrypted_password = BCrypt::Password.create(password)
    result = DatabaseConnection.query("INSERT INTO users (username, email, password) VALUES ('#{username}', '#{email}', '#{encrypted_password}') RETURNING id, username, email;")
    User.new(id: result[0]['id'], username: result[0]['username'], email: result[0]['email'])
  end

  def self.find(id)
    return nil unless id
    result = DatabaseConnection.query("SELECT * FROM users WHERE id = #{id};")
    User.new(id: result[0]['id'], username: result[0]['username'], email: result[0]['email'])
  end

  def self.authenticate(username:, email:, password:)
    result = DatabaseConnection.query("SELECT * FROM users WHERE username = '#{username}';")
    # return unless result.any?
    User.new(id: result[0]['id'], email: result[0]['email'], username: result[0]['username'])
  end
end
