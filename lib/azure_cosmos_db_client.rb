require "azure_cosmos_db_client/version"
require 'json'

module AzureCosmosDb
  class Error < StandardError; end

  class Client
    class << self
      attr_writer :mock
      attr_reader :mock
    end

    def initialize(account:, database:, collection:, key:, faraday_client: nil)
      begin
        @faraday_client = faraday_client || Faraday.new(url: "https://#{host(account)}:443")
      rescue StandardError => e
        raise e
      end
      @database = database
      @collection = collection
      @key = key
    end

    def cosmosdb_sql(query)
      res = @faraday_client.post do |req|
        http_headers(req)
        req.url("/dbs/#{@database}/colls/#{@collection}/docs")
        req.body = { query: query }.to_json
      end
      JSON.parse(res.body)
    end

    private

    def host(account)
      "#{account}.documents.azure.com"
    end

    def http_headers(req)
      datetime = Time.current
      [
        ['Authorization', token('POST', 'docs', "dbs/#{@database}/colls/#{@collection}", datetime, @key)],
        ['Content-Type', 'application/query+json'],
        %w[x-ms-version 2018-12-31],
        ['x-ms-date', datetime.httpdate],
        %w[x-ms-max-item-count 2000],
        %w[x-ms-documentdb-isquery True],
        %w[x-ms-documentdb-query-enablecrosspartition True],
        %w[x-ms-documentdb-query-enable-scan True]
      ].each do |key, val|
        req.headers[key] = val
      end
    end

    def token(verb, resource_type, resource_id, datetime, master_key)
      text = "#{verb.downcase}\n#{resource_type.downcase}\n#{resource_id}\n#{datetime.httpdate.downcase}\n\n"
      hash = OpenSSL::HMAC.digest('sha256', Base64.decode64(master_key), text)
      str = CGI.escape("type=master&ver=1.0&sig=#{Base64.encode64(hash).chop}") # HMACエンコードした時点で余分な1文字が入るので取り除く
      str
    end
  end
end
