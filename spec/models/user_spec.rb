require 'rails_helper'

describe User, type: :model do
	describe 'Validations' do
		subject { create(:user) }

	  it { is_expected.to validate_uniqueness_of :email }
	  it { is_expected.to validate_presence_of :email }
	  it { should allow_value('nico.buch.1010@gmail.com').for :email }
	  it { should_not allow_value('nico.buch.1010.com').for :email }
	end
end
