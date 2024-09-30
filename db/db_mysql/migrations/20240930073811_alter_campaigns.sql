-- +goose Up
-- +goose StatementBegin
ALTER TABLE `campaigns` ADD COLUMN metadata JSON;
ALTER TABLE `campaigns` MODIFY name TEXT;

ALTER TABLE `campaigns` ADD COLUMN org_id VARCHAR(255) NOT NULL;
ALTER TABLE `pages` ADD COLUMN org_id VARCHAR(255) NOT NULL;
ALTER TABLE `templates` ADD COLUMN org_id VARCHAR(255) NOT NULL;
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
ALTER TABLE `campaigns` DROP COLUMN metadata;
ALTER TABLE `campaigns` DROP COLUMN org_id;
ALTER TABLE `pages` DROP COLUMN org_id;
ALTER TABLE `templates` DROP COLUMN org_id;
ALTER TABLE `campaigns` MODIFY name VARCHAR(255);
-- +goose StatementEnd
