require_relative 'lib/azure_cosmos_db_client/version'

Gem::Specification.new do |spec|
  spec.name          = "azure_cosmos_db_client"
  spec.version       = AzureCosmosDbClient::VERSION
  spec.authors       = ["Yuka Okabe"]
  spec.email         = ["32320352+yukabeoka@users.noreply.github.com"]

  spec.summary       = %q{Gem that supports communication with Azure CosmosDB.}
  spec.description   = %q{Gem that supports communication with Azure CosmosDB.}
  spec.homepage      = "https://github.com/fusic/azure_cosmos_db_client"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/fusic/azure_cosmos_db_client"
  spec.metadata["changelog_uri"] = "https://github.com/fusic/azure_cosmos_db_client"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
