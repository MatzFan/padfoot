describe MeetingType do

  let(:meet_type) { MeetingType.create(name: 'PAP') }

  it 'can be created' do
    expect(meet_type).not_to be_nil
  end

end
