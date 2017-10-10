require 'uri'




class HeadlinesController < ApplicationController 
    helper_method :images

    def home

    end

    def dashboard
        newsKey = Rails.application.secrets.news_api_key || ENV["NEWS_API_KEY"]
        response = HTTParty.get('https://api.iextrading.com/1.0/stock/market/batch?symbols=aapl,fb,googl,nflx&types=quote')
        news = HTTParty.get('https://api.iextrading.com/1.0/stock/market/news/last/35')
        topGainers = HTTParty.get('https://api.iextrading.com/1.0//stock/market/list/gainers')
        topLosers = HTTParty.get('https://api.iextrading.com/1.0//stock/market/list/losers')
        stockTwits = HTTParty.get('https://api.stocktwits.com/api/2/streams/trending.json')
        mostActive = HTTParty.get('https://api.iextrading.com/1.0//stock/market/list/mostactive')
        recent_news = HTTParty.get("https://newsapi.org/v1/articles?source=bloomberg&sortBy=top&apiKey=#{newsKey}")

        def jsonParse(result)
            return JSON.parse result.to_s, symbolize_names: true
        end
        
        @board = jsonParse(response)
        @story = jsonParse(news)
        @gainers = jsonParse(topGainers)
        @losers = jsonParse(topLosers)
        @stockTwits = jsonParse(stockTwits)
        @mostActive = jsonParse(mostActive)
        @news = jsonParse(recent_news)
        
        
        def getNews
            news_arr = Array.new
            count = 0
        
            (0..4).each do |i|
                if count > 4
                    break
                else
                    news_arr[count] = {
                        :title => (@news[:articles][i][:title]),
                        :urlToImage => (@news[:articles][i][:urlToImage]),
                        :url => (@news[:articles][i][:url])
                    }
                    count += 1
                end
            end

            return news_arr
        end
        
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
        @topNews = getNews

    end

    def single
        params[:id]
        stockTwits = HTTParty.get('https://api.stocktwits.com/api/2/streams/trending.json')
        quote = HTTParty.get("https://api.iextrading.com/1.0/stock/#{params[:id]}/quote?displayPercent=true")
        company = HTTParty.get("https://api.iextrading.com/1.0/stock/#{params[:id]}/company")
        keystats = HTTParty.get("https://api.iextrading.com/1.0/stock/#{params[:id]}/stats")
        financials = HTTParty.get("https://api.iextrading.com/1.0/stock/#{params[:id]}/financials")
        logo = HTTParty.get("https://api.iextrading.com/1.0/stock/#{params[:id]}/logo")
        single_stock_news = HTTParty.get("https://api.iextrading.com/1.0/stock/#{params[:id]}/news/last/6")

        def jsonParse(result)
            return JSON.parse result.to_s, symbolize_names: true
        end

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
        

        @stockTwits = jsonParse(stockTwits)
        @quote = jsonParse(quote)
        @company = jsonParse(company)
        @keystats = jsonParse(keystats)
        @financials = jsonParse(financials)
        @logo = jsonParse(logo)
        @shortTweets = stockTweets
        @stockNews = jsonParse(single_stock_news)
        

    end


end