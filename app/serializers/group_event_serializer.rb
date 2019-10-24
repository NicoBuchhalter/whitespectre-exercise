class GroupEventSerializer < ActiveModel::Serializer
  attributes :id, :name, :published, :description, :start_date, :end_date, :duration, :location

  belongs_to :creator
end
