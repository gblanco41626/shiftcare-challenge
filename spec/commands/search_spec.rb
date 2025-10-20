require 'spec_helper'

RSpec.describe MyCli::Commands::Search do
  subject(:my_command)  { described_class.new(options) }
  let(:file)            { File.expand_path('../support/clients.json', __dir__) }
  let(:options)         { { file: file, query: 'john' } }

  describe '#validate' do
    context 'when expected options are complete' do
      it 'does not output to stdout' do
        allow(my_command).to receive(:exit)

        expect { my_command.validate }.not_to output.to_stdout
      end

      it 'does not raise error' do
        expect { my_command.validate }.not_to raise_error
      end
    end

    context 'when expected options is missing file' do
      let(:options) { { query: 'john' } }

      it 'prints message to stdout' do
        allow(my_command).to receive(:exit)

        expect { my_command.validate }.to output(/Error: Please provide --file\. Run with -h for help\./).to_stdout
      end

      it 'exits' do
        expect { my_command.validate }.to raise_error(SystemExit)
      end
    end

    context 'when expected options is missing query' do
      let(:options) { { file: file } }

      it 'prints message to stdout' do
        allow(my_command).to receive(:exit)

        expect { my_command.validate }.to output(/Error: Please provide --query\. Run with -h for help\./).to_stdout
      end

      it 'exits' do
        expect { my_command.validate }.to raise_error(SystemExit)
      end
    end
  end

  describe '#execute' do
    subject { my_command.execute }

    context 'when with exact or partial match' do
      let(:options) { { file: file, query: 'john Doe' } }

      it { is_expected.to match_array(['John Doe', 'John Doeman']) }
    end

    context 'when no match found' do
      let(:options) { { file: file, query: 'jessica' } }

      it { is_expected.to eq([]) }
    end

    it 'return empty array when file is empty' do
      allow(MyCli::Services::JsonFetcher).to receive(:fetch).and_return([])
      result = my_command.execute

      expect(result).to match_array([])
    end
  end

  describe '#run' do
    it 'prints results to output when not empty' do
      allow(my_command).to receive(:execute).and_return(['John Doe'])

      expect { my_command.run }.to output(/John Doe/).to_stdout
    end

    it "prints 'No results found' when empty" do
      allow(my_command).to receive(:execute).and_return([])

      expect { my_command.run }.to output(/No results found/).to_stdout
    end
  end
end
