

class HeadlinesController < ApplicationController 

    def home
        response = HTTParty.get('https://api.iextrading.com/1.0/stock/market/batch?symbols=aapl,fb,googl,nflx&types=quote')
        @board = JSON.parse response.to_s, symbolize_names: true
    end


end