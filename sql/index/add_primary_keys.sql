use dblp;

-- ALTER TABLE article
-- MODIFY COLUMN _key VARCHAR(255)
-- CHARACTER SET utf8mb4
-- COLLATE utf8mb4_bin;

-- ALTER TABLE in_
-- MODIFY COLUMN _key VARCHAR(255)
-- CHARACTER SET utf8mb4
-- COLLATE utf8mb4_bin;

-- ALTER TABLE thesis
-- MODIFY COLUMN _key VARCHAR(255)
-- CHARACTER SET utf8mb4
-- COLLATE utf8mb4_bin;

-- ALTER TABLE publish
-- MODIFY COLUMN _key VARCHAR(255)
-- CHARACTER SET utf8mb4
-- COLLATE utf8mb4_bin;

-- ALTER TABLE r_author
-- MODIFY COLUMN _key VARCHAR(255)
-- CHARACTER SET utf8mb4
-- COLLATE utf8mb4_bin;

-- ALTER TABLE r_author
-- MODIFY COLUMN author VARCHAR(255)
-- CHARACTER SET utf8mb4
-- COLLATE utf8mb4_bin;


-- ALTER TABLE article
-- ADD PRIMARY KEY (_key);

-- ALTER TABLE in_
-- ADD PRIMARY KEY (_key);

-- ALTER TABLE thesis
-- ADD PRIMARY KEY (_key);

-- ALTER TABLE publish
-- ADD PRIMARY KEY (_key);

-- ALTER TABLE r_author
-- ADD PRIMARY KEY (_key, author);

-- create index ra_index on r_author(_key, author);






