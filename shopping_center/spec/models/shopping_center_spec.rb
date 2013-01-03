require 'spec_helper'

describe ShoppingCenter do
  subject { Factory.create(:shopping_center) }

  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'associations' do
    it { should embed_one(:address) }
    it { should embed_many(:tenants) }
    it { should embed_many(:comments) }
    it { should embed_many(:assets) }
    it { should belong_to(:researcher) }
    it { should belong_to(:research_manager) }

    describe 'address' do
      it 'should allow nested attributes'
      it 'should allow _destroy'
    end


    describe 'tenants' do
      it 'should allow nested attributes'
      it 'should allow _destroy'
    end

    describe 'equity_owners' do
      it 'should allow nested attributes'
      it 'should allow _destroy'
      it 'should not allow total equity ownership greater than 100%'
    end

    describe 'assets' do
      it 'should allow nested attributes'
      it 'should allow _destroy'
    end
  end

  describe 'methods' do
    describe '.anchor_tenants' do
      it 'should only return tenants that respond true to anchor?' do
        subject.tenants.count.should == 0
        expect { subject.tenants.create(Factory.attributes_for(:anchor_tenant)) }.to change{ subject.anchor_tenants.count }.by(1)
        expect { subject.tenants.create(Factory.attributes_for(:tenant)) }.to_not change{ subject.anchor_tenants.count }
        expect { subject.tenants.create(Factory.attributes_for(:anchor_tenant)) }.to change{ subject.anchor_tenants.count }.by(1)

        subject.tenants.to_a.count.should == 3
        subject.anchor_tenants.to_a.count.should == 2
      end
    end

    describe '.keywords' do
      before do
        @sc = Factory.build(:shopping_center)
        @sc.name = "Lakeline Mall"
        @sc.address = Address.new(street_number: 1234, street: 'Cypress Creek Rd', municipality: "Cedar Park", governing_district: "TX", postal_code: 78613)
        @sc.tenants.build(Factory.attributes_for(:tenant, name: "Sears"))
        @sc.tenants.build(Factory.attributes_for(:tenant, name: "Banana Republic"))
        @sc.tenants.build(Factory.attributes_for(:anchor_tenant, name: "Kohls"))
        @sc.equity_owners.build(Factory.attributes_for(:equity_owner, name: "Kimco Realty"))
        @sc.researcher = Factory.build(:researcher, first_name: "Fozzy", last_name: "Bear" )
        @sc.research_manager = Factory.build(:research_manager, first_name: "Kermit", last_name: "The Frog" )
      end
      subject { @sc }

      it "should include the name field in the keywords list" do
        subject.keywords.include?("Lakeline").should == true
        subject.keywords.include?("Mall").should == true
      end

      context 'if address is not nil' do
        it "should include the addresses munincipality, governing_district, and postal_code fields in the keywords list" do
          subject.keywords.include?("Cedar").should == true
          subject.keywords.include?("Park").should == true
          subject.keywords.include?("TX").should == true
          subject.keywords.include?("78613").should == true
        end
      end

      context 'if address is nil' do
        it 'should not raise an error when calling keywords method' do
          lambda {subject.keywords}.should_not raise_error
        end
      end

      it "should include the tenants names field in the keywords list" do
        subject.keywords.include?("Sears").should == true
        subject.keywords.include?("Banana").should == true
        subject.keywords.include?("Republic").should == true
        subject.keywords.include?("Kohls").should == true
      end

      it "should include the equity owner names in the keywords list" do
        subject.keywords.include?("Kimco").should == true
        subject.keywords.include?("Realty").should == true
      end

      it "should include the researcher name in the keywords list" do
        subject.keywords.include?("Fozzy").should == true
        subject.keywords.include?("Bear").should == true
      end

      it "should include the researcher manager name in the keywords list" do
        subject.keywords.include?("Kermit").should == true
        subject.keywords.include?("The").should == true
        subject.keywords.include?("Frog").should == true
      end
    end
  end

  describe 'class methods' do
    describe '.event_translator' do
      it 'should remove prefix designated by scsm_ (shopping center state machine)' do
        ShoppingCenter.event_translator(:scsm_first).should == :first
      end

      it "should not remove the characters scsm_ if they're not achored to front" do
        ShoppingCenter.event_translator(:first_scsm).should == :first_scsm
      end
    end
  end

  describe 'scopes' do
    before :all do
      4.times { Factory.create(:waiting_on_researcher_shopping_center) }
      3.times { Factory.create(:waiting_on_manager_shopping_center) }
      1.times { Factory.create(:incomplete_shopping_center) }
      2.times { Factory.create(:searchable_shopping_center) }
    end

    describe '#waiting_on_researcher' do
      it "should return all of the shopping centers considered to be in a researcher action state" do
        #in this case any that are waiting_on_researcher or incomplete
        ShoppingCenter.waiting_on_research_manager.count == 5
      end
    end

    describe '#waiting_on_research_manager' do
      it "should return all of the shopping centers considered to be in a reserach_manager action state" do
        ShoppingCenter.waiting_on_research_manager.count == 3
      end
    end

    context 'that take a list of users' do
      before :each do
        3.times do
          rg = Factory.create(:research_group)
          researcher = Factory.create(:researcher, research_group: rg)
          research_manager = Factory.create(:research_manager, research_group: rg)

          rand(4).times do
            Factory.create(:shopping_center, researcher: researcher, research_manager: research_manager)
          end
        end
      end

      describe '#verified_by' do
        it "should return an empty list if no research managers are provided" do
          ShoppingCenter.verified_by.should be_empty
        end

        it "should return all of the shopping centers assiged to a variable list of research_managers" do
          ResearchManager.all.each do |rm|
            ShoppingCenter.verified_by(rm).count.should  == rm.shopping_centers.count
          end

          rms = [ResearchManager.first, ResearchManager.last]
          ShoppingCenter.verified_by(*rms).count.should == rms.collect{ |rm| rm.shopping_centers }.flatten.count

          ShoppingCenter.verified_by(*ResearchManager.all).count.should == ShoppingCenter.all.count
        end
      end

      describe '#collected_by' do
        it "should return an empty list if no researchers are provided" do
          ShoppingCenter.collected_by.should be_empty
        end

        it "should return all of the shopping centers assiged to a variable list of research" do

          Researcher.all.each do |r|
            ShoppingCenter.collected_by(r).count.should  == r.shopping_centers.count.should
          end

          rs = [Researcher.first, Researcher.last]
          ShoppingCenter.collected_by(*rs).count.should == rs.collect{ |r| r.shopping_centers }.flatten.count

          ShoppingCenter.collected_by(*Researcher.all).count.should == ShoppingCenter.all.count
        end
      end
    end
  end
end
