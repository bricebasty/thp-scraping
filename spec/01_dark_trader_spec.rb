require 'rspec'
require_relative '../lib/01_dark_trader.rb'

RSpec.describe 'Scraping Coin Market Cap' do
  it 'returns an array of hashes' do
    result = scrape_cmc
    expect(result).to be_an(Array)
    expect(result).to all(be_a(Hash))
  end

  it 'contains the same number of elements as the names array' do
    result = scrape_cmc
    names = result.map(&:keys).flatten
    expect(result.length).to eq(names.length)
  end

  it 'has string keys and float values' do
    result = scrape_cmc
    expect(result.first.keys).to all(be_a(String))
    expect(result.first.values).to all(be_a(Float))
  end

  it 'includes Bitcoin in the names array' do
    result = scrape_cmc
    names = result.map(&:keys).flatten
    expect(names).to include('BTC')
  end

  it 'includes Ethereum in the names array' do
    result = scrape_cmc
    names = result.map(&:keys).flatten
    expect(names).to include('ETH')
  end
end
