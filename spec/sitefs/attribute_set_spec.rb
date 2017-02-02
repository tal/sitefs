require 'spec_helper'

describe AttributeSet do
  describe :from_yaml do
    let(:yaml) do
      <<-YAML
      title: omg
      tags: one,two,three
      published: 2017-02-01
      YAML
    end

    let(:data) { AttributeSet.from_yaml yaml }

    it 'should have title' do
      expect(data['title']).to eq('omg')
    end

    it 'should have a published time' do
      expect(data.published).to be_a(Time)
    end

    it 'should have three tags' do
      expect(data['tags']).to be_a(Array)
      expect(data['tags']).to contain_exactly(*%w{one two three})
    end

  end
end