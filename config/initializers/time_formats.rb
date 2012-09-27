Date::DATE_FORMATS[:csv_output] = '%d/%b/%Y'
Date::DATE_FORMATS[:transaction] = "%d %b '%y"
Date::DATE_FORMATS[:date_short_month] = "%d %b"
Date::DATE_FORMATS[:pause] = "%a %-d %b"

Time::DATE_FORMATS[:weekday] = "%A"
Time::DATE_FORMATS[:month_and_year] = "%B %Y"
Time::DATE_FORMATS[:day_month_and_year] = "%-d %B %Y"
Time::DATE_FORMATS[:timestamp] = "%Y-%m-%d %H:%M:%S"
Time::DATE_FORMATS[:month_date_year] = "%A %d %b"
Time::DATE_FORMATS[:date_month] = "%d %B"
Time::DATE_FORMATS[:day_month_date_year] = "%A, %B %d, %Y"
Time::DATE_FORMATS[:transaction] = "%d %b '%y"
Time::DATE_FORMATS[:bank] = "%Y%m%d%H%M%S"
Time::DATE_FORMATS[:pretty] = lambda { |time| time.strftime("%a, %b %e at %l:%M") + time.strftime("%p").downcase }
Time::DATE_FORMATS[:csv_output] = '%d/%b/%Y'
