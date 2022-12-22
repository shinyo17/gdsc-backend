class Staff::ReadCommentsController < ApplicationController
  def create
    puts "@@@@@@@@"
    puts "#{read_comments_params}"
    puts "@@@@@@@@"

    render json: { message: "Success" }
  end

  private

  def read_comments_params
    params.require(:read_comments).permit(:staff_user_id)
  end
end
