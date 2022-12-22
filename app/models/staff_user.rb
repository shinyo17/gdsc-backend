class StaffUser < ApplicationRecord
  require "bigram_tokenizer"
  class << self
    def staff_search(query)
      return all if query.blank?
      tokenizer = BigramTokenizer.new(query)
      template, values = tokenizer.build_tsquery
      where("name_tsvector @@ (#{template})", *values)
        .or(where("username_tsvector @@ (#{template})", *values))
        .or(where("email % ?", query))
        .or(where("phone like ?", "%#{query}%"))
    end

    def display_index_row_attributes
      [:id, :email, :name, :username, :phone, :created_at, :updated_at]
    end
  end

  before_save :update_tsvector
  has_many :staff_comments
  has_many :staff_audit_logs

  def fetch_unchecked_comments(**kwargs)
    limit = kwargs.delete(:limit) || 6
    comments = StaffComment.where.not(id: already_checked_comments).order(created_at: :desc).limit(limit)
    current_time = Time.zone.now

    # OPTIMIZE : comment를 지나가다 확인한 것으로 처리할때 단 한번의 쿼리로 insert 할 수 있도록 해야함.
    #
    # See https://github.com/jamis/bulk_insert
    comments.each do |comment|
      self.staff_audit_logs.create!(action: 'read', acted_at: current_time, auditable: comment)
    end
    comments
  end

  def check_staff_comment(comment)
    self.staff_audit_logs.create(action: 'check', acted_at: Time.zone.now, auditable: comment)
  end

  private

  def already_checked_comments
    self_checked_logs = { action: 'check', staff_user: self }
    self_checked_audit_logs = { staff_audit_logs: self_checked_logs }
    StaffComment.includes(:staff_audit_logs).where(self_checked_audit_logs)
  end

  def update_tsvector
    self.name_tsvector = build_tsvector(name)
    self.username_tsvector = build_tsvector(username)
  end

  def build_tsvector(input)
    return nil if input.blank?
    tokenizer = BigramTokenizer.new(input)
    tokenizer.build_tsvector
  end
end
