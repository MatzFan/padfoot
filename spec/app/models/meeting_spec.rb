describe Meeting do

  let(:meeting) { create(:meeting) }

  it 'can be created' do
    expect(meeting).not_to be_nil
  end

end
