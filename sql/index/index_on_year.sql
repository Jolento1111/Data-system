use dblp;

create index year_index on article(year) using BTREE;
create index year_index on in_(year) using BTREE;
create index year_index on publish(year) using BTREE;
create index year_index on thesis(year) using BTREE;



