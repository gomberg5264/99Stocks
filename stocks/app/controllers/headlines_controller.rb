require 'uri'




class HeadlinesController < ApplicationController 
    helper_method :images

    def home
        response = HTTParty.get('https://api.iextrading.com/1.0/stock/market/batch?symbols=aapl,fb,googl,nflx&types=quote')
        news = HTTParty.get('https://api.iextrading.com/1.0/stock/market/news/last/35')
        topGainers = HTTParty.get('https://api.iextrading.com/1.0//stock/market/list/gainers')
        topLosers = HTTParty.get('https://api.iextrading.com/1.0//stock/market/list/losers')
        
        def jsonParse(result)
            return JSON.parse result.to_s, symbolize_names: true
        end
        
        @board = jsonParse(response)
        @story = jsonParse(news)
        @gainers = jsonParse(topGainers)
        @losers = jsonParse(topLosers)
        
        
    

    end


end