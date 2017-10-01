

class HeadlinesController < ApplicationController 

    def home
        key = Rails.application.secrets.bing_api_search_key || ENV['BING_API_SEARCH_KEY']
        response = HTTParty.get('https://api.iextrading.com/1.0/stock/market/batch?symbols=aapl,fb,googl,nflx&types=quote')
        news = HTTParty.get('https://api.iextrading.com/1.0/stock/market/news/last/7')

        def jsonParse(result)
            return JSON.parse result.to_s, symbolize_names: true
        end
        
        @board = jsonParse(response)
        @story = jsonParse(news)
        
        def images(res)
            pictures = HTTParty.get("https://api.cognitive.microsoft.com/bing/v5.0/images/search?q=#{res}", :headers=> {'Ocp-Apim-Subscription-Key': key})
            return jsonParse(pictures)
        end

    end


end