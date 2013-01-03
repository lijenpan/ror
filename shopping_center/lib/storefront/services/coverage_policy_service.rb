module ShoppingCenter
  module CoveragePolicyService
    def self.to_coverage_task(policy, t = DateTime.now)
      CoverageTask.new(retailer: policy.retailer,
                       due_date: (t + policy.expiration_duration.minutes),
                       title: "Update #{policy.retailer.name.titleize}",
                       description: "This is an automatically generated coverage task for #{policy.retailer.name}.",
                       coverage_policy_id: policy.id)
    end

    #only retailers with a store count can be added to a coverage policy
    def self.available_retailers
      Retailer.where(:store_count.gte => 0)
    end
  end
end
