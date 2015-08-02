module Api::V1::Json
  def api_json(obj, hash = {})
    obj.as_json hash
  end
end
