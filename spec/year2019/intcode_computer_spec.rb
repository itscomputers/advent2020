require 'year2019/intcode_computer'

describe IntcodeComputer do
  let(:computer) { IntcodeComputer.new program }
  let(:program) { [opcode, 5, 1, 4, 2, 3] }
  let(:opcode) { 1 }

  describe '#set and #get' do
    it 'can set position 2 to 1000' do
      expect(computer.memory[2]).to_not eq 1000
      expect(computer.get 2).to_not eq 1000
      computer.set 2, 1000
      expect(computer.get 2).to eq 1000
      expect(computer.memory[2]).to eq 1000
    end

    it 'can set position 500 to 1000' do
      expect(computer.memory[500]).to be_nil
      expect(computer.get 500).to eq 0
      computer.set 500, 1000
      expect(computer.get 500).to eq 1000
      expect(computer.memory[500]).to eq 1000
    end
  end

  let(:memory) { computer.advance.memory }
  let(:address) { computer.advance.address }
  let(:output) { computer.advance.output }

  describe '#add' do
    {
         1 => 3 + 5,
       101 => 5 + 5,
      1101 => 5 + 1,
      1001 => 3 + 1,
    }.each do |opcode, position_4|
      context "when opcode is #{opcode}" do
        let(:opcode) { opcode }
        it { expect(memory).to eq [opcode, 5, 1, 4, position_4, 3] }
        it { expect(address).to eq 4 }
      end
    end
  end

  describe '#multiply' do
    {
         2 => 3 * 5,
       102 => 5 * 5,
      1102 => 5 * 1,
      1002 => 3 * 1,
    }.each do |opcode, position_4|
      context "when opcode is #{opcode}" do
        let(:opcode) { opcode }
        it { expect(memory).to eq [opcode, 5, 1, 4, position_4, 3] }
        it { expect(address).to eq 4 }
      end
    end
  end

  describe '#write_from_input' do
    {
         3 => 666,
       103 => 666,
      1103 => 666,
      1003 => 666,
    }.each do |opcode, position_5|
      context "when opcode is #{opcode}" do
        let(:opcode) { opcode }
        before { computer.add_input 666 }
        it { expect(memory).to eq [opcode, 5, 1, 4, 2, position_5] }
        it { expect(address).to eq 2 }
      end
    end
  end

  describe '#write_to_output' do
    {
         4 => 3,
       104 => 5,
    }.each do |opcode, expected_output|
      context "when opcode is #{opcode}" do
        let(:opcode) { opcode }
        it { expect(output).to eq expected_output }
        it { expect(memory).to eq program }
        it { expect(address).to eq 2 }
      end
    end
  end

  describe '#jump_if_true' do
    context "example set 1" do
      {
           5 => 5,
         105 => 5,
        1105 => 1,
        1005 => 1,
      }.each do |opcode, expected_address|
        context "when opcode is #{opcode}" do
          let(:opcode) { opcode }
          it { expect(memory).to eq program }
          it { expect(address).to eq expected_address }
        end
      end
    end

    context "example set 2" do
      let(:program) { [opcode, 5, 1, 4, 2, 0] }
      { 5 => 3, 1005 => 3 }.each do |opcode, expected_address|
        context "when opcode is #{opcode}" do
          let(:opcode) { opcode }
          it { expect(memory).to eq program }
          it { expect(address).to eq expected_address }
        end
      end
    end

    context "example set 3" do
      let(:program) { [opcode, 0, 1, 4, 2, 3] }
      { 105 => 3, 1105 => 3 }.each do |opcode, expected_address|
        context "when opcode is #{opcode}" do
          let(:opcode) { opcode }
          it { expect(memory).to eq program }
          it { expect(address).to eq expected_address }
        end
      end
    end
  end

  describe '#jump_if_false' do
    context "example set 1" do
      {
           6 => 3,
         106 => 3,
        1106 => 3,
        1006 => 3,
      }.each do |opcode, expected_address|
        context "when opcode is #{opcode}" do
          let(:opcode) { opcode }
          it { expect(memory).to eq program }
          it { expect(address).to eq expected_address }
        end
      end
    end

    context "example set 2" do
      let(:program) { [opcode, 5, 1, 4, 2, 0] }
      { 6 => 5, 1006 => 1 }.each do |opcode, expected_address|
        context "when opcode is #{opcode}" do
          let(:opcode) { opcode }
          it { expect(memory).to eq program }
          it { expect(address).to eq expected_address }
        end
      end
    end

    context "example set 3" do
      let(:program) { [opcode, 0, 1, 4, 2, 3] }
      { 106 => 0, 1106 => 1 }.each do |opcode, expected_address|
        context "when opcode is #{opcode}" do
          let(:opcode) { opcode }
          it { expect(memory).to eq program }
          it { expect(address).to eq expected_address }
        end
      end
    end
  end

  describe '#less_than' do
    context "example set 1" do
      {
           7 => 1,
         107 => 0,
        1107 => 0,
        1007 => 0,
      }.each do |opcode, position_4|
        context "when opcode is #{opcode}" do
          let(:opcode) { opcode }
          it { expect(memory).to eq program.tap { |p| p[4] = position_4 } }
          it { expect(address).to eq 4 }
        end
      end
    end

    context "example set 2" do
      let(:program) { [opcode, 5, 1, 4, 2, 6] }
      { 7 => 0 }.each do |opcode, position_4|
        context "when opcode is #{opcode}" do
          let(:opcode) { opcode }
          it { expect(memory).to eq program.tap { |p| p[4] = position_4 } }
          it { expect(address).to eq 4 }
        end
      end
    end

    context "example set 3" do
      let(:program) { [opcode, 1, 5, 4, 2, 3] }
      { 107 => 1, 1107 => 1 }.each do |opcode, position_4|
        context "when opcode is #{opcode}" do
          let(:opcode) { opcode }
          it { expect(memory).to eq program.tap { |p| p[4] = position_4 } }
          it { expect(address).to eq 4 }
        end
      end
    end

    context "example set 4" do
      let(:program) { [opcode, 5, 4, 4, 2, 3] }
      { 1007 => 1 }.each do |opcode, position_4|
        context "when opcode is #{opcode}" do
          let(:opcode) { opcode }
          it { expect(memory).to eq program.tap { |p| p[4] = position_4 } }
          it { expect(address).to eq 4 }
        end
      end
    end
  end

  describe '#equals' do
    context "example set 1" do
      {
         108 => 1,
        1108 => 0,
        1008 => 0,
      }.each do |opcode, position_4|
        context "when opcode is #{opcode}" do
          let(:opcode) { opcode }
          it { expect(memory).to eq program.tap { |p| p[4] = position_4 } }
          it { expect(address).to eq 4 }
        end
      end
    end

    context "example set 2" do
      let(:program) { [opcode, 5, 1, 4, 2, 6] }
      { 8 => 0 }.each do |opcode, position_4|
        context "when opcode is #{opcode}" do
          let(:opcode) { opcode }
          it { expect(memory).to eq program.tap { |p| p[4] = position_4 } }
          it { expect(address).to eq 4 }
        end
      end
    end

    context "example set 3" do
      let(:program) { [opcode, 5, 5, 4, 2, 3] }
      { 1108 => 1 }.each do |opcode, position_4|
        context "when opcode is #{opcode}" do
          let(:opcode) { opcode }
          it { expect(memory).to eq program.tap { |p| p[4] = position_4 } }
          it { expect(address).to eq 4 }
        end
      end
    end

    context "example set 4" do
      let(:program) { [opcode, 5, 4, 4, 3, 3] }
      { 8 => 1 }.each do |opcode, position_4|
        context "when opcode is #{opcode}" do
          let(:opcode) { opcode }
          it { expect(memory).to eq program.tap { |p| p[4] = position_4 } }
          it { expect(address).to eq 4 }
        end
      end
    end

    context "example set 5" do
      let(:program) { [opcode, 5, 4, 4, 2, 3] }
      { 108 => 0 }.each do |opcode, position_4|
        context "when opcode is #{opcode}" do
          let(:opcode) { opcode }
          it { expect(memory).to eq program.tap { |p| p[4] = position_4 } }
          it { expect(address).to eq 4 }
        end
      end
    end

    context "example set 6" do
      let(:program) { [opcode, 5, 3, 4, 2, 3] }
      { 1008 => 1 }.each do |opcode, position_4|
        context "when opcode is #{opcode}" do
          let(:opcode) { opcode }
          it { expect(memory).to eq program.tap { |p| p[4] = position_4 } }
          it { expect(address).to eq 4 }
        end
      end
    end
  end
end

