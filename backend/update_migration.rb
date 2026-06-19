ActiveRecord::Base.connection.execute("INSERT INTO schema_migrations (version) VALUES ('20260619014847') ON CONFLICT DO NOTHING")
