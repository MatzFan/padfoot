# methods to upload to S3
module S3storable
  def s3_file_keys
    S3.list_objects(bucket: BUCKET).map { |r| r.contents.map(&:key) }.flatten
  end

  def upload(uri, key)
    obj = s3_object(key)
    open(uri) { |file| obj.upload_file(file) }
    obj.acl.put(acl: 'public-read')
    obj.public_url
  end

  def s3_object(object_key)
    Aws::S3::Object.new(bucket_name: BUCKET, key: object_key)
  end
end
