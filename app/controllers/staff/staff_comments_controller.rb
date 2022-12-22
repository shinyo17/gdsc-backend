class Staff::StaffCommentsController < Staff::StaffController
  before_action :set_staff_user, only: %i[ mark_as_checked mark_as_read ] 

  def index
    staff_comments = StaffComment.staff_search(params[:query]).order(created_at: :desc)
    @staff_comments = staff_comments.page(params[:page]).per(100)
  end

  def show
  end

  def new
    @staff_comment = StaffComment.new
  end

  def edit
    @staff_comment = StaffComment.find(params[:id])
  end

  def create
    staff_comment = StaffComment.new(staff_comment_params)
    if staff_comment.save!
      respond_to do |format| 
        format.html { redirect_to staff_comment.path }
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    staff_comment = StaffComment.find(params[:id])
    staff_comment.staff_user = StaffUser.last
    if staff_comment.update!(staff_comment_params)
      redirect_to staff_staff_comments_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def delete
  end

  def mark_as_read 
    comments = @staff_user.fetch_unchecked_comments
    current_time = Time.zone.now

    # OPTIMIZE : comment를 지나가다 확인한 것으로 처리할때 단 한번의 쿼리로 insert 할 수 있도록 해야함.
    #
    # See https://github.com/jamis/bulk_insert
    comments.each do |comment|
      @staff_user.staff_audit_logs.create!(action: 'read', acted_at: current_time, auditable: comment)
    end

    render json: { message: "OK" } 
  end

  def mark_as_checked
    comment = StaffComment.find(params[:id])

    @staff_user.check_staff_comment(comment)

    render json: { message: "OK" } 
  end

  private

  def set_staff_user 
    @staff_user = StaffUser.find(staff_comment_credential_params[:staff_user_id])
  end

  def staff_comment_params
    params.require(:staff_comment).permit(:body, :path, :staff_user_id)
  end

  def staff_comment_credential_params
    params.require(:staff_comment).permit(:staff_user_id)
  end
end
