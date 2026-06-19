UPDATE users SET email = 'no-email-' || id || '@test.com' WHERE email IS NULL;
UPDATE users SET first_name = 'User' WHERE first_name IS NULL;
UPDATE users SET password_digest = 'default_digest' WHERE password_digest IS NULL;
ALTER TABLE users ALTER COLUMN email SET NOT NULL, ALTER COLUMN first_name SET NOT NULL, ALTER COLUMN password_digest SET NOT NULL;
