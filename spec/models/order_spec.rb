require 'spec_helper'

describe Order do
  context "when save" do
    let(:variant) { create :variant }
    it "creates order and user" do
      order = Order.new(
        variant: variant, notes: 'some notes',
        user_attributes: { email: 'some@email', phone: '123', name: 'User' }
      )
      expect { order.save }.to change { Order.count }.by(1)
      order.reload
      order.user.should be_instance_of(User)
      order.user.should_not be_new_record
    end
    it "fails validation if user not valid" do
      expect(
        order = Order.new(
          variant: variant,
          user_attributes: { email: 'email' }
        )
      ).to have(1).error_on(:'user.email')
      expect { order.save }.not_to change { Order.count }.by(1)
    end
    let(:user) { create :user }
    it "prevents user email duplications" do
      order = Order.new(
        variant: variant,
        user_attributes: { email: user.email, phone: '123' }
      )
      expect { order.save.should be_true }.not_to change { User.count }.by(1)
      expect { user.reload }.not_to change { user.name + user.phone }
    end
    let(:order) { order = Order.new variant: variant, user_attributes: attributes_for(:user) }
    it "saves current values of user name and phone in order" do
      expect { order.save }.to change { order.user_phone and order.user_name }
    end
    it "saves current variant price in order" do
      order.save
      order.price.should == variant.price
    end
  end
  describe '#phone_number' do
    let(:order) { create :order }
    it 'return normalized phone number' do
      order = build :order, user_phone: '451234567'
      order.phone_number.should == '+380451234567'
    end
    it 'return nil if number exeeded allowed length' do
      order = build :order, user_phone: '1234567'
      order.phone_number.should be_nil
    end
  end
end
