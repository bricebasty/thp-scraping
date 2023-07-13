require 'rspec'
require 'nokogiri'
require_relative '../lib/03_cher_depute.rb'

RSpec.describe 'Deputy' do
  describe '#get_deputy_info' do
    it 'returns the correct deputy information' do
      deputy_url = '/deputes/fiche/OMC_PA605036'
      deputy_info = get_deputy_info(deputy_url)

      expect(deputy_info).to be_a(Hash)
      expect(deputy_info).to have_key('first_name')
      expect(deputy_info).to have_key('last_name')
      expect(deputy_info).to have_key('email')
    end
  end

  describe '#get_deputy_urls' do
    it 'returns an array of deputy hashes' do
      deputy_hashes = get_deputy_urls

      expect(deputy_hashes).to be_an(Array)
      expect(deputy_hashes.all? { |h| h.is_a?(Hash) }).to be true
      expect(deputy_hashes.all? { |h| h.key?('first_name') }).to be true
      expect(deputy_hashes.all? { |h| h.key?('last_name') }).to be true
      expect(deputy_hashes.all? { |h| h.key?('email') }).to be true
    end
  end
end
