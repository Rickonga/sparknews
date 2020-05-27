class SavedTweetsController < ApplicationController

  def create
    @tweet = Tweet.where("content = ? AND author = ?", params[:value][2], params[:value][0])
    if !@tweet.empty?
      authorize @tweet
      destroy
    else
      @tweet = Tweet.create(content: params[:value][2],
                       author: params[:value][0],
                       publish: params[:value][3],
                       avatar: params[:value][4],
                       follower: params[:value][1])
      authorize @tweet
      current_user.saved_tweets.create(tweet: @tweet)
    end
    redirect_to stocks_path(query: params[:query])
  end

  def destroy
    if params[:id]
      saved_tweet = SavedTweet.find(params[:id]).tweet
    else
      saved_tweet = @tweet.first
    end
    authorize saved_tweet
    saved_tweet.destroy
    redirect_to stocks_path(query: params[:query]) if params[:id]
  end
end
