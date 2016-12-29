require 'spec_helper'

describe RendererPipeline do
  describe 'basic pipeline' do
    let(:pipeline) { RendererPipeline.new(first, second, third) }
    subject { pipeline.render }

    describe 'renderers' do
      let(:first) { Renderer.new('<first><%= yield %></first>') }
      let(:second) { Renderer.new('<second><%= yield %></second>') }
      let(:third) { Renderer.new('<third/>') }

      it { should eq('<first><second><third/></second></first>')}
    end

    describe 'strings' do
      let(:first) { '<first><%= yield %></first>' }
      let(:second) { '<second><%= yield %></second>' }
      let(:third) { '<third/>' }

      it { should eq('<first><second><third/></second></first>')}
    end
  end

  describe 'other yields' do

    let(:content) { 'My Content!!!' }
    let(:content_for_test) { 'My Content for test!!!' }

    let(:pipeline) { RendererPipeline.new('<%= yield :test %><%= yield %>', content) }

    subject { pipeline.render(context) }

    context 'valid context' do
      let(:context) do
        ctx = double('Context')
        ctx.should_receive(:_get_content_for).with(:test).and_return(content_for_test)
        ctx
      end

      it { should eq(content_for_test + content) }
    end

    context 'nil context value' do
      let(:context) do
        ctx = double('Context')
        ctx.should_receive(:_get_content_for).with(:test).and_return(nil)
        ctx
      end

      it { should eq(content) }
    end

  end


  describe '#possible_files_for' do
    let(:root_path) { FS_TEST_DIR }
    let(:source_file) { File.join(FS_TEST_DIR, 'dir/sub1/sub2/deep-page.page.md') }

    let(:expected_files) do
      [
        File.join(FS_TEST_DIR, 'dir/sub1/_layout.html.erb'),
        File.join(FS_TEST_DIR, '_layout.html.erb'),
      ]
    end

    it { RendererPipeline.possible_files_for(root_path: root_path, source_file: source_file).should eq(expected_files) }

    context 'other template names' do
      let(:layout_name) { '_layout.md.html.erb' }

      let(:expected_files) do
        [
          File.join(FS_TEST_DIR, 'dir/_layout.md.html.erb'),
          File.join(FS_TEST_DIR, '_layout.md.html.erb'),
        ]
      end

      it do
        RendererPipeline.possible_files_for(
          root_path: root_path,
          source_file: source_file,
          layout_name: layout_name,
        ).should eq(expected_files)
      end
    end
  end
end
