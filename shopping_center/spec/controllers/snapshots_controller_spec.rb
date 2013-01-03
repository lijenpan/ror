require 'spec_helper'

describe SnapshotsController do
  before :each do
    login_admin
  end

  describe "shopping_centers" do
    subject { Factory.create(:shopping_center) }
    let(:now) { DateTime.now.to_i }

    before(:each) { get :snapshot, shopping_center_id: subject.id, created_at: now }

    it { assigns(:snapshotable).should eq(subject) }
    it { assigns(:snapshot).should_not be_nil }
  end

  describe "retailers" do
    subject { Factory.create(:retailer) }
    let(:now) { DateTime.now.to_i }

    before(:each) { get :snapshot, retailer_id: subject.id, created_at: now }

    it { assigns(:snapshotable).should eq(subject) }
    it { assigns(:snapshot).should_not be_nil }
  end
end
