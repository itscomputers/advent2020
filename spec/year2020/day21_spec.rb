require 'year2020/day21'

describe Year2020::Day21 do
  let(:day) { Year2020::Day21.new }
  before do
    allow(day).to receive(:raw_input).and_return <<~INPUT
      mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
      trh fvjkl sbzzf mxmxvkd (contains dairy)
      sqjhc fvjkl (contains soy)
      sqjhc mxmxvkd sbzzf (contains fish)
    INPUT
  end

  describe 'part 1' do
    subject { day.solve part: 1 }
    it { is_expected.to eq 5 }
  end

  describe 'part 2' do
    subject { day.solve part: 2 }
    it { is_expected.to eq "mxmxvkd,sqjhc,fvjkl" }
  end

  describe Year2020::Day21::Recipe do
    let(:recipe) { described_class.new string }

    context "when string has two allergens" do
      let(:string) { "mxmxvkd kfcds sqjhc nhms (contains dairy, fish)" }

      it "has the correct ingredients and allergens" do
        expect(recipe.ingredients).to eq %w(mxmxvkd kfcds sqjhc nhms).to_set
        expect(recipe.allergens).to eq %w(dairy fish).to_set
      end
    end

    context "when string has one allergen" do
      let(:string) { "sqjhc fvjkl (contains soy)" }

      it "has the correct ingredients and allergens" do
        expect(recipe.ingredients).to eq %w(sqjhc fvjkl).to_set
        expect(recipe.allergens).to eq %w(soy).to_set
      end
    end

    context "when string has zero allergens" do
      let(:string) { "sqjhc fvjkl" }

      it "has the correct ingredients and allergens" do
        expect(recipe.ingredients).to eq %w(sqjhc fvjkl).to_set
        expect(recipe.allergens).to be_empty
      end
    end
  end
end

