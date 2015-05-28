module UsersHelper

  def parse_first_name(full_name)
    if full_name
      first_name, *last_name = full_name.split
      first_name
    end
  end

  def parse_last_name(full_name)
    if full_name
      first_name, *last_name = full_name.split
      last_name.join(" ")
    end
  end

end
