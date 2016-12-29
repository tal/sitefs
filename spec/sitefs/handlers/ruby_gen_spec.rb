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


end
