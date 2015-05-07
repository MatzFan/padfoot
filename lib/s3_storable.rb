module S3storable

  def s3_file_keys
    S3.list_objects(bucket: BUCKET).map { |r| r.contents.map(&:key) }.flatten #flatten for single file case
  end

  def upload(uri, key)
    obj, caller = s3_object(key), self
    begin
      open(uri) { |file| obj.upload_file(file) } # closes stream :)
      obj.acl.put(acl: 'public-read')
      obj.public_url
    rescue OpenURI::HTTPError
      raise "File at #{uri} failed to upload"
    end
  end

  def s3_object(object_key)
    Aws::S3::Object.new(bucket_name: BUCKET, key: object_key)
  end

end
