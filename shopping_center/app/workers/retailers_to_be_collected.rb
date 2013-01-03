class RetailerToBeCollected
  extend HerokuAutoScaler::AutoScaling

  @queue = :file_server

  def self.perform
    @to_be_collected = []
    @known_tenants = []
    @known_retailers = []

    Retailer.all.each do |r|
      @known_retailers << r.name if !@known_retailers.include? r.name
    end

    ShoppingCenter.all.each do |sc|
      sc.tenants.each do |t|
        @known_tenants << t.name if !@known_tenants.include? t.name
      end
    end

    while !@known_tenants.empty?
      tenant = @known_tenants.pop

      if !@known_retailers.include? tenant
        @to_be_collected << tenant if !@to_be_collected.include? tenant
      end
    end

    researchers = CollectionType.where(:name => "retailer").first.researchers

    if researchers.empty?
      puts "[#{DateTime.now.strftime("%Y-%m-%d %H:%M:%S")}] There are no researchers assigned to collect retailers."
    else
      @to_be_collected.each do |retailer|
        @work_loads = []
        researchers.each do |r|
          @work_loads << r.work_load.to_i
        end

        min_workload = @work_loads.min
        assignee = nil
        researchers.each do |r|
          if r.work_load == min_workload
            assignee = r
            break
          end
        end

        if Task.create!(:title => "Collect #{retailer}", :description => "This is automatically generated.", :creator => User.where(:email => "apan@pps.com").first, :assignee => assignee, :due_date => DateTime.now + 5.days)
          puts "[#{DateTime.now.strftime("%Y-%m-%d %H:%M:%S")}] Task is created!"
        else
          puts "[#{DateTime.now.strftime("%Y-%m-%d %H:%M:%S")}] Creating task failed!"
        end
      end
    end
  end
end
