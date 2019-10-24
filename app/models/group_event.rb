class GroupEvent < ApplicationRecord
	include Discard::Model

  belongs_to :creator, class_name: 'User'

  validate :date_order

  scope :published, -> { where(published: true) }

  def duration 
  	return nil unless start_date.present? && end_date.present?
  	(end_date - start_date).to_i
  end

  def set_start_date! end_date:, duration:
    end_date = Date.parse(end_date) if end_date.is_a? String
  	update! start_date: end_date - duration.to_i.days
  end

  def set_end_date! start_date:, duration:
    start_date = Date.parse(start_date) if start_date.is_a? String
  	update! end_date: start_date + duration.to_i.days
  end

  def publish
  	return false unless publish_allowed?
  	update! published: true
  	true
  end

  private

  def date_order
  	return if start_date.nil? || end_date.nil?
  	if start_date > end_date
  		errors.add(:start_date, 'Must be previous or equal than end date')
  	end
  end

  def publish_allowed?
  	publish_required_attributes.all?(&:present?)
  end

  def publish_required_attributes
  	[name, description, start_date, end_date, location]
  end
end
