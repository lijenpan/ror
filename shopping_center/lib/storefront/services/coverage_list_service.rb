module ShoppingCenter
  module CoverageListService
    def self.add_coverage_policy(coverage_list, coverage_policy)
      coverage_list.policies << coverage_policy
      CoverageListService.make_coverage_task(coverage_list, coverage_policy)
    end

    def self.make_coverage_task(coverage_list, coverage_policy)
      coverage_list.tasks << CoveragePolicyService.to_coverage_task(coverage_policy)
      coverage_list.save
    end

    def self.delete_coverage_task(coverage_list, coverage_policy)
      coverage_list.tasks.where(:coverage_policy_id => coverage_policy.id).each do |t|
        t.destroy
      end
    end

    def self.transfer_coverage_policy(source_coverage_list, destination_coverage_list, policy)
      unless(source_coverage_list.id == destination_coverage_list.id)
        CoverageListService.add_coverage_policy(destination_coverage_list, policy.dup)
        CoverageListService.delete_coverage_task(source_coverage_list, policy)
        policy.destroy
      end
    end

    # def unassign(coverage_list)
    # end

    # def assign(coverage_list, user)
    # end

    # def transfer_ownership(coverage_list, new_user)
    #   CoverageListService.unassign(coverage_list)
    #   CoverageListService.assign(coverage_list, new_user)
    # end
  end
end
