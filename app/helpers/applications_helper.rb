module ApplicationsHelper
  def pop_last_word string
    s = string.split " "
    s.pop
    s.join " "
  end
end
