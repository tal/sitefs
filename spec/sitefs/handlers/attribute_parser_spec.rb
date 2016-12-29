require 'spec_helper'

shared_examples 'an attribute parser' do
  let(:parser) { described_class.new(attribute_string) }

  it { parser.key.should eq(attribute_key) }
  it { parser.value.should eq(attribute_value) }
end

describe AttributeParser do
  context 'published' do
    let(:attribute_string) { '@published(2015-11-22)' }
    let(:attribute_value) { Time.new('2015-11-22') }
    let(:attribute_key) { 'published' }

    it_behaves_like 'an attribute parser'
  end

  context 'implicit true' do
    let(:attribute_string) { '@is_true' }
    let(:attribute_value) { true }
    let(:attribute_key) { 'is_true' }

    it_behaves_like 'an attribute parser'
  end

  context 'explicit true' do
    let(:attribute_string) { '@is_true(true)' }
    let(:attribute_value) { true }
    let(:attribute_key) { 'is_true' }

    it_behaves_like 'an attribute parser'
  end

  context 'explicit false' do
    let(:attribute_string) { '@is_false(false)' }
    let(:attribute_value) { false }
    let(:attribute_key) { 'is_false' }

    it_behaves_like 'an attribute parser'
  end

  context 'arbitrary atring' do
    let(:attribute_string) { '@arbitrary(string)' }
    let(:attribute_value) { 'string' }
    let(:attribute_key) { 'arbitrary' }

    it_behaves_like 'an attribute parser'
  end
end
