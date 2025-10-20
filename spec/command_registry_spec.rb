require 'spec_helper'

RSpec.describe MyCli::CommandRegistry do
  it 'automatically registers command subclasses' do
    expect(described_class.commands.keys).to include('search', 'find-duplicate')
  end
end
