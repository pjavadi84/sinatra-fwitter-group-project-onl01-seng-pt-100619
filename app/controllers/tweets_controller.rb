class TweetsController < ApplicationController
    get '/tweets' do
      if logged_in? #if user is logged in aleardy
        @tweets = Tweet.all # Assign a valuable @tweets to get ALL of the tweets 
        erb :'/tweets/tweets' # render the tweet page
      else #if the user is not logged in, they cannot check their tweet so:
        redirect to '/login' #they have to be redirected to login page
      end
    end
  
    get '/tweets/new' do
      if logged_in? #if the user is already logged in?
        erb :'tweets/create_tweet' #redirect to tweet creation page
      else # if the user is not logged in, they canot create tweet. 
        redirect to '/login' # They have to be redirected to the login page
      end
    end
  
    post '/tweets' do
      if logged_in? #if the user is logged in
        if params[:content] == "" #and if the content the user submits being empty then
          redirect to "/tweets/new" # redirect the user to create a new tweet again
        else #otherwise
          @tweet = current_user.tweets.build(content: params[:content]) #the information captured will be used to build
          # a new instance of a tweet that can be built
          if @tweet.save #if the newly instance you already created, and being saved exits, then finally:
            redirect to "/tweets/#{@tweet.id}" #the specific tweet can be routed by the logged in user
          else #otherwise
            redirect to "/tweets/new" #the user whose logged in should create a new tweets
          end
        end
      else #otherwise if the user is NOT logged in, then
        redirect to '/login' #user should be redirected to log in page
      end
    end
  
    get '/tweets/:id' do # this route is if the user wanna check the specific tweet by its ID
      if logged_in? #if the user is logged in, then
        @tweet = Tweet.find_by_id(params[:id]) #find the tweet by the id the user enters(params)
        erb :'tweets/show_tweet' #and then render the show_tweet
      else #otherwise, if the user is not logged in the system then
        redirect to '/login' #redirect the user to login page
      end
    end
  
    get '/tweets/:id/edit' do #this route will edit the already created tweet
      if logged_in? #if the user is logged
        @tweet = Tweet.find_by_id(params[:id]) #find the tweet by its ID
        if @tweet && @tweet.user == current_user # if the tweet exists AND the current tweet's user is the same as the current user
          erb :'tweets/edit_tweet' #render the edit tweet page for that specific tweet
        else #otherwise if the neither that specific tweet or that user exists that matches that tweet
          redirect to '/tweets' #redirect the user to the tweets page
        end
      else #if not logged in, just direct the user to login page
        redirect to '/login' 
      end
    end
  
    patch '/tweets/:id' do #patch is when you want to show the updated information you have just made
      if logged_in? #so if the user is logged in? AND 
        if params[:content] == "" #if the user's input for editting the content was empty then
          redirect to "/tweets/#{params[:id]}/edit" #redirect the user to the edit page of that specific tweet
        else # otherwise, if the user enter any information
          @tweet = Tweet.find_by_id(params[:id]) #find that specific tweet by id
          if @tweet && @tweet.user == current_user #and If the tweet exist and it is for the current user's tweet match the current user
            if @tweet.update(content: params[:content]) # and if the user updates the content
              redirect to "/tweets/#{@tweet.id}" #then redirec to the edited tweet by its id
            else
              redirect to "/tweets/#{@tweet.id}/edit" #otherwise, redirect back to the edit page for user to edit that tweet given by its ID
            end
          else #otherwise, if the tweet doesn't exist and doesn't match the user's profile, then
            redirect to '/tweets' #redirect it back to his tweet's list
          end
        end
      else #if it is not logged in, then
        redirect to '/login'
      end
    end
  
    delete '/tweets/:id/delete' do
      if logged_in?
        @tweet = Tweet.find_by_id(params[:id])
        if @tweet && @tweet.user == current_user
          @tweet.delete
        end
        redirect to '/tweets'
      else
        redirect to '/login'
      end
    end
  end