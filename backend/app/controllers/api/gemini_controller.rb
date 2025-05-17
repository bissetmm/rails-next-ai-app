module Api
  class GeminiController < ApplicationController
    def create
      prompt = params[:prompt]
      result = GeminiService.new.generate_content(prompt)
      
      if result["error"].present?
        error_message = case result.dig("error", "code")
        when 429
          "APIの利用制限に達しました。しばらく時間をおいて再度お試しください。"
        else
          "エラーが発生しました。しばらく時間をおいて再度お試しください。"
        end
        
        render json: { error: error_message }, status: result.dig("error", "code") || 500
      else
        render json: result
      end
    end
  end
end 