class StaticPagesController < ApplicationController


  before_filter :authorize, except: [:welcome]

  def home
    @micropost = current_user.microposts.build if current_user
    @feed_items = current_user.feed.paginate(page: params[:page])
  end

  def index

  end

  def help

  end

  def about

  end

  def map

  end

  def contact

  end

  def welcome

  end

  def start

  end

  def test_page

  end

  def theme

  end

end
