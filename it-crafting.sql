CREATE TABLE IF NOT EXISTS it_crafting_tables (
    id VARCHAR(11) NOT NULL PRIMARY KEY,
    coords LONGTEXT NOT NULL,
    rotation DOUBLE NOT NULL,
    dimension INT(11) NOT NULL,
    owner LONGTEXT NOT NULL,
    type VARCHAR(100) NOT NULL
);

-- If updating the script from version 1.0.1 you have to execute this command to add the new column to the table
ALTER TABLE it_crafting_tables ADD COLUMN IF NOT EXISTS dimension INT(11) NOT NULL DEFAULT 0;