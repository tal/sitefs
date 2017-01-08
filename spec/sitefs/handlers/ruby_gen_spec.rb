require 'spec_helper'

describe Handlers::RubyGen do
  let(:source) { File.join(FS_TEST_DIR, 'gallery/photos.page.rb') }
  let(:handler) { Handlers::RubyGen.new FS_TEST_DIR, source }

  describe :pages do
    subject { handler.pages }

    it { is_expected.to_not be_empty }
    it { is_expected.to all be_a(Page) }
    it { expect(subject.length).to be 4 }

    it 'should have 3 pages that are images' do
      image_pages = subject.select {|p| p.tags.include?('_image')}

      expect(image_pages.length).to be 3
    end

    it 'should have 1 page that isn\'t an image' do
      image_pages = subject.select {|p| !p.tags.include?('_image')}

      expect(image_pages.length).to be 1
    end

    describe :_rendering_template do
      subject { handler.pages.map(&:_rendering_template).compact }

      it { expect(subject.length).to be 4 }
    end
  end # pages

  describe 'paths' do
    subject { handler.pages.map(&:path) }

    it { expect(subject).to contain_exactly "/gallery/Screen Shot 2016-04-21 at 5.57.53 PM", "/gallery/Screen Shot 2016-04-25 at 2.06.46 PM", "/gallery/Screen Shot 2016-04-27 at 9.31.28 PM", "/gallery/index" }
  end

  describe :file_actions do
    let(:registry) { FileRegistry.new.tap {|r| r << handler } }

    subject { registry.gather_actions }

    it { expect(subject.count).to be 4 }

    it { expect(subject.first.path).to eq '/Users/tal/Projects/sitefs/inline-site/gallery/Screen Shot 2016-04-21 at 5.57.53 PM/index.html' }
  end

end
