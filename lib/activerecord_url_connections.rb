require "active_record"
module ActiveRecordURLConnections
  def self.parse(str)
    config = URI.parse(str)
    { :encoding => "unicode",
      :port     => config.port,
      :username => config.user,
      :adapter  => "postgresql",
      :database => config.path.gsub(%r{/},""),
      :host     => config.host,
      :password => config.password
    }
  end
end

ActiveRecord::Base.class_eval do
  class << self
    alias_method :establish_connection_without_url, :establish_connection
    def establish_connection(spec = nil)
      spec ||= ENV["DATABASE_URL"]
      if spec.is_a?(String) && url = URI.parse(spec)
        adapter = url.scheme
        adapter = "postgresql" if adapter == "postgres"
        spec = { :adapter  => adapter,
                 :username => url.user,
                 :password => url.password,
                 :database => url.path.sub(%r{^/},""),
                 :port     => url.port,
                 :hostname => url.host }
        spec.reject!{ |key,value| value.nil? }
        spec.merge!(split_query_options(url.query))
      end
      establish_connection_without_url(spec)
    rescue URI::InvalidURIError
      establish_connection_without_url(spec)
    end

    private
    def split_query_options(query = nil)
      return {} unless query
      Hash[query.split("&").map{ |pair| pair.split("=") }].symbolize_keys
    end
  end
end
