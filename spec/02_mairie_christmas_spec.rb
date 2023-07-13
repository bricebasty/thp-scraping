require_relative '../lib/02_mairie_christmas'

RSpec.describe 'Mairie Christmas' do
  describe '#get_townhall_email' do
    it 'returns a hash with town name as key and email as value' do
      url = '/95/ableiges.html'
      result = get_townhall_email(url)
      expect(result).to be_a(Hash)
      expect(result.keys.first).to eq('ABLEIGES')
      expect(result.values.first).to eq('mairie.ableiges95@wanadoo.fr')
    end
  end

  describe '#get_townhall_urls' do
    it 'returns an array of hashes with town names and emails' do
      result = get_townhall_urls
      expect(result).to be_an(Array)
      expect(result).not_to be_empty
      expect(result.first).to be_a(Hash)
      expect(result.first.keys).to all(be_a(String))
      expect(result.first.values).to all(be_a(String))
    end

    it 'returns an array of hashes with the correct length' do
      result = get_townhall_urls
      expect(result.length).to eq(185)
    end
  end
end
