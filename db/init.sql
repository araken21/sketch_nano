DROP TABLE IF EXISTS pictures;

CREATE TABLE pictures (
    id           INTEGER PRIMARY KEY,
    title        TEXT,
    src          TEXT,
    author_name  TEXT,
    likes        INTEGER DEFAULT 0,
    posted_at    DATETIME
);
