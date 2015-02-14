describe Document do

  let(:doc) { build(:document) }
  let(:meeting) { create(:meeting) }

  context '#new' do
    it 'can be created from a meeting' do
      meeting
      Meeting.first.add_document(doc)
      expect(Document.count).to eq(1)
    end

    it 'will have :type field set' do
      meeting
      Meeting.first.add_document(doc)
      expect(Document.first.type).not_to be_nil
    end

    it 'meeting_id will be nil if the parent meeting does not exist' do
      doc.save
      expect(doc.meeting_id).to be_nil
    end
  end

end
