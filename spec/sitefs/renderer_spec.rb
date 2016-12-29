require 'spec_helper'

describe Sitefs::Renderer do
  let(:renderer) { Sitefs::Renderer.new(template) }

  context 'simple text, no context' do
    let(:template) {'My Content!!'}
    subject { renderer.render }

    it { is_expected.to be_a(Sitefs::RenderResult) }
    it { expect(subject.text).to eq(template)}
  end

  context 'simple yield' do
    let(:content) { 'My Content!!' }
    let(:template) { '<%= yield %>' }

    subject { renderer.render { content } }

    it { expect(subject.text).to eq(content) }
  end
end
