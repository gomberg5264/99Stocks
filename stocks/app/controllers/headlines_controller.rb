

class HeadlinesController < ApplicationController 

    def home
        response = HTTParty.get('https://api.iextrading.com/1.0/stock/aapl/batch?types=quote,news,chart&range=1m&last=1')
        @res = JSON.parse response.to_s
    end


end