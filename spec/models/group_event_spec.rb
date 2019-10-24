require 'rails_helper'

describe GroupEvent, type: :model do
  it { should belong_to :creator }

  describe '#date_order validation' do 
  	context 'when start_date is after end_date' do 
  		let(:group_event) { build(:group_event, start_date: Date.today, end_date: Date.yesterday) }

  		it 'should not be valid' do
  			expect(group_event).not_to be_valid
  		end

  		it 'should add errors to start_date' do
  			group_event.valid?
  			expect(group_event.errors[:start_date]).to include 'Must be previous or equal than end date'
  		end
  	end
  end

  describe '#duration' do 
  	context 'when start_date and end_date are given' do 
  		let(:group_event) { create(:group_event, start_date: Date.today, end_date: Date.today + 2.days) }
  		
  		it 'returns the difference between them' do 
  			expect(group_event.duration).to eq 2
  		end
  	end

  	context 'when start_date is not given' do 
  		let(:group_event) { create(:group_event, start_date: nil, end_date: Date.today + 2.days) }
  		
  		it 'returns nil' do 
  			expect(group_event.duration).to eq nil
  		end
  	end

  	context 'when end_date is not given' do 
  		let(:group_event) { create(:group_event, start_date: Date.today, end_date: nil) }
  		
  		it 'returns nil' do 
  			expect(group_event.duration).to eq nil
  		end
  	end
	end

	describe '#set_start_date!' do
		let(:group_event) { create(:group_event) }
		context 'when attributes are valid' do
			before { group_event.set_start_date! end_date: Date.today + 12.days, duration: 12 }

			it 'sets start date correctly' do 
				expect(group_event.reload.start_date).to eq Date.today
			end 
		end

		context 'when end date is missing' do
			it 'raises ArgumentError' do 
				expect { group_event.set_start_date! duration: 12 }.to(
					raise_error(ArgumentError)
				)
			end 
		end

		context 'when duration is missing' do
			it 'raises ArgumentError' do 
				expect { group_event.set_start_date! end_date: Date.today + 12.days }.to(
					raise_error(ArgumentError)
				)
			end 
		end  
	end

	describe '#set_end_date!' do
		let(:group_event) { create(:group_event) }
		context 'when attributes are valid' do
			before { group_event.set_end_date! start_date: Date.today - 12.days, duration: 12 }

			it 'sets end date correctly' do 
				expect(group_event.reload.end_date).to eq Date.today
			end 
		end

		context 'when start date is missing' do
			it 'raises ArgumentError' do 
				expect { group_event.set_end_date! duration: 12 }.to(
					raise_error(ArgumentError)
				)
			end 
		end

		context 'when duration is missing' do
			it 'raises ArgumentError' do 
				expect { group_event.set_end_date! start_date: Date.today + 12.days }.to(
					raise_error(ArgumentError)
				)
			end 
		end  
	end

	describe '#publish' do
		context 'when no fields are empty' do
			let(:group_event) { create(:group_event, published: false) }

			it 'sets published to true' do 
				expect { group_event.publish }.to change { group_event.published }.from(false).to(true)
			end

			it 'returns true' do 
				expect(group_event.publish).to eq true
			end 
		end

		context 'when a field is missing' do
			let(:group_event) { create(:group_event, published: false, description: nil) }

			it 'leaves published in false' do 
				expect { group_event.publish }.not_to change { group_event.published }
			end

			it 'returns false' do 
				expect(group_event.publish).to eq false
			end
		end

	end
end
