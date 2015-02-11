describe 'Status Model' do

  let(:status) { Status.create(name: 'Pending') }

  it 'can be created' do
    expect(status).not_to be_nil
  end

end
