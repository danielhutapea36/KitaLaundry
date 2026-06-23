ActiveRecord::Base.connection.execute("TRUNCATE TABLE addresses, order_items, orders, services, branches, users CASCADE")
