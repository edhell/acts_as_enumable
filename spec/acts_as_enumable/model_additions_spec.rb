# encoding: utf-8
require "spec_helper"

class User < SuperModel::Base
  def role
    read_attribute(:role)
  end

  def role=(val)
    write_attribute(:role, val)
  end

  extend ActsAsEnumable::ModelAdditions
  acts_as_enumable :role, %w(admin staff helper member)
  acts_as_enumable :status, %w(active inactive)
end

  describe User do
    context "class methods" do
      context "returns array of enum names" do
        subject{ described_class }

        its(:roles){ should eq [:admin, :staff, :helper, :member] }
        its(:statuses){ should eq [:active, :inactive] }
      end

      context "returns correct index for given enum name" do
        it "role" do
          [:admin, :staff, :helper, :member].each_with_index do |role,i|
             described_class.role(role).should eq i 
          end
        end

        it "status" do
          [:active, :inactive].each_with_index do |status,i|
            described_class.status(status).should eq i
          end
        end
      end
    
    context "returns nil for incorrect argument" do
      it "role" do
        described_class.role(nil).should be_nil
        described_class.role(12312312).should be_nil
        described_class.role(:i_cant_read).should be_nil
        described_class.role("cats? I'm a kitty cat").should be_nil
        
      end

      it "status" do
        described_class.status(nil).should be_nil
        described_class.status(12312312).should be_nil
        described_class.status(:i_cant_read).should be_nil
        described_class.status("cats? I'm a kitty cat").should be_nil

      end
    end

    context "returns hash of enum names for select_options in given I18 namespace" do
      it "roles_for_select" do
        described_class.roles_for_select("test.namespace").should eq(
            [{
              key: :admin, value: I18n.t("test.namespace.admin")
            }, {
              key: :staff, value: I18n.t("test.namespace.staff")
            }, {
              key: :helper, value: I18n.t("test.namespace.helper")
            }, {
              key: :member, value: I18n.t("test.namespace.member")
            }]
            )
      end
      it "statuses_for_select" do
        described_class.statuses_for_select("test.namespace").should eq(
            [{
              key: :active, value: I18n.t("test.namespace.active")
            }, {
              key: :inactive, value: I18n.t("test.namespace.inactive")
            }]
            )
      end
    end

    end
  end



describe User do
    let(:instance){
        described_class.new
      }

  context "assigns correct value" do
    subject{ instance }
    its(:role){ should be_nil }
    its(:status){ should be_nil }

      it "role=" do
        [:admin, :staff, :helper, :member].each_with_index do |role,i|
          instance.role = role
          instance.send(:read_attribute, :role).should eq i
          instance.role.should eq role
        end
      end
      it "status=" do
        [:active, :inactive].each_with_index do |status,i|
          instance.status = status
          instance.send(:read_attribute, :status).should eq i
          instance.status.should eq status
        end
      end
  end
  

  it "accepts assigns correctly when given is role index" do
    instance.role.should be_nil
    instance.status.should be_nil

     [:admin, :staff, :helper, :member].each_with_index do |role,i|

      instance.role = i
      instance.send(:read_attribute, :role).should == i
      instance.role.should == role
    end

  end

  it "sets enum to nil when given index is out of range" do
    instance.role.should be_nil
    instance.status.should be_nil
    
    size = described_class.roles.size

    instance.role = size
    instance.send(:read_attribute, :role).should be_nil
    instance.role.should be_nil

  end

  it "handles incorrect enum values" do
    instance.role = "not existing role"
    instance.role.should be_nil
    instance.send(:read_attribute, :role).should be_nil
  end

end
