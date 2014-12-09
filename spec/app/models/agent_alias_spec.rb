describe 'AgentAlias Model' do

  let(:agent_alias) { AgentAlias.create(name: 'Riva Architects') }

  it 'can be created' do
    expect(agent_alias).not_to be_nil
  end

end
