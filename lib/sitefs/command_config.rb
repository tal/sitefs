class Sitefs::CommandConfig
  attr_accessor :index_format, :port, :ignore_patterns
  attr_reader :root_path, :manifest
  attr_writer :quiet, :force

  def initialize seed
    @root_path = '.'
    @aws_region = 'aws_region'
    @index_format = 'all-index'
    @ignore_patterns = []

    seed.each do |k, v|
      instance_variable_set "@#{k}", v
    end

    self.root_path = @root_path

    @manifest = Manifest.new root_path
  end

  def quiet?; @quiet; end
  def force?; @force; end

  def root_path= path
    @root_path = File.join(File.expand_path(@root_path), '')
  end

  def aws_creds
    @aws_creds ||= Aws::Credentials.new(@aws_access_key_id, @aws_secret_access_key)
  end

  def s3
    @s3 ||= Aws::S3::Client.new credentials: aws_creds, region: @aws_region
  end

  def s3_bucket
    @bucket ||= s3.bucket(@aws_s3_bucket)
  end

  def s3_pages
    s3.list_objects(bucket: @aws_s3_bucket)
  end

  def put_s3_object path, content_type: nil, **args
    if content_type
      args[:content_type] = content_type
    end

    s3.put_object(bucket: @aws_s3_bucket, key: path, **args)
  end

  def s3_object_contents path
    resp = s3.get_object(bucket: @aws_s3_bucket, key: path)

    resp && resp.body.read
  end

  def s3_object path
    return @s3_object[path.to_s] if @s3_object

    @s3_object = {}

    s3_pages.each do |request|
      request.contents.each do |obj|
        @s3_object[obj.key.to_s] = obj
      end
    end

    @s3_object[path.to_s]
  end

  class << self
    attr_reader :current

    def from_file filename
      @current = new YAML.load_file(filename)
    end
  end
end
