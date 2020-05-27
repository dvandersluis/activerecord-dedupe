RSpec.describe ActiveRecord::Dedupe::Relation do
  describe '.new' do
    it 'raises an ArgumentError if not given a model' do
      expect { described_class.new(nil, :foo, :bar) }.to raise_error(ArgumentError)
    end

    it 'raises an ArgumentError if not given columns' do
      expect { described_class.new(User, nil) }.to raise_error(ArgumentError)
    end

    context 'loading duplicate groups' do
      let(:duplicate_ids) { subject.first.ids.split(',').map(&:to_i) }

      subject { described_class.new(model, columns) }

      context 'with a single column' do
        let(:model) { User }
        let(:columns) { :email }

        it 'returns 1 result per duplicate group' do
          users = create_list(:user, 3, email: 'foo@bar.com')
          expect(subject.length).to eq(1)
          expect(duplicate_ids).to contain_exactly(*users.pluck(:id))
        end
      end

      context 'with multiple columns' do
        let(:model) { Subscriber }
        let(:columns) { %i(newsletter_id user_id) }

        context 'when each record only has one column in common' do
          before do
            create_list(:subscriber, 3, newsletter_id: 1)
          end

          it 'does not return duplicates' do
            expect(subject).to be_empty
          end
        end

        context 'when all columns are the same' do
          let!(:subscribers) { create_list(:subscriber, 3, newsletter_id: 1, user_id: 1) }

          it 'returns 1 result per duplicate group' do
            expect(subject.length).to eq(1)
            expect(duplicate_ids).to contain_exactly(*subscribers.pluck(:id))
          end
        end
      end
    end
  end

  describe '.pluck' do
    let!(:users) { create_list(:user, 3, email: 'foo@bar.com') }
    let(:cols) { [] }

    subject { described_class.new(User, :email).pluck(cols) }

    it 'returns a value object for each group' do
      expect(subject.length).to eq(1)
      expect(subject.first.ids).to contain_exactly(*users.pluck(:id))
    end

    context 'when requesting other columns' do
      let(:cols) { :created_at }

      it 'returns other columns if requested' do
        expect(subject.first.additional_values[:created_at]).to be_a(Time)
      end
    end
  end
end
