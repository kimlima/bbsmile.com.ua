require 'rails_helper'

describe CategoriesHelper do
  describe "#category_menu_items" do
    context 'category with children assings' do
      let(:category) { create :category, children_count: 3 }
      before { assign(:category, category) }
      it "returns category children " do
        expect(helper.category_menu_items).to eq(category.children.visible.includes(:page))
      end
      context "hidden children" do
        let(:category) {
          category = create(:category)
          category.children.create attributes_for(:hidden_category)
          category
        }
        it "it not include hidden categories " do
          expect(helper.category_menu_items).to be_empty
        end
      end
    end

    context 'category without children assings' do
      let(:category) { create :category, children_count: 3 }
      before { assign(:category, category.children.second) }
      it "returns category siblings" do
        expect(helper.category_menu_items).to eq(category.children.visible.includes(:page))
      end
    end
  end

  # TODO finish spec
  # describe "#price_sortable_link_to" do
  #   before :all do
  #     helper.stub!(:params).and_return({slug: 'some/category'})
  #   end
  #   subject { helper.price_sortable_link_to }
  #   it "return ascending price sort link by default" do
  #     should include('direction=asc', 'active')
  #   end
  # end
end
