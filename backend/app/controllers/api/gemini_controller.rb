module Api
  class GeminiController < ApplicationController
    def create
      prompt = params[:prompt]
      
      # リクエストログの保存
      request_log = UserLog.create!(
        user_id: request.remote_ip, # IPアドレスをユーザーIDとして使用
        action: 'gemini_request',
        path: request.path,
        timestamp: Time.current,
        metadata: {
          prompt: prompt,
          user_agent: request.user_agent
        }
      )

      # 検索履歴の保存
      search_history = SearchHistory.create!(
        user_id: request.remote_ip,
        query: prompt,
        timestamp: Time.current
      )

      result = GeminiService.new.generate_content(prompt)
      
      # 検索結果の件数を更新（レスポンスの内容に応じて適切な値を設定）
      search_history.update(
        results_count: result["error"].present? ? 0 : 1
      )
      
      # レスポンスログの保存
      response_log = UserLog.create!(
        user_id: request.remote_ip,
        action: 'gemini_response',
        path: request.path,
        timestamp: Time.current,
        metadata: {
          prompt: prompt,
          response: result,
          status: result["error"].present? ? 'error' : 'success'
        }
      )
      
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