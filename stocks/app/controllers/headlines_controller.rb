require 'uri'


class HeadlinesController < ApplicationController 
    helper_method :images

    def home
        response = HTTParty.get('https://api.iextrading.com/1.0/stock/market/batch?symbols=aapl,fb,googl,nflx&types=quote')
        news = HTTParty.get('https://api.iextrading.com/1.0/stock/market/news/last/7')
        
        def jsonParse(result)
            return JSON.parse result.to_s, symbolize_names: true
        end
        
        @board = jsonParse(response)
        @story = jsonParse(news)
        
        
        def images(res)
            encoded = URI.escape(res.split(' ')[0...4].join(" "))
            @subscription = '8a3446dcf7c64ea79f747bb39b88d540'
            #picture from bing image search for headline
            pictures = HTTParty.get("https://api.cognitive.microsoft.com/bing/v5.0/images/search?q=#{encoded}", :headers=> {"Ocp-Apim-Subscription-Key": @subscription})
            parsed = jsonParse(pictures)
            # return imgUrl = URI.unescape(encoded).to_sym

        end


    end


end