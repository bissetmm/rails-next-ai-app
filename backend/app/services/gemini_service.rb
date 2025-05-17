class GeminiService
  MODELS = [
    {
      name: "gemini-1.5-pro-latest",
      url: "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro-latest:generateContent",
      config: {
        temperature: 0.7,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 2048
      }
    },
    {
      name: "gemini-1.5-pro",
      url: "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateContent",
      config: {
        temperature: 1.0,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 2048
      }
    },
    {
      name: "gemini-1.5-flash-latest",
      url: "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent",
      config: {
        temperature: 1.0,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 2048
      }
    }
  ]

  def initialize
    @api_key = ENV["GEMINI_API_KEY"]
    @current_model_index = 0
    @max_retries = MODELS.length
  end

  def generate_content(prompt)
    retries = 0
    
    while retries < @max_retries
      model = MODELS[@current_model_index]
      response = try_generate_content(prompt, model)
      
      if response["error"]
        case response.dig("error", "code")
        when 429 # Rate limit exceeded
          Rails.logger.warn("Rate limit exceeded for model #{model[:name]}, trying next model")
          @current_model_index = (@current_model_index + 1) % MODELS.length
          retries += 1
        else
          return response
        end
      else
        return response
      end
    end
    
    { error: { message: "すべてのモデルでレート制限に達しました。しばらく時間をおいて再度お試しください。" } }
  end

  private

  def try_generate_content(prompt, model)
    response = Faraday.post(
      "#{model[:url]}?key=#{@api_key}",
      {
        contents: [
          { parts: [{ text: prompt }] }
        ],
        generationConfig: model[:config]
      }.to_json,
      { "Content-Type" => "application/json" }
    )
    JSON.parse(response.body)
  rescue Faraday::Error => e
    { error: { message: e.message } }
  end
end
