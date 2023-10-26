
require_relative '../lib/reposition'
RSpec.describe Reposition do
  describe '.reposition' do
    let(:object) { double('object', attribute_name: nil) }
    let(:preceding_object) { double('preceding_object', attribute_name: 10) }
    let(:following_object) { double('following_object', attribute_name: 20) }

    context 'when preceding_object is nil' do
      it 'updates the attribute with following_object attribute value' do
        expect(object).to receive(:update_attribute).with(:attribute_name, 19)
        Reposition.reposition(object: object, preceding_object: nil, following_object: following_object, attribute_name: :attribute_name)
      end
    end

    context 'when following_object is nil' do
      it 'updates the attribute with preceding_object attribute value' do
        expect(object).to receive(:update_attribute).with(:attribute_name, 11)
        Reposition.reposition(object: object, preceding_object: preceding_object, following_object: nil, attribute_name: :attribute_name)
      end
    end

    context 'when both preceding_object and following_object are present' do
      it 'updates the attribute with the average of the two objects attribute values' do
        expect(object).to receive(:update_attribute).with(:attribute_name, (preceding_object.send(:attribute_name) + following_object.send(:attribute_name)) / 2)
        Reposition.reposition(object: object, preceding_object: preceding_object, following_object: following_object, attribute_name: :attribute_name)
      end
    end

    context 'with options' do
      context "when options[:validate] is false" do
        it 'saves the object with the provided options' do
          allow(object).to receive(:update_attribute)
          expect(object).to receive(:save).with(validate: false)
          Reposition.reposition(object: object, preceding_object: preceding_object, following_object: following_object, attribute_name: :attribute_name, options: { validate: false, save: 'save' })
        end
      end

      context "when options[:validate] is true" do
        it 'saves the object with validation' do
          allow(object).to receive(:update_attribute)
          expect(object).to receive(:save).with(validate: true)
          Reposition.reposition(object: object, preceding_object: preceding_object, following_object: following_object, attribute_name: :attribute_name, options: { validate: true, save: 'save' })
        end
      end

       context "when options[:save] is set but validate is not" do
        it 'saves the object with validation' do
          allow(object).to receive(:update_attribute)
          expect(object).to receive(:save).with(validate: true)

          Reposition.reposition(object: object, preceding_object: preceding_object, following_object: following_object, attribute_name: :attribute_name, options: { save: 'save' })
        end

        context "when options[:save] is set to save! but validate is not" do
          it 'saves the object with validation' do
            allow(object).to receive(:update_attribute)
            expect(object).to receive(:save!).with(validate: true)

            Reposition.reposition(object: object, preceding_object: preceding_object, following_object: following_object, attribute_name: :attribute_name, options: { save: 'save!' })
          end
        end
      end
    end

    context 'when options are not provided' do
      it 'saves the object with default options' do
        allow(object).to receive(:update_attribute)
        expect(object).not_to receive(:save)
        Reposition.reposition(object: object, preceding_object: preceding_object, following_object: following_object, attribute_name: :attribute_name)
      end
    end
  end
end
