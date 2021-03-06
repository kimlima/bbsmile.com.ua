require 'rails_helper'

describe Category do
  context 'when save' do
    it 'create record with page' do
      expect {
        category = Category.create(
          leaf: true,
          page_attributes: { title: 'Some category', url: 'some/url' }
        )
      }.to change { Category.count }.by(1)
    end

    context "updated_at" do
      let(:category) { create :category }
      it "page has same as category time updated at" do
        page = category.page
        page.update updated_at: 1.day.ago
        category.update leaf: !category.leaf
        expect(page.updated_at.to_s).to eq(category.updated_at.to_s)
      end
    end
    it 'not create record if invalid data' do
      category = build :category, page_attributes: { title: 'valid', url: '' }
      expect { category.save }.not_to change { Category.count }
    end
    it 'update category title' do
      category = create :category
      old_title = category.page.title
      category.update_attributes page_attributes: attributes_for(:page)
      expect(category.save).to be_truthy
      expect(category.page.title).to_not eq(old_title)
    end

    let(:leaf_category) { create :leaf_category }
    it "disallow set leaf parent" do
      category = build :category
      category.parent = leaf_category
      expect(category).to have(1).error_on(:parent)
    end
  end

  context 'ancestry' do
    subject { Category }
    its(:arrange) { should respond_to :each }
    it 'create children' do
      category = create :category
      child = Category.new(
        parent: category,
        page_attributes: attributes_for(:page)
      )
      expect { child.save }.to change { category.children.count }
    end
  end

  context 'acts as list' do
    let(:category) { create :category, children_count: 2 }
    context 'when create new record' do
      it 'sorted to the end of the list' do
        subcategory = create :category, parent: category
        expect(subcategory.position).to eq(3)
        expect(subcategory.lower_items).to be_empty
      end
      # add another category as noise for testing sorting scope
      let(:another_category) { create :category, children_count: 2 }
      describe '#insert_at' do
        it 'create record in given position' do
          second_subcategory = category.children.second
          subcategory = create :category, parent: category
          subcategory.insert_at(2)
          expect(subcategory).to_not be_a_new(Category)
          expect(subcategory.position).to eq(2)
          expect { second_subcategory.reload }.to change {
            second_subcategory.position
          }.to(3)
          expect { another_category.reload }.not_to change {
            another_category.children.first
          }
        end
      end
    end
  end

  context 'when category is leaf' do
    describe 'save' do
      let(:leaf_category) { create :leaf_category }
      it 'not allow add children' do
        expect {
          create :category, parent: leaf_category
        }.to raise_error(ActiveRecord::ActiveRecordError)
        expect {
          leaf_category.reload
        }.not_to change { leaf_category.is_childless? }
      end
    end
  end

  describe "content relation" do
    let(:category) { create :category_with_content }
    it 'has content' do
      expect(category.content.text).to be
    end
  end

  describe '.destroy' do
    it 'allow destroy model' do
      category = create :category
      category.destroy
      expect { category.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
    it 'disallow destroy model with children' do
      category = create :category, children_count: 3
      expect { category.destroy }.to raise_error(Ancestry::AncestryException)
    end
  end

  describe "#find_price_ranges" do
    let(:category) { create :category_with_price_ranges, children_count: 3 }
    context "when category has price ranges" do
      subject { category.find_price_ranges }
      it "return price ranges" do
        should == category.price_ranges
      end
    end
    context "when category has no price ranges" do
      subject { category.children.sample.find_price_ranges }
      it "return parent category price ranges" do
        should == category.price_ranges
      end
    end
  end

  context "when search" do
    before do
      create_list :category, 3
      @matched = create :category, page_title: 'test'
    end
    describe "#by_title" do
      subject { Category.visible.by_title('test') }
      it { should be_an ActiveRecord::Relation }
      it "include matched page" do
        should include(@matched)
      end
    end
  end

  describe "#novelties" do
    let!(:category) { create :category, leaf: false }
    subject { category.novelties }
    it { should be_an ActiveRecord::Relation }
  end
  describe "#hits" do
    let!(:category) { create :category, leaf: false }
    subject { category.hits }
    it { should be_an ActiveRecord::Relation }
  end
  describe "#discounts" do
    let!(:category) { create :category, leaf: false }
    subject { category.discounts }
    it { should be_an ActiveRecord::Relation }
  end
end
