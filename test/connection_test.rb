require "rubygems"
require "bundler/setup"
Bundler.require(:test)
require "test/unit"
require "mocha"
require "activerecord_url_connections"
class TestConnection < Test::Unit::TestCase
  def mock_connection_spec(spec, adapter)
    conn_spec = ActiveRecord::Base::ConnectionSpecification.new(spec, adapter)
    ActiveRecord::Base::ConnectionSpecification.stubs(:new).
      with(spec, adapter).returns(conn_spec)
    conn_spec
  end

  def setup
    ActiveRecord::ConnectionAdapters::ConnectionHandler.any_instance.
      stubs(:establish_connection)
  end

  def spec_hash(opts = {})
    default_spec = { :adapter  => "mysql",
                     :username => "user",
                     :password => "secret",
                     :hostname => "localhost",
                     :database => "mydatabase" }
    default_spec.merge!(opts)
    default_spec
  end

  def test_generic_url_connection
    connection_spec = mock_connection_spec(spec_hash, "mysql_connection")
    url = "mysql://user:secret@localhost/mydatabase"
    ActiveRecord::ConnectionAdapters::ConnectionHandler.any_instance.
      expects(:establish_connection).with("ActiveRecord::Base", connection_spec)
    ActiveRecord::Base.establish_connection(url)
  end

  def test_works_with_traditional_hash_spec
    spec = spec_hash
    connection_spec = mock_connection_spec(spec, "mysql_connection")
    ActiveRecord::ConnectionAdapters::ConnectionHandler.any_instance.
      expects(:establish_connection).with("ActiveRecord::Base", connection_spec)
    ActiveRecord::Base.establish_connection(spec)
  end

  def test_doesnt_raise_uri_parse_error
    url = "this isn't a URL"
    assert_raises ActiveRecord::AdapterNotSpecified do
      ActiveRecord::Base.establish_connection(url)
    end
  end

  def test_translates_postgres
    spec = spec_hash(:adapter => "postgresql")
    connection_spec = mock_connection_spec(spec, "postgresql_connection")
    url  = "postgres://user:secret@localhost/mydatabase"
    ActiveRecord::ConnectionAdapters::ConnectionHandler.any_instance.
      expects(:establish_connection).with("ActiveRecord::Base", connection_spec)
    ActiveRecord::Base.establish_connection(url)
  end

  def test_supports_additional_options_as_params
    spec = spec_hash(:encoding => "utf8",
                     :hostname => "remotehost.example.org",
                     :port => 3133,
                     :random_key => "blah")
    connection_spec = mock_connection_spec(spec, "mysql_connection")
    url  = "mysql://user:secret@remotehost.example.org:3133/mydatabase?encoding=utf8&random_key=blah"
    ActiveRecord::ConnectionAdapters::ConnectionHandler.any_instance.
      expects(:establish_connection).with("ActiveRecord::Base", connection_spec)
    ActiveRecord::Base.establish_connection(url)
  end

  def test_drops_empty_values_from_spec
    spec = spec_hash
    spec.delete(:username)
    spec.delete(:password)
    connection_spec = mock_connection_spec(spec, "mysql_connection")
    url  = "mysql://localhost/mydatabase"
    ActiveRecord::ConnectionAdapters::ConnectionHandler.any_instance.
      expects(:establish_connection).with("ActiveRecord::Base", connection_spec)
    ActiveRecord::Base.establish_connection(url)
  end

  def test_use_environment_variable_if_no_spec_provided
    url = "mysql://user:secret@localhost/mydatabase"
    ENV["DATABASE_URL"] = url
    connection_spec = mock_connection_spec(spec_hash, "mysql_connection")
    ActiveRecord::ConnectionAdapters::ConnectionHandler.any_instance.
      expects(:establish_connection).with("ActiveRecord::Base", connection_spec)
    ActiveRecord::Base.establish_connection
  end
end
