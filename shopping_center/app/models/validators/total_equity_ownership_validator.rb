module TotalEquityOwnershipValidator
  extend ActiveSupport::Concern

  module ClassMethods
    def validate_total_ownership
      validates_with EquityOwnershipValidator
    end
  end

  class EquityOwnershipValidator < ActiveModel::Validator
    def validate(record)
      begin
        sum = 0
        record.equity_owners.each do |eo|
          sum += eo.ownership if eo.ownership
        end

        if sum > 100.0
          record.errors["Equity Owner Error:"] << "Total equity owners stake is greater than 100%."
        end
      rescue TypeError
        record.errors["Equity Owner Error:"] << $!
      end
    end
  end
end
