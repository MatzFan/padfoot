describe Mappable do
  extender = class Extender; extend Mappable; end
  let(:xys) { [[38818.777146, 71930.481571], [38431.026905, 71020.6382], [39718.715094, 71120.14873], [38818.777146, 71930.481571]] }
  let(:xys_arr) { [[[0,0],[1,1],[1,2],[0,0]],[[2,3],[3,2],[5,4],[2,3]]] }
  let(:line_string) { "'LINESTRING(38818.777146 71930.481571, 38431.026905 71020.6382, 39718.715094 71120.14873, 38818.777146 71930.481571)'"}
  let(:multiline_string) { "'MULTILINESTRING((0 0, 1 1, 1 2, 0 0), (2 3, 3 2, 5 4, 2 3))'"}
  # let(:multipolygon) { "SELECT ST_GeomFromText('MULTIPOLYGON(((0 0, 1 1, 1 2, 0 0), (2 3, 3 2, 5 4, 2 3)))', 3109)"}
  let(:multipolygon) { "'MULTIPOLYGON(((0 0, 1 1, 1 2, 0 0), (2 3, 3 2, 5 4, 2 3)))'"}

  context '.transform' do
    it 'transforms 2 arrays of lats, longs to a 2D array of 31909 x y coordiantes' do
      lats = [49.2423570821659, 49.23417522262926, 49.23507193090019, 49.2423570821659]
      longs = [-2.1512220001220683, -2.156543502807615, -2.1388623809814433, -2.1512220001220683]
      expect(extender.transform(lats, longs)).to eq(xys)
    end
  end

  context '.line_string' do
    it 'returns text representation of a PostGIS linestring' do
      expect(extender.line_string(xys)).to eq(line_string)
    end
  end

  context '.multi_line_string' do
    it 'returns text representation of a PostGIS multilinestring' do
      expect(extender.multiline_string(xys_arr)).to eq(multiline_string)
    end
  end

  # context '.multipolygon' do # Sequel 5 breaks
  #   it 'returns a Sequel::Postgres::Dataset representing a PostGIS multipolygon class' do
  #     expect(extender.multipolygon(xys_arr).class).to eq(Sequel::Postgres::Dataset)
  #   end
  # end
end
