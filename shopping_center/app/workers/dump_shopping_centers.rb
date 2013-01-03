require 'writeexcel'

class DumpShoppingCenters
  def self.execute
    workbook = WriteExcel.new("dump.xls")
  	worksheet = workbook.add_worksheet
  	worksheet.write(0, 0, "Name")
  	worksheet.write(0, 1, "Street Number")
  	worksheet.write(0, 2, "Street")
  	worksheet.write(0, 3, "Municipality")
  	worksheet.write(0, 4, "Governing District")
  	worksheet.write(0, 5, "Postal Area")
  	row = 1
  
	  ShoppingCenter.all.each do |sc|
      address = sc.address
	    if !area_description[1].nil?
	      if population.to_i < @threshold
	        worksheet.write(row, 0, sc.name)
  	      worksheet.write(row, 1, address.street_number)
	        worksheet.write(row, 2, address.street)
	        worksheet.write(row, 3, address.municipality)
	        worksheet.write(row, 4, address.governing_district)
  	      worksheet.write(row, 5, address.postal_code)
	        row = row + 1
	      end
  	  end
  	end
	  workbook.close
  end
end
