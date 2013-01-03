module ShoppingCenterHelper
  def single_line_address addr
    "#{addr.street_number} #{addr.street}, #{addr.municipality}, #{addr.governing_district}, #{addr.postal_code}"
  end
end

class Numeric
  def duration
    secs = self.to_int
    mins = secs / 60
    hours = mins / 60
    days = hours / 24

    if days > 0
      t(:days_and_hours, :days => days, :hours => (hours % 24))
    elsif hours > 0
      t(:hours_and_minutes, :hours => hours, :minutes => (mins % 60))
    elsif mins > 0
      t(:minutes_and_seconds, :minutes => mins, :seconds => (secs % 60))
    elsif secs > 0
      t(:seconds, :seconds => secs)
    end
  end
end
