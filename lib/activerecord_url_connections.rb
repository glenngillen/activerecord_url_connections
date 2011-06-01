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
