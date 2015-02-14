describe DocumentType do

  let(:doc_type) { DocumentType.create(name: 'Minutes') }

  it 'can be created' do
    expect(:doc_type).not_to be_nil
  end

end
