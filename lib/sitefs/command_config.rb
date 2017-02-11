class Sitefs::CommandConfig
  attr_accessor :root_path, :index_format

  def initialize seed
    @root_path = '.'
    @aws_region = 'aws_region'
    @index_format = 'all-index'

    seed.each do |k, v|
      instance_variable_set "@#{k}", v
    end
  end

  def aws_creds
    @aws_creds ||= Aws::Credentials.new(@aws_access_key_id, @aws_secret_access_key)
  end

  def s3
    @s3 ||= Aws::S3::Client.new credentials: aws_creds, region: @aws_region
  end

  def s3_pages
    s3.list_objects(bucket: @s3_bucket)
  end

  class << self
    attr_reader :current

    def from_file filename
      @current = new YAML.load_file(filename)
    end
  end
end
