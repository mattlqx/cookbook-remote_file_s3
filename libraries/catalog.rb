# frozen_string_literal: true

module Aws
  # Maintains a simple catalog of local file paths to etags and hashes at time of download
  class S3Catalog
    attr_reader :catalog

    def initialize
      @catalog = File.exist?(catalog_path) ? JSON.parse(IO.read(catalog_path)) : {}
    end

    def catalog_path
      File.join(Chef::Config[:file_cache_path], 'remote_file_s3_etags.json')
    end

    def save
      File.open(catalog_path, 'w', 0o0644) { |f| f.write(JSON.dump(@catalog)) }
    end

    def file_defaults
      {
        etag: nil,
        sha256: nil,
      }
    end

    def file(path)
      file_defaults.merge(@catalog.fetch(path, {}))
    end
    alias [] file

    def set_file(path, opts = {})
      opts.delete_if { |k, v| !file_defaults.key?(k) || v.nil? }
      @catalog[path] = opts
    end
    alias []= set_file

    def remove_file(path)
      @catalog.delete(path)
    end
  end
end
