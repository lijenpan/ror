module CoverageListHelper
  def available_retailers
    ShoppingCenter::CoveragePolicyService.available_retailers
  end
end
