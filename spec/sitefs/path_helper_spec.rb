require 'spec_helper'

describe PathHelper do
  let(:root_path) { FS_TEST_DIR }
  let(:source_file) { File.join(root_path, 'gallery/photos.page.rb') }
  let(:helper) { PathHelper.new root_path, source_file }
  subject { helper }

  describe :root_path do
    let(:source_file) { 'foo' }
    subject { helper.root_path }

    it { is_expected.to be_a String }
    it { is_expected.to start_with '/' }
    it { is_expected.to include root_path }
  end

  describe :source_file do
    let(:source_file) { 'foo' }
    subject { helper.source_file }

    it { is_expected.to be_a String }
    it { is_expected.to start_with '/' }
    it { is_expected.to include root_path }
    it { is_expected.to include source_file }
  end

  describe :pathname do
    subject { helper.pathname }

    it { is_expected.to eq 'gallery/photos.page.rb' }
  end

  describe :pathname_for do
    subject { helper.pathname_for href }

    context 'basic `foo`' do
      let(:href) { 'foo' }
      it { is_expected.to eq '/gallery/foo' }
    end

    context 'parent `../foo`' do
      let(:href) { '../foo' }
      it { is_expected.to eq '/foo' }
    end

    context 'child `sub/foo`' do
      let(:href) { 'sub/foo' }
      it { is_expected.to eq '/gallery/sub/foo' }
    end

    context 'root `/foo`' do
      let(:href) { '/foo' }
      it { is_expected.to eq '/foo' }
    end
  end

  describe :min_href_for do
    subject { helper.min_href_for href }

    context 'basic' do
      let(:href) { '/gallery/foo' }
      it { is_expected.to eq 'foo' }
    end

    context 'parent' do
      let(:href) { '/foo' }
      it { is_expected.to eq '/foo' }
    end

    context 'child' do
      let(:href) { '/gallery/sub/foo' }
      it { is_expected.to eq 'sub/foo' }
    end
  end
end
