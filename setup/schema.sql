/**
 * Build DB
 **/

/* 22. */ DROP TABLE IF EXISTS predicts.contest_result_scoring;
/* 21. */ DROP TABLE IF EXISTS predicts.contest_result;
/* 20. */ DROP TABLE IF EXISTS predicts.contest_slate_header_default_header;
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
  "id" SERIAL PRIMARY KEY,
  "user_header_id" INTEGER,
  "user_role_id" INTEGER,
  "date_created" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  "date_modified" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  /* Constraint */
  -- user_header_id
  CONSTRAINT user_assigned_role_user_header_id FOREIGN KEY (user_header_id)
    REFERENCES predicts.user_header (id),
  -- user_role_id
  CONSTRAINT user_assigned_role_user_role_id FOREIGN KEY (user_role_id)
    REFERENCES predicts.user_role (id)
)
ALTER TABLE predicts.user_assigned_role
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.user_assigned_role TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.user_assigned_role TO predictsapiwrite;
GRANT USAGE ON predicts.user_assigned_role_id_seq TO predictsapiwrite;
GRANT SELECT ON TABLE predicts.user_assigned_role TO predictsapiread;

/**********************************************
 * 4. CREATE user_connection Table            *
 *                                            *
 **********************************************/
CREATE TABLE "predicts.user_connection"
(
  "id" SERIAL PRIMARY KEY,
  "user_id" INTEGER,
  "follower_id" INTEGER,
  "awaiting_response" BOOLEAN,
  "is_active" BOOLEAN,
  "is_blocked" BOOLEAN,
  "date_created" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  "date_modified" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  /* Constraint */
  -- user_id
  CONSTRAINT user_connection_user_id FOREIGN KEY (user_id)
    REFERENCES predicts.user_header (id),
  -- follower_id
  CONSTRAINT user_connection_follower_id FOREIGN KEY (follower_id)
    REFERENCES predicts.user_header (id)

)
ALTER TABLE predicts.user_connection
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.user_connection TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.user_connection TO predictsapiwrite;
GRANT USAGE ON predicts.user_connection_id_seq TO predictsapiwrite;
GRANT SELECT ON TABLE predicts.user_connection TO predictsapiread;

/**********************************************
 * 5. CREATE contest_header Table             *
 *                                            *
 **********************************************/
CREATE TABLE "predicts.contest_header"
(
  "id" SERIAL PRIMARY KEY,
  "contest_name" VARCHAR,
  "is_active" BOOLEAN,
  "is_default" BOOLEAN,
  "created_by" INTEGER, -- FK CONSTRAINT
  "current_owner" INTEGER, -- FK CONSTRAINT
  "is_public" BOOLEAN,
  "is_private" BOOLEAN,
  "invitation_code" VARCHAR,
  "start_date" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()),
  "end_date" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()),
  "current_event" SMALLINT,
  "total_events" SMALLINT,
  "is_premium" BOOLEAN,
  "player_limit" INTEGER,
  "last_modified_by" INTEGER, -- FK CONSTRAINT
  "date_created" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  "date_modified" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  /* Constraint */
  -- created_by
  CONSTRAINT contest_header_created_by FOREIGN KEY (created_by)
    REFERENCES predicts.user_header (id),
  -- current_owner
  CONSTRAINT contest_header_current_owner FOREIGN KEY (current_owner)
    REFERENCES predicts.user_header (id),
  -- last_modified_by
  CONSTRAINT contest_header_last_modified_by FOREIGN KEY (last_modified_by)
    REFERENCES predicts.user_header (id)
)
ALTER TABLE predicts.contest_header
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.contest_header TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.contest_header TO predictsapiwrite;
GRANT USAGE ON predicts.contest_header_id_seq TO predictsapiwrite;
GRANT SELECT ON TABLE predicts.contest_header TO predictsapiread;

/**********************************************
 * 6. CREATE scoring_system_header Table      *
 *                                            *
 **********************************************/
CREATE TABLE "predicts.scoring_system_header"
(
  "id" SERIAL PRIMARY KEY,
  "contest_header_id" INTEGER, -- FK CONSTRAINT
  "is_custom" INTEGER,
  "created_by" INTEGER, -- FK CONSTRAINT
  "last_modified_by" INTEGER, -- FK CONSTRAINT
  "date_created" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  "date_modified" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  /* Constraint */
  -- contest_header_id
  CONSTRAINT scoring_system_header_contest_header_id FOREIGN KEY (contest_header_id)
    REFERENCES predicts.contest_header (id),
  -- created_by
  CONSTRAINT scoring_system_header_created_by FOREIGN KEY (created_by)
    REFERENCES predicts.user_header (id),
  -- last_modified_by
  CONSTRAINT scoring_system_header_last_modified_by FOREIGN KEY (last_modified_by)
    REFERENCES predicts.contest_header (id)
)
ALTER TABLE predicts.scoring_system_header
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.scoring_system_header TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.scoring_system_header TO predictsapiwrite;
GRANT USAGE ON predicts.scoring_system_header_id_seq TO predictsapiwrite;
GRANT SELECT ON TABLE predicts.scoring_system_header TO predictsapiread;

/**********************************************
 * 7. CREATE scoring_system_detail Table      *
 *                                            *
 **********************************************/
CREATE TABLE "predicts.scoring_system_detail"
(
  "id" SERIAL PRIMARY KEY,
  "scoring_system_header_id" INTEGER, -- FK CONSTRAINT
  "name" VARCHAR,
  "description" VARCHAR,
  "type" VARCHAR,
  "is_active" BOOLEAN,
  "is_default" BOOLEAN,
  "created_by" INTEGER, -- FK CONSTRAINT
  "start_date" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  "end_date" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  "points" SMALLINT,
  "last_modified_by" INTEGER, -- FK CONSTRAINT
  "date_created" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  "date_modified" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  /* Constraint */
  -- scoring_system_header_id
  CONSTRAINT scoring_system_detail_scoring_system_header_id FOREIGN KEY (scoring_system_header_id)
    REFERENCES predicts.scoring_system_header (id),
  -- created_by
  CONSTRAINT scoring_system_detail_created_by FOREIGN KEY (created_by)
    REFERENCES predicts.user_header (id),
  -- last_modified_by
  CONSTRAINT scoring_system_detail_last_modified_by FOREIGN KEY (last_modified_by)
    REFERENCES predicts.last_modified_by (id)
)
ALTER TABLE predicts.scoring_system_detail
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.scoring_system_detail TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.scoring_system_detail TO predictsapiwrite;
GRANT USAGE ON predicts.scoring_system_detail_id_seq TO predictsapiwrite;
GRANT SELECT ON TABLE predicts.scoring_system_detail TO predictsapiread;

/**********************************************
 * 8. CREATE user_invite Table                *
 *                                            *
 **********************************************/
CREATE TABLE "predicts.user_invite"
(
  "id" SERIAL PRIMARY KEY,
  "invite_code" VARCHAR,
  "email" VARCHAR,
  "invite_creator" INTEGER, -- FK CONSTRAINT
  "accepted" BOOLEAN,
  "date_created" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  "date_modified" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  /* Constraint */
  -- invite_creator
  CONSTRAINT user_invite_invite_creator FOREIGN KEY (invite_creator)
    REFERENCES predicts.user_header (id)
)
ALTER TABLE predicts.user_invite
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.user_invite TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.user_invite TO predictsapiwrite;
GRANT USAGE ON predicts.user_invite_id_seq TO predictsapiwrite;
GRANT SELECT ON TABLE predicts.user_invite TO predictsapiread;

/**********************************************
 * 9. CREATE successful_invite_user Table     *
 *                                            *
 **********************************************/
CREATE TABLE "predicts.successful_invite_user"
(
  "id" SERIAL PRIMARY KEY,
  "user_invite_id" INTEGER, -- FK CONSTRAINT
  "new_user_id" INTEGER, -- FK CONSTRAINT
  "date_created" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  "date_modified" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  /* Constraint */
  -- user_invite_id
  CONSTRAINT successful_invite_user_user_invite_id FOREIGN KEY (user_invite_id)
    REFERENCES predicts.user_invite (id),
  -- new_user_id
  CONSTRAINT successful_invite_user_new_user_id FOREIGN KEY (new_user_id)
    REFERENCES predicts.user_header (id)
)
ALTER TABLE predicts.successful_invite_user
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.successful_invite_user TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.successful_invite_user TO predictsapiwrite;
GRANT USAGE ON predicts.successful_invite_user_id_seq TO predictsapiwrite;
GRANT SELECT ON TABLE predicts.successful_invite_user TO predictsapiread;

/**********************************************
 * 10. CREATE participant_type Table          *
 *                                            *
 **********************************************/
CREATE TABLE "predicts.participant_type"
(
  "id" SERIAL PRIMARY KEY,
  "participant_type_name" VARCHAR,
  "participant_description" VARCHAR,
  "date_created" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  "date_modified" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
)
ALTER TABLE predicts.participant_type
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.participant_type TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.participant_type TO predictsapiwrite;
GRANT USAGE ON predicts.participant_type_id_seq TO predictsapiwrite;
GRANT SELECT ON TABLE predicts.participant_type TO predictsapiread;

/**********************************************
 * 11. CREATE contest_user Table              *
 *                                            *
 **********************************************/
CREATE TABLE "predicts.contest_user"
(
  "id" SERIAL PRIMARY KEY,
  "contest_header_id" INTEGER, -- FK CONSTRAINT
  "participant_type_id" INTEGER, -- FK CONSTRAINT
  "user_id" INTEGER, -- FK CONSTRAINT
  "is_invited" BOOLEAN,
  "invite_status_id" SMALLINT, -- FK CONSTRAINT
  "is_active" BOOLEAN,
  "is_blocked" BOOLEAN,
  "balance" FLOAT,
  "created_by" INTEGER, -- FK CONSTRAINT
  "invited_by" INTEGER, -- FK CONSTRAINT
  "date_created" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  "date_modified" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  /* Constraint */
  -- contest_header_id
  CONSTRAINT contest_user_contest_header_id FOREIGN KEY (contest_header_id)
    REFERENCES predicts.contest_header (id)
  -- participant_type_id
  CONSTRAINT contest_user_participant_type_id FOREIGN KEY (participant_type_id)
    REFERENCES predicts.participant_type (id)
  -- user_id
  CONSTRAINT contest_user_user_id FOREIGN KEY (user_id)
    REFERENCES predicts.user_header (id)
  -- invite_status_id
  CONSTRAINT contest_user_invite_status_id FOREIGN KEY (invite_status_id)
    REFERENCES predicts.invite_status (id)
  -- created_by
  CONSTRAINT contest_user_created_by FOREIGN KEY (created_by)
    REFERENCES predicts.user_header (id)
  -- invited_by
  CONSTRAINT contest_user_invited_by FOREIGN KEY (invited_by)
    REFERENCES predicts.user_header (id)
)
ALTER TABLE predicts.contest_user
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.contest_user TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.contest_user TO predictsapiwrite;
GRANT USAGE ON predicts.contest_user_id_seq TO predictsapiwrite;
GRANT SELECT ON TABLE predicts.contest_user TO predictsapiread;

/**********************************************
 * 12. CREATE team Table                      *
 *                                            *
 **********************************************/
CREATE TABLE "predicts.team"
(
  "code" INTEGER,
  "fpl_team_id" INTEGER,
  "fantasy_id" INTEGER,
  "name" VARCHAR,
  "short_name" VARCHAR(3),
  "strength" SMALLINT,
  "strength_attack_away" INTEGER,
  "strength_attack_home" INTEGER,
  "strength_defence_away" INTEGER,
  "strength_defence_home" INTEGER,
  "strength_overall_away" INTEGER,
  "strength_overall_home" INTEGER,
  "team_division" INTEGER,
  "date_created" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  "date_modified" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
)
ALTER TABLE predicts.team
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.team TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.team TO predictsapiwrite;
GRANT USAGE ON predicts.team_id_seq TO predictsapiwrite;
GRANT SELECT ON TABLE predicts.team TO predictsapiread;

/**********************************************
 * 13. CREATE season Table                    *
 *                                            *
 **********************************************/
CREATE TABLE "predicts.season"
(
  "date_created" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  "date_modified" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
  /* Constraint */
)
ALTER TABLE predicts.season
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.season TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.season TO predictsapiwrite;
GRANT USAGE ON predicts.season_id_seq TO predictsapiwrite;
GRANT SELECT ON TABLE predicts.season TO predictsapiread;

/**********************************************
 * 14. CREATE event Table                     *
 *                                            *
 **********************************************/
CREATE TABLE "predicts.event"
(
  "date_created" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  "date_modified" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
  /* Constraint */
)
ALTER TABLE predicts.event
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.event TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.event TO predictsapiwrite;
GRANT USAGE ON predicts.event_id_seq TO predictsapiwrite;
GRANT SELECT ON TABLE predicts.event TO predictsapiread;

/**********************************************
 * 15. CREATE fixture_header Table            *
 *                                            *
 **********************************************/
CREATE TABLE "predicts.fixture_header"
(
  "date_created" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  "date_modified" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
  /* Constraint */
)
ALTER TABLE predicts.fixture_header
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.fixture_header TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.fixture_header TO predictsapiwrite;
GRANT USAGE ON predicts.fixture_header_id_seq TO predictsapiwrite;
GRANT SELECT ON TABLE predicts.fixture_header TO predictsapiread;

/**********************************************
 * 16. CREATE default_slate_header Table      *
 *                                            *
 **********************************************/
CREATE TABLE "predicts.default_slate_header"
(
  "date_created" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  "date_modified" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
  /* Constraint */
)
ALTER TABLE predicts.default_slate_header
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.default_slate_header TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.default_slate_header TO predictsapiwrite;
GRANT USAGE ON predicts.default_slate_header_id_seq TO predictsapiwrite;
GRANT SELECT ON TABLE predicts.default_slate_header TO predictsapiread;

/**********************************************
 * 17. CREATE default_slate_entries Table     *
 *                                            *
 **********************************************/
CREATE TABLE "predicts.default_slate_entries"
(
  "date_created" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  "date_modified" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
  /* Constraint */
)
ALTER TABLE predicts.default_slate_entries
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.default_slate_entries TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.default_slate_entries TO predictsapiwrite;
GRANT USAGE ON predicts.default_slate_entries_id_seq TO predictsapiwrite;
GRANT SELECT ON TABLE predicts.default_slate_entries TO predictsapiread;

/**********************************************
 * 18. CREATE contest_slate_header Table      *
 *                                            *
 **********************************************/
CREATE TABLE "predicts.contest_slate_header"
(
  "date_created" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  "date_modified" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
  /* Constraint */
)
ALTER TABLE predicts.contest_slate_header
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.contest_slate_header TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.contest_slate_header TO predictsapiwrite;
GRANT USAGE ON predicts.contest_slate_header_id_seq TO predictsapiwrite;
GRANT SELECT ON TABLE predicts.contest_slate_header TO predictsapiread;

/**********************************************
 * 19. CREATE contest_slate_entry Table       *
 *                                            *
 **********************************************/
CREATE TABLE "predicts.contest_slate_entry"
(
  "date_created" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  "date_modified" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
  /* Constraint */
)
ALTER TABLE predicts.contest_slate_entry
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.contest_slate_entry TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.contest_slate_entry TO predictsapiwrite;
GRANT USAGE ON predicts.contest_slate_entry_id_seq TO predictsapiwrite;
GRANT SELECT ON TABLE predicts.contest_slate_entry TO predictsapiread;

/*********************************************************
 * 20. CREATE contest_slate_header_default_header Table  *
 *                                                       *
 *********************************************************/
CREATE TABLE "predicts.contest_slate_header_default_header"
(
  "date_created" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  "date_modified" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
  /* Constraint */
)
ALTER TABLE predicts.contest_slate_header_default_header
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.contest_slate_header_default_header TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.contest_slate_header_default_header TO predictsapiwrite;
GRANT USAGE ON predicts.contest_slate_header_default_header_id_seq TO predictsapiwrite;
GRANT SELECT ON TABLE predicts.contest_slate_header_default_header TO predictsapiread;

/**********************************************
 * 21. CREATE contest_result Table            *
 *                                            *
 **********************************************/
CREATE TABLE "predicts.contest_result"
(
  "date_created" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  "date_modified" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
  /* Constraint */
)
ALTER TABLE predicts.contest_result
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.contest_result TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.contest_result TO predictsapiwrite;
GRANT USAGE ON predicts.contest_result_id_seq TO predictsapiwrite;
GRANT SELECT ON TABLE predicts.contest_result TO predictsapiread;

/**********************************************
 * 22. CREATE contest_result_scoring Table    *
 *                                            *
 **********************************************/
CREATE TABLE "predicts.contest_result_scoring"
(
  "date_created" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  "date_modified" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
  /* Constraint */
)
ALTER TABLE predicts.contest_result_scoring
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.contest_result_scoring TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.contest_result_scoring TO predictsapiwrite;
GRANT USAGE ON predicts.contest_result_scoring_id_seq TO predictsapiwrite;
GRANT SELECT ON TABLE predicts.contest_result_scoring TO predictsapiread;
