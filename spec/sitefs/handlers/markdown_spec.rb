require 'spec_helper'

describe Handlers::Markdown do
  let(:source) { File.join(FS_TEST_DIR, 'single-markdown.page.md') }
  let(:handler) { Handlers::Markdown.new FS_TEST_DIR, source }

  describe :output_path do
    subject { handler.output_path }

    it {is_expected.to eq(File.join(FS_TEST_DIR,'single-markdown.html'))}
  end

  describe :config_strings do
    subject { handler.config_strings }

    it {is_expected.to all(be_a(String))}
    it {is_expected.to_not be_empty}
  end

  describe :markdown do
    subject { handler.markdown }

    it {is_expected.to be_a(String)}
    it {is_expected.to_not be_empty}
  end

  describe :output do
    subject { handler.output }

    it {is_expected.to be_a(String)}
    it {is_expected.to_not be_empty}
    it {is_expected.to_not include('<!DOCTYPE html>')}
    it {is_expected.to include_exactly_once('<img src="ears.png" alt="alt">')}
  end

  describe :_render do

    subject { handler._render(context) }

    context 'nil context' do
      let(:context) {nil}

      it {is_expected.to be_a(String)}
      it {is_expected.to include_exactly_once('<!DOCTYPE html>')}
      it {is_expected.to include_exactly_once('<img src="ears.png" alt="alt">')}
      it {is_expected.to include_exactly_once('<div class="markdown-post">')}
    end
  end

  describe :page do
    subject { handler.pages.first }

    it { expect(subject.path).to eq('/single-markdown') }
    it { expect(subject.title).to eq('Title') }
    it { expect(subject.subtitle).to eq('Subtitle') }
    it { expect(subject.description).to eq('Body') }
    it { expect(subject.published_at).to eq(Time.new('2016-12-22 12:32pm')) }
    it { expect(subject.tags).to match_array ['test 12', 'oneword'] }
  end

  context 'advanced features' do
    let(:source) { File.join(FS_TEST_DIR, 'advanced-md.page.md') }

    describe :output do
      subject { handler.output }

      context 'nil context' do
        it {is_expected.to include_exactly_once('<pre class="highlight highlight-ruby"><code>')}
        it {is_expected.to include_exactly_once('<a href="http://google.com">')}
      end
    end
  end

end
