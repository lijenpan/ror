class AWSUtil
  def self.send bucket_name, file_name
    unless bucket_name && file_name
      puts "Bucket name and/or file name are missing."
      exit 1
    end

    s3 = AWS::S3.new

    b = s3.buckets[bucket_name]

    unless b.exists?
      puts "Need to make bucket #{bucket_name}"
      b = s3.buckets.create(bucket_name)
    end

    basename = File.basename(file_name)
    o = b.objects[basename]
    o.write(:file => file_name, :acl => :public_read)

    [o.key, o.public_url]
    # o.delete
  end

  def self.list bucket_name
    unless bucket_name
      puts "Bucket name is missing."
      exit 1
    end

    s3 = AWS::S3.new
    b = s3.buckets[bucket_name]

    unless b.exists?
      puts "Bucket #{bucket_name} does not exist."
      exit 1
    end

    b.objects
  end

  def self.delete bucket_name, file_key
    unless bucket_name && file_key
      puts "Bucket name and/or file key are missing."
      exit 1
    end

    s3 = AWS::S3.new
    b = s3.buckets[bucket_name]

    unless b.exists?
      puts "Bucket #{bucket_name} does not exist."
    end

    o = b.objects[file_key]

    unless o.exists?
      puts "File #{file_key} does not exist in #{bucket_name}."
    end

    o.delete
  end
end
