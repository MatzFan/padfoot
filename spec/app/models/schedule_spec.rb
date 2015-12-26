describe Schedule do

  let(:schedule) { Schedule.create(days: 'Monday-Friday') }

  it 'can be created' do
    expect(schedule).not_to be_nil
  end

end
