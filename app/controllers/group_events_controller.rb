class GroupEventsController < ApplicationController

	def index
		render status: :ok, json: group_events, meta: pagination_meta(group_events)
	end

	def create
		event = GroupEvent.create(group_event_params.except(:duration))
		return render json: event.errors.messages, status: :bad_request unless event.valid?
		set_event_duration(event) if must_set_duration?
		render json: event, status: :created
	end

	def show
		render json: group_event, status: :ok
	end

	def update
		group_event.update group_event_params.except(:duration)
		return render json: group_event.errors.messages, status: :bad_request unless group_event.valid?
		set_event_duration(group_event) if must_set_duration?
		render json: group_event, status: :ok
	end

	def destroy
		group_event.discard
		head :ok
	end

	def publish
		published = group_event.publish
		return render json: group_event, status: :ok if published
		render json: { error: 'Event needs to have all of required fields to be published' }, status: :bad_request
	end

	private 

	def group_event_params
		params.require(:group_event).permit(:name, :description, :location, :start_date, :end_date, :duration, :creator_id)
	end

	def group_event
		@_group_event ||= GroupEvent.kept.find(params[:id])
	end

	def group_events
		return @_group_events if @_group_events.present?
		events = params[:published] == 'true' ? GroupEvent.kept.published : GroupEvent.kept
		@_group_events = events.includes(:creator).page(params[:page]).per(params[:per_page])
	end

	def set_event_duration event
		if params[:start_date].present?
			event.set_end_date! start_date: params[:start_date], duration: params[:duration]
		else
			event.set_start_date! end_date: params[:end_date], duration: params[:duration]
		end
	end

	# ^ is XOR operator in Ruby. If both start and end date params are present, duration will be ignored.
	def must_set_duration?
		params[:duration].present? && (params[:start_date].present? ^ params[:end_date].present?)
	end
end