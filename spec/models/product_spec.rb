require 'rails_helper'

RSpec.describe Product, type: :model do
  let(:product) { FactoryGirl.build :product }
  subject { product }

  it { should respond_to(:title) }
  it { should respond_to(:price) }
  it { should respond_to(:published) }
  it { should respond_to(:user_id) }

  # it { should not_be_published }

  it { should validate_presence_of :title }
  it { should validate_presence_of :price }
  it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
  it { should validate_presence_of :user_id }

  it { should belong_to :user }

  describe "filters" do
    before(:each) do
      @product1 = FactoryGirl.create :product, title: "A plasma TV", price: 100
      @product2 = FactoryGirl.create :product, title: "Fastest laptop", price: 50
      @product3 = FactoryGirl.create :product, title: "CD player", price: 150
      @product4 = FactoryGirl.create :product, title: "LCD TV", price: 99
    end

    describe ".filter_by_title" do
      context "when a 'TV' title pattern is sent" do
        it "returns the 2 products matching" do
          expect(Product.filter_by_title("TV").size).to eql(2)
        end

        it "returns the products matching" do
          expect(Product.filter_by_title("TV")).to match_array([@product1, @product4])
        end
      end
    end

    describe ".above_or_equal_to_price" do
      it "retursn the products which are above or equal to the price" do
        expect(Product.above_or_equal_to_price(100).sort).to match_array([@product1, @product3])
      end
    end

    describe ".below_or_equal_to_price" do
      it "retursn the products which are below or equal to the price" do
        expect(Product.below_or_equal_to_price(100).sort).to match_array([@product1, @product2, @product4])
      end
    end

    describe ".recent" do
      before(:each) do
        @product2.touch
        @product3.touch
      end

      it "returns the most updated records" do
        expect(Product.recent).to match_array([@product3, @product2, @product4, @product1])
      end
    end
  end

end
