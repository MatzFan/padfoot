describe GazetteerFinder do
  let(:finder) { GazetteerFinder.new }

  context '#new()' do
    it 'can be instantiated with no args' do
      expect(finder.class).to eq described_class
    end
  end

  context '#results_for(search_text)' do
    it 'returns an address with valid search text' do
      expect(finder.results_for('Digimap').size).to eq 1
    end
  end
end
