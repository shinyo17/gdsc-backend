require "jwt_auth"
class Api::V1::PostsController < Api::V1::BaseController
  before_action :authenticate, except: [:index]
  before_action :find_post, only: %i[show]

  def index
    @posts = Post.all
    @posts = @posts.order(created_at: :desc)
    render status: @status
  end

  def show
    render status: @status
  end

  def create
    @post = Post.new(post_params)
    @post.save!
    @status = :created
    render status: @status
  rescue ActiveRecord::RecordInvalid
    error!(@post.errors.full_messages, :unprocessable_entity)
  rescue StandardError => e
    error!(e, e.class.name.demodulize)
  end

  private

  def find_post
    @post = Post.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    error!('Post not found', :not_found)
  end

  def post_params
    params
      .require(:post)
      .permit(:title, :description, :user_id)
  end

end
