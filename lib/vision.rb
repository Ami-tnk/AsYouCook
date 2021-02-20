require 'base64'
require 'json'
require 'net/https'

module Vision
  class << self
    def get_image_data(image_file, search = true)
      # APIのURL作成
      api_url = "https://vision.googleapis.com/v1/images:annotate?key=#{ENV['GOOGLE_API_KEY']}"

      # 画像をbase64にエンコード
      if search
        base64_image = Base64.encode64(open("#{Rails.root}/tmp/uploads/cache/#{image_file.id}").read)
      else
        base64_image = Base64.encode64(open("#{Rails.root}/public/uploads/#{image_file.id}").read)
      end

      # APIリクエスト用のJSONパラメータ
      params = {
        requests: [{
          image: {
            content: base64_image,
          },
          features: [
            {
              type: 'LABEL_DETECTION',
            },
          ],
        }],
      }.to_json

      # Google Cloud Vision APIにリクエスト
      uri = URI.parse(api_url)
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      request = Net::HTTP::Post.new(uri.request_uri)
      request['Content-Type'] = 'application/json'
      response = https.request(request, params)
      response_body = JSON.parse(response.body)
      # APIレスポンス出力
      if (error = response_body['responses'][0]['error']).present?
        raise error['message']
      else
        response_body['responses'][0]['labelAnnotations']
      end
    end
  end
end
