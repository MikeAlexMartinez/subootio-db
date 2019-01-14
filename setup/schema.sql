/**
 * Build DB
 **/

/* 22. */ DROP TABLE IF EXISTS predicts.contest_result_scoring;
/* 21. */ DROP TABLE IF EXISTS predicts.contest_result;
/* 20. */ DROP TABLE IF EXISTS predicts.content_slate_header_default_header;
/* 19. */ DROP TABLE IF EXISTS predicts.contest_slate_entry;
/* 18. */ DROP TABLE IF EXISTS predicts.contest_slate_header;
/* 17. */ DROP TABLE IF EXISTS predicts.default_slate_entries;
/* 16. */ DROP TABLE IF EXISTS predicts.default_slate_header;
/* 15. */ DROP TABLE IF EXISTS predicts.fixture_header;
/* 14. */ DROP TABLE IF EXISTS predicts.event;
/* 13. */ DROP TABLE IF EXISTS predicts.season;
/* 12. */ DROP TABLE IF EXISTS predicts.team;
/* 11. */ DROP TABLE IF EXISTS predicts.contest_user;
/* 10. */ DROP TABLE IF EXISTS predicts.participant_type;
/* 9.  */ DROP TABLE IF EXISTS predicts.successful_invite_user;
/* 8.  */ DROP TABLE IF EXISTS predicts.user_invite;
/* 7.  */ DROP TABLE IF EXISTS predicts.scoring_system_detail;
/* 6.  */ DROP TABLE IF EXISTS predicts.scoring_system_header;
/* 5.  */ DROP TABLE IF EXISTS predicts.contest_header;
/* 4.  */ DROP TABLE IF EXISTS predicts.user_connection;
/* 3.  */ DROP TABLE IF EXISTS predicts.user_assigned_role;
/* 2.  */ DROP TABLE IF EXISTS predicts.user_role;
/* 1.  */ DROP TABLE IF EXISTS predicts.user_header;

CREATE SCHEMA IF NOT EXISTS predicts AUTHORIZATION "%1$s";

GRANT USAGE ON SCHEMA predicts TO predictsapiwrite;
GRANT USAGE ON SCHEMA predicts TO predictsapiread;

/**********************************************
 * 1. CREATE user_header Table                 *
 *                                            *
 **********************************************/
CREATE TABLE "predicts.user_header"
(
  "id" SERIAL PRIMARY KEY,
  "email" VARCHAR,
  "first_name" VARCHAR,
  "last_name" VARCHAR,
  "phone_number" VARCHAR,
  "favorite_team" VARCHAR,
  "country" VARCHAR,
  "display_name" VARCHAR,
  "is_private" BOOLEAN,
  "is_premium" BOOLEAN,
  "password" VARCHAR,
  "publickey" VARCHAR,
  "date_created" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  "date_modified" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
)
-- assign ownership to main db user
ALTER TABLE predicts.user_header
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.user_header TO "%1$s";
-- Give necessary instructions to write user
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.user_header TO predictsapiwrite;
GRANT USAGE ON predicts.user_header_id_seq TO predictsapiwrite;
-- Give necessary instructions to read user
GRANT SELECT ON TABLE predicts.user_header TO predictsapiread;

/**********************************************
 * 2. CREATE user_role Table                *
 *                                            *
 **********************************************/
CREATE TABLE "predicts.user_role"
(
  "id" SERIAL PRIMARY KEY,
  "name" VARCHAR,
  "description" VARCHAR,
  "date_created" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  "date_modified" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
)
-- assign ownership to main db user
ALTER TABLE predicts.user_role
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.user_role TO "%1$s";
-- Give necessary instructions to write user
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.user_role TO predictsapiwrite;
GRANT USAGE ON predicts.user_role_id_seq TO predictsapiwrite;
-- Give necessary instructions to read user
GRANT SELECT ON TABLE predicts.user_role TO predictsapiread;

/**********************************************
 * 3. CREATE user_assigned_role Table         *
 *                                            *
 **********************************************/
CREATE TABLE "predicts.user_assigned_role"
(
  "date_created" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  "date_modified" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
  /* Constraint */
  -- user_id
  CONSTRAINT user_assigned_role_user_id FOREIGN KEY (user_id)
    REFERENCES predicts.userheader (id),
)
ALTER TABLE predicts.user_assigned_role
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.user_assigned_role TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.user_assigned_role TO predictsapiwrite;
GRANT USAGE ON predicts.user_assigned_role_id_seq TO predictsapiwrite;
GRANT SELECT ON TABLE predicts.user_assigned_role TO predictsapiread;

/**********************************************
 * 4. CREATE user_connection Table         *
 *                                            *
 **********************************************/
CREATE TABLE "predicts.user_connection"
(
  "date_created" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  "date_modified" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
  /* Constraint */
)
ALTER TABLE predicts.user_connection
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.user_connection TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.user_connection TO predictsapiwrite;
GRANT USAGE ON predicts.user_connection_id_seq TO predictsapiwrite;
GRANT SELECT ON TABLE predicts.user_connection TO predictsapiread;
