describe 'Application Model' do

  let(:application) { create(:application) }

  describe '#create' do
    it 'can be created' do
      expect(application).not_to be_nil
    end
  end

end
