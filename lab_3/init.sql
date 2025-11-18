DO $$ 
BEGIN 
    IF EXISTS (SELECT 1 FROM pg_type WHERE typname = 'role') THEN
        DROP TYPE role;
    END IF;
END $$;

DO $$ 
BEGIN 
    IF EXISTS (SELECT 1 FROM pg_type WHERE typname = 'file_type') THEN
        DROP TYPE file_type;
    END IF;
END $$;

DROP TABLE IF EXISTS reaction;
DROP TABLE IF EXISTS reaction_type;
DROP TABLE IF EXISTS file;
DROP TABLE IF EXISTS message;
DROP TABLE IF EXISTS member;
DROP TABLE IF EXISTS admin_rights;
DROP TABLE IF EXISTS chat;
DROP TABLE IF EXISTS client;

DO $$
BEGIN
	IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'role') THEN
        CREATE TYPE role AS ENUM ('admin', 'super_admin', 'member');
    END IF;
END$$;

DO $$ 
BEGIN 
   IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'file_type') THEN 
      CREATE TYPE file_type AS ENUM('image', 'document', 'video', 'audio');
   END IF;
END$$;   
	  

CREATE TABLE IF NOT EXISTS client
(
   id serial PRIMARY KEY,
   email varchar(255) NOT NULL UNIQUE,
	tag varchar(64) NOT NULL UNIQUE,
	nickname varchar(96) NOT NULL,
	bio text,
	avatar_url varchar(128),
   created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS chat 
(
     id serial PRIMARY KEY,
	 name varchar(128) NOT NULL,
    tag varchar(128) NOT NULL UNIQUE, 
	 avatar_url varchar(128),
	 description text,
    last_activity_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS admin_rights (
   id serial PRIMARY KEY,
   can_change_group_info boolean,
   can_add_new_member boolean,
   can_delete_member boolean,
   can_promote_to_admin boolean,
   can_delete_message boolean
);

CREATE TABLE IF NOT EXISTS member
(
   id serial PRIMARY KEY,
	client_role role NOT NULL,
	client_id INTEGER NOT NULL REFERENCES client(id),
	chat_id INTEGER NOT NULL REFERENCES chat(id),
   admin_rights_id INTEGER REFERENCES admin_rights(id)
);


CREATE TABLE IF NOT EXISTS message (
   id serial PRIMARY KEY,
   content text,
   creator_id INTEGER NOT NULL REFERENCES member(id),
   chat_id INTEGER NOT NULL REFERENCES chat(id),
   answer_message INTEGER,
   created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS file (
   id serial PRIMARY KEY,
   message_id INTEGER NOT NULL REFERENCES message(id),
   file_type file_type,
   url varchar(128)
);

CREATE TABLE IF NOT EXISTS reaction_type (
  id serial PRIMARY KEY,
  tag varchar(32),
  label varchar(96),
  icon_url varchar(128)
);


CREATE TABLE IF NOT EXISTS reaction (
   id serial PRIMARY KEY,
   message_id INTEGER NOT NULL REFERENCES message(id),
   owner_id INTEGER NOT NULL REFERENCES member(id),
   type_id INTEGER NOT NULL REFERENCES reaction_type(id)
);
