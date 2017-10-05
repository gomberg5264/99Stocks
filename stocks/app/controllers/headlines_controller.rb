require 'uri'




class HeadlinesController < ApplicationController 
    helper_method :images

    def home
        response = HTTParty.get('https://api.iextrading.com/1.0/stock/market/batch?symbols=aapl,fb,googl,nflx&types=quote')
        news = HTTParty.get('https://api.iextrading.com/1.0/stock/market/news/last/35')
        topGainers = HTTParty.get('https://api.iextrading.com/1.0//stock/market/list/gainers')
        topLosers = HTTParty.get('https://api.iextrading.com/1.0//stock/market/list/losers')
        stockTwits = HTTParty.get('https://api.stocktwits.com/api/2/streams/trending.json')

        def jsonParse(result)
            return JSON.parse result.to_s, symbolize_names: true
        end
        
        @board = jsonParse(response)
        @story = jsonParse(news)
        @gainers = jsonParse(topGainers)
        @losers = jsonParse(topLosers)
        @stockTwits = jsonParse(stockTwits)

        def stockTweets 
            tweet_arr = Array.new
            count = 0
            
            (0..29).each do |i|
                if count > 2
                    break
                elsif @stockTwits[:messages][i][:body].length < 79 && @stockTwits[:messages][i][:body].length > 25 && 
                    @stockTwits[:messages][i][:user][:avatar_url] != "http://avatars.stocktwits.com/images/default_avatar_thumb.jpg"
                    tweet_arr[count] = {
                        :name => (@stockTwits[:messages][i][:user][:name]),
                        :image => (@stockTwits[:messages][i][:user][:avatar_url]),
                        :body => (@stockTwits[:messages][i][:body])
                    }
                    count += 1
                end
            end
            return tweet_arr
        end

        @shortTweets = stockTweets
        
    

    end


end