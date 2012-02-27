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

describe ActsAsEnumable::ModelAdditions do
  it "creates a constant given the attribute name and values" do
    User.roles.should == [:admin, :staff, :helper, :member]
    User.statuses.should == [:active, :inactive]
  end

  it "returns index of given role" do
      [:admin, :staff, :helper, :member].each_with_index do |role,i|
        User.role(role).should == i
      end
  end


  it "returns an array to be used for select" do
    User.roles_for_select("test.namespace").should == [{
      key: :admin, value: I18n.t("test.namespace.admin")
    }, {
      key: :staff, value: I18n.t("test.namespace.staff")
    }, {
      key: :helper, value: I18n.t("test.namespace.helper")
    }, {
      key: :member, value: I18n.t("test.namespace.member")
    }]

    User.statuses_for_select("test.namespace").should == [{
      key: :active, value: I18n.t("test.namespace.active")
    }, {
      key: :inactive, value: I18n.t("test.namespace.inactive")
    }]
  end


  it "assigns correct value" do
    user = User.new
    user.role.should be_nil
    user.status.should be_nil

     [:admin, :staff, :helper, :member].each_with_index do |role,i|

      user.role = role
      user.send(:read_attribute, :role).should == i
      user.role.should == role
    
    end

    user.status = :inactive
    user.send(:read_attribute, :status).should == 1
    user.status.should == :inactive
  end
  
  it "accepts assigns correctly when given role is string" do
        user = User.new
    user.role.should be_nil
    user.status.should be_nil

     [:admin, :staff, :helper, :member].each_with_index do |role,i|

      user.role = role.to_s
      user.send(:read_attribute, :role).should == i
      user.role.should == role
    end

  end

  it "handles incorrect enum values" do
    user = User.new
    user.role = "not existing role"
    user.role.should be_nil
    user.send(:read_attribute, :role).should be_nil
  end

end
