module S3Helper

  def s3_file_keys
    S3.list_objects(bucket: BUCKET).map { |r| r.contents.map(&:key) }.flatten #flatten for single file case
  end

  def upload(uri, key)
    obj = s3_object(key)
    open(uri) { |file| obj.upload_file(file) } # closes stream :)
    obj.presigned_url(:get)
  end

  def s3_object(object_key)
    Aws::S3::Object.new(bucket_name: BUCKET, key: object_key)
  end

end
