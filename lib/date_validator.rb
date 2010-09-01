# Validates an attribute as a date
# For now it only checks that the value is min/max or between a range.
# 
# TODO: Validate format
class DateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    raise "DateValidator requires maximum and/or minimum options"\
      if options[:maximum].nil? && options[:minimum].nil?
    
    max = options[:maximum].to_date if options[:maximum]
    min = options[:minimum].to_date if options[:minimum]
    
    value = value.to_date
    
    if min && max
      if value < min || value > max
        record.errors[attribute] << (options[:message] || "is not between #{min} and #{max}") 
      end
    elsif min && value < min
      record.errors[attribute] << (options[:message] || "cannot be in the past") 
    elsif max && value > max
      record.errors[attribute] << (options[:message] || "cannot be in the future") 
    end
  end
  
end