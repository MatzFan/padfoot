describe 'AppCategory Model' do

  let(:app_category) { AppCategory.create(code: 'P', name: 'Planning') }

  it 'can be created' do
    expect(app_category).not_to be_nil
  end

end
