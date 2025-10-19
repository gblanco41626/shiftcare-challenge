require 'spec_helper'

RSpec.describe MyCli::Services::JsonFetcher do
  let(:local_file)    { File.expand_path('../support/clients.json', __dir__) }
  let(:url)           { 'https://appassets02.shiftcare.com/manual/clients.json' }

  describe '#is_url?' do
    it 'detects HTTPS URL' do
      expect(described_class.is_url?('https://example.com')).to be(true)
    end

    it 'detects HTTP URL' do
      expect(described_class.is_url?('http://example.com')).to be(true)
    end

    it 'returns false if invalid URL' do
      expect(described_class.is_url?('htp://www.example.com')).to be(false)
    end

    it 'returns false if local file' do
      expect(described_class.is_url?(local_file)).to be(false)
    end
  end

  describe '#fetch' do
    context 'remote files' do
      it 'returns correct content' do
        allow(URI).to receive(:open).with(url).and_return(StringIO.new('[{"email": "john@example.com"}]'))

        expect(described_class.fetch(url).map{ |s| s['email'] }).to include('john@example.com')
      end

      it 'returns empty array with invalid content' do
        allow(URI).to receive(:open).with(url).and_raise(JSON::ParserError)

        expect(described_class.fetch(url)).to eq([])
      end
    end

    context 'local files' do
      it 'returns correct content' do
        allow(File).to receive(:read).with(local_file).and_return('[{"email": "john@example.com"}]')

        expect(described_class.fetch(local_file).map{ |s| s['email'] }).to include('john@example.com')
      end

      it 'returns empty array with valid path but invalid content' do
        allow(File).to receive(:read).with(local_file).and_raise(JSON::ParserError)

        expect(described_class.fetch(local_file)).to eq([])
      end

      it 'returns empty array with invalid path' do
        allow(File).to receive(:read).with(local_file).and_return(Errno::ENOENT)

        expect(described_class.fetch(local_file)).to eq([])
      end
    end
  end
end
