class SavedTweetsController < ApplicationController

  def create
    @tweet = Tweet.find_by(content: params[:value][2])
    if @tweet
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
    redirect_to stocks_path
  end

  def destroy
    if params[:id]
      saved_tweet = SavedTweet.find(params[:id]).tweet
    else
      saved_tweet = @tweet
    end
    authorize saved_tweet
    saved_tweet.destroy
    redirect_to stocks_path if params[:id]
  end
end
