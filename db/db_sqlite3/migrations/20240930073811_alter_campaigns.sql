-- +goose Up
-- +goose StatementBegin

-- Step 1: Create the new table with the desired changes (adding 'metadata' and 'org_id', changing 'name' to TEXT)

CREATE TABLE IF NOT EXISTS "campaigns_new" (
    "id" integer primary key autoincrement,
    "user_id" bigint,
    "name" TEXT NOT NULL,
    "created_date" datetime,
    "completed_date" datetime,
    "launch_date" datetime,
    "send_by_date" datetime,
    "template_id" bigint,
    "page_id" bigint,
    "status" varchar(255),
    "url" varchar(255),
    "smtp_id" bigint,
    "metadata" TEXT,              -- Added JSON column (stored as TEXT in SQLite)
    "org_id" TEXT NOT NULL DEFAULT ''  -- Added org_id column with a default value
);


-- Step 2: Copy the data from the old 'campaigns' table to the new 'campaigns_new' table
INSERT INTO campaigns_new (id, user_id, name, created_date, completed_date, template_id, page_id, status, url)
SELECT id, user_id, name, created_date, completed_date, template_id, page_id, status, url
FROM campaigns;

-- Step 3: Drop the old 'campaigns' table
DROP TABLE campaigns;

-- Step 4: Rename the new 'campaigns_new' table to 'campaigns'
ALTER TABLE campaigns_new RENAME TO campaigns;

-- Step 5: Add the new columns to 'pages' and 'templates'
ALTER TABLE pages ADD COLUMN org_id TEXT NOT NULL DEFAULT '';
ALTER TABLE templates ADD COLUMN org_id TEXT NOT NULL DEFAULT '';

-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin

-- Step 1: Recreate the original 'campaigns' table (without 'metadata' and 'org_id', and with 'name' as VARCHAR(255))
CREATE TABLE IF NOT EXISTS "campaigns_old" (
    "id" integer primary key autoincrement,
    "user_id" bigint,
    "name" varchar(255) NOT NULL,
    "created_date" datetime,
    "completed_date" datetime,
    "template_id" bigint,
    "page_id" bigint,
    "status" varchar(255),
    "url" varchar(255)
);

-- Step 2: Copy the data back from the modified 'campaigns' table to the old structure (ignoring the new columns)
INSERT INTO campaigns_old (id, user_id, name, created_date, completed_date, template_id, page_id, status, url)
SELECT id, user_id, name, created_date, completed_date, template_id, page_id, status, url
FROM campaigns;

-- Step 3: Drop the modified 'campaigns' table
DROP TABLE campaigns;

-- Step 4: Rename the 'campaigns_old' table back to 'campaigns'
ALTER TABLE campaigns_old RENAME TO campaigns;

-- Step 5: Recreate 'pages' table without 'org_id'
CREATE TABLE pages_old AS SELECT id, user_id, name, created_date, completed_date, status, url FROM pages;
DROP TABLE pages;
ALTER TABLE pages_old RENAME TO pages;

-- Step 6: Recreate 'templates' table without 'org_id'
CREATE TABLE templates_old AS SELECT id, name, created_date, status, url FROM templates;
DROP TABLE templates;
ALTER TABLE templates_old RENAME TO templates;

-- +goose StatementEnd
