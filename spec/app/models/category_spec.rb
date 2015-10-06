describe 'Category Model' do

  let(:category) { Category.create(code: 'P') }

  it 'can be created' do
    expect(category).not_to be_nil
  end

end
