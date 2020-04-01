require 'rails_helper'

RSpec.describe Raffle do
  subject(:service) { described_class }

  let(:campaign) { create(:campaign, status: :pending) }

  describe '#call' do
    context "when has more then two members" do
      before do
        campaign.members = build_list(:member, 3)
      end

      let(:results) { service.call(campaign: campaign) }

      it "results is a hash" do
        expect(results.class).to eq(Hash)
      end

      it "all members are in results as a member" do
        result_members = results.map {|r| r.first}
        expect(result_members.sort).to eq(campaign.members.sort)
      end

      it "all member are in results as a friend" do
        result_friends = results.map {|r| r.last}
        expect(result_friends.sort).to eq(campaign.members.sort)
      end

      it "a member don't get yourself" do
        results.each { |result| expect(result.first).not_to eq(result.last) }
      end

      it "a member x don't get a member y that get the member x" do
        # Desafio
      end
    end

    context "when don't has more then two members" do
      before do
        campaign.members = build_list(:member, 1)
      end

      let(:response) { service.call(campaign: campaign) }

      it "raise error" do
        expect(response).to eql(false)
      end
    end
  end
end