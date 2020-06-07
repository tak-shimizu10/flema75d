module UsersHelper
  def good_count(user_evaluated_items)
    count = 0
    user_evaluated_items.each do |evaluate|
      count += 1 if evaluate[:rate] == "good"
    end
    count
  end

  def normal_count(user_evaluated_items)
    count = 0
    user_evaluated_items.each do |evaluate|
      count += 1 if evaluate[:rate] == "normal"
    end
    count
  end

  def bad_count(user_evaluated_items)
    count = 0
    user_evaluated_items.each do |evaluate|
      count += 1 if evaluate[:rate] == "bad"
    end
    count
  end
end
