RSpec.describe Owners do
  describe '.for' do
    subject { described_class.for(*paths) }

    context 'with one path' do
      let(:paths) { ['example/app/controllers/users_controller.rb'] }

      it 'parses owners correctly' do
        expect(subject).to eq(['@org/auth', '@org/blog'])
      end
    end

    context 'with multiple paths' do
      let(:paths) {[
        'example/app/controllers/posts_controller.rb',
        'example/app/models/user.rb',
      ]}

      it 'parses owners correctly' do
        expect(subject).to eq(['@org/auth', '@org/blog', 'data@example.com'])
      end
    end

    context 'with no matches' do
      let(:paths) { ['some-path-without-owners'] }

      it 'parses owners correctly' do
        expect(subject).to be_empty
      end
    end

    context 'with a regex matcher' do
      let(:paths) { ['example/app/models/blog.rb'] }

      it 'parses owners correctly' do
        expect(subject).to eq(['@blogger', '@org/blog', 'data@example.com'])
      end
    end

    context 'with a rule containing whitespace' do
      let(:paths) { ['example/app/models/post.rb'] }

      it 'parses owners correctly' do
        expect(subject).to eq(['@org/blog', '@whitespace', 'data@example.com'])
      end
    end
  end
end
