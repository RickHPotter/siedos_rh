# Contact Model
class Contact < ApplicationRecord
  belongs_to :employee
  before_validation :format_number

  validates :phone, :mobile_phone, presence: true, format: {
    with: /\A\d+\z/, message: I18n.t('errors.invalid') 
  }, length: { minimum: 8, maximum: 12 }

  validates :email, presence: true, uniqueness: true, format: {
    with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
    message: I18n.t('errors.invalid')
  }, length: { minimum: 8, maximum: 36 }

  validates :phone, :mobile_phone, uniqueness: { scope: :employee_id }

  # TODO: refactor these two or use a gem for the dirty job
  def phone_human
    format_number
    phone = self.phone
    case self.phone.length
    when 8
      phone = "#{phone[0..3]} #{phone[4..7]}"
    when 9
      phone = "#{phone[0]} #{phone[1..4]} #{phone[5..8]}"
    when 10
      phone = "(#{phone[0..1]}) #{phone[2..5]} #{phone[6..9]}"
    when 11 # messed up
      phone = "(#{phone[0..2]}) #{phone[3..6]} #{phone[7..10]}"
    when 12 # i dont even know
      phone = "(#{phone[0..2]}) #{phone[3..7]} #{phone[8..11]}"
    end

    phone
  end

  def mobile_phone_human
    format_number
    phone = self.mobile_phone
    case self.mobile_phone.length
    when 8
      phone = "#{phone[0..3]} #{phone[4..7]}"
    when 9
      phone = "#{phone[0]} #{phone[1..4]} #{phone[5..8]}"
    when 10 # missing required 9
      phone = "(#{phone[0..1]}) 9 #{phone[2..5]} #{phone[6..9]}"
    when 11
      phone = "(#{phone[0..1]}) #{phone[2]} #{phone[3..6]} #{phone[7..10]}"
    when 12 # unnecessary 0, like (062)
      phone = "(#{phone[1..2]}) #{phone[3]} #{phone[4..7]} #{phone[8..11]}"
    end

    phone
  end

  private

  def format_number
    self.phone = phone.gsub(/[^\d]/, '') if phone.present?
    self.mobile_phone = mobile_phone.gsub(/[^\d]/, '') if mobile_phone.present?
  end
end

