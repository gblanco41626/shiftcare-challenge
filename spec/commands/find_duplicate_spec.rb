require 'spec_helper'

RSpec.describe MyCli::Commands::FindDuplicate do
  subject(:my_command)  { described_class.new(options) }
  let(:options)         { { file: file } }
  let(:file)            { File.expand_path('../support/with_dup_email.json', __dir__) }
  let(:no_duplicate)    { File.expand_path('../support/clients.json', __dir__) }

  describe '#validate' do
    it 'does not raise error when options are complete' do
      expect { my_command.validate }.not_to raise_error
    end

    context 'when expected options is missing file' do
      let(:options) { {} }

      it 'raises error' do
        expect { my_command.validate }.to raise_error(
          MyCli::Exceptions::MissingOptionError, "Error: Please provide --file"
        )
      end
    end
  end

  describe '#execute' do
    subject  { my_command.execute }

    it 'returns email that has duplicates' do
      expect(subject).to include('jane.smith@yahoo.com')
    end

    context 'when no duplicates found' do
      let(:options) { { file: no_duplicate } }

      it { is_expected.to eq([]) }
    end

    it 'returns empty array when no duplicates found' do
      allow(MyCli::Services::JsonFetcher).to receive(:fetch).and_return([])
      result = my_command.execute

      expect(result).to eq([])
    end
  end

  describe '#run' do
    it 'prints results to output when not empty' do
      allow(my_command).to receive(:execute).and_return(['jane.smith@yahoo.com'])

      expect { my_command.run }.to output(/jane.smith@yahoo.com/).to_stdout
    end

    it "prints 'No results found' when empty" do
      allow(my_command).to receive(:execute).and_return([])

      expect { my_command.run }.to output(/No results found/).to_stdout
    end
  end
end
