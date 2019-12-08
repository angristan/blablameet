class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_many :meetings
  has_many :active_attends, class_name: 'Attend', foreign_key: 'attendee_id', dependent: :destroy
  has_many :attending, through: :active_attends, source: :attended_meeting

  # validates :email, length: { maximum: 254 }, email: true, uniqueness: { case_sensitive: false }

  def attend(meeting)
    active_attends.create(attended_meeting_id: meeting.id)
  end

  def unattend(meeting)
    active_attends.find_by(attended_meeting_id: meeting.id).destroy
  end

  def attending?(meeting)
    attending.include?(meeting)
  end

  def upcoming_meetings
    meetings.where('date > ?', Time.now)
  end

  def past_meetings
    meetings.where('date < ?', Time.now)
  end
end
