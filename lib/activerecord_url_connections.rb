require "active_record"
module ActiveRecordURLConnections
  def self.parse(str)
    if str =~ %r{//}
      config = URI.parse(str)
      adapter = config.scheme
      adapter = "postgresql" if adapter == "postgres"
      spec = { :adapter  => adapter,
               :username => config.user,
               :password => config.password,
               :port     => config.port,
               :database => config.path.sub(%r{^/},""),
               :host => config.host }
      spec.reject!{ |key,value| value.nil? }
      spec.merge!(split_query_options(config.query))
      spec
    else
      str
    end
  rescue URI::InvalidURIError
    return nil
  end

  private
  def self.split_query_options(query = nil)
    return {} unless query
    Hash[query.split("&").map{ |pair| pair.split("=") }].symbolize_keys
  end
end

ActiveRecord::Base.class_eval do
  class << self
    alias_method :establish_connection_without_url, :establish_connection
    def establish_connection(spec = nil)
      spec ||= ENV["DATABASE_URL"]
      spec = ActiveRecordURLConnections.parse(spec) if spec.is_a?(String)
      establish_connection_without_url(spec)
    end
  end
end
