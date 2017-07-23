require 'spec_helper'

describe DiffViewer::ServerSide, model: true do
  let(:project) { create(:project, :repository) }
  let(:commit) { project.commit('570e7b2abdd848b95f2f578043fc23bd6f6fd24d') }
  let(:diff_file) { commit.diffs.diff_file_with_new_path('files/ruby/popen.rb') }

  let(:viewer_class) do
    Class.new(DiffViewer::Base) do
      include DiffViewer::ServerSide
    end
  end

  subject { viewer_class.new(diff_file) }

  describe '#prepare!' do
    it 'loads all diff file data' do
      expect(diff_file.old_blob).to receive(:load_all_data!)
      expect(diff_file.new_blob).to receive(:load_all_data!)

      subject.prepare!
    end
  end

  describe '#render_error' do
    context 'when the diff file is stored externally' do
      before do
        allow(diff_file).to receive(:stored_externally?).and_return(true)
      end

      it 'return :server_side_but_stored_externally' do
        expect(subject.render_error).to eq(:server_side_but_stored_externally)
      end
    end
  end
end
