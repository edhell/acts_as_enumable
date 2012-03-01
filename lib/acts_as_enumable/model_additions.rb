module ActsAsEnumable
  module ModelAdditions
    def acts_as_enumable attribute, enum_values, options={}
      attribute = attribute.to_s
      attr_plural = attribute.pluralize

      enum_values.collect!(&:to_sym)

      class_eval %Q{
        def self.#{attr_plural}
          #{enum_values}
        end
      }

      class_eval %Q{
        def self.#{attr_plural}_for_select(i18n_namespace)
          #{attr_plural}.map do |value|
            { key: value, value: I18n.t("\#{i18n_namespace}.\#{value}") }
          end
        end
      }

      class_eval %Q{
        def self.#{attribute} symbol
          #{enum_values}.index(symbol.to_sym)
        end
       }

      define_method attribute do
        index = read_attribute(attribute)
        return nil if index.nil?
        enum_values.at(index)
      end

      define_method "#{attribute}=" do |symbol|
        if symbol.class == Fixnum
          value = symbol
          value = nil if value >= enum_values.length
        else
          symbol = symbol.to_sym unless symbol.nil?
          value = enum_values.index(symbol)
        end
        write_attribute(attribute, value)
      end

    end
  end
end
