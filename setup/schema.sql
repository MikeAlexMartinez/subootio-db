/**
 * Build DB
 **/

/* 28. */ DROP TABLE IF EXISTS predicts.contest_result_score;
/* 27. */ DROP TABLE IF EXISTS predicts.contest_result;
/* 26. */ DROP TABLE IF EXISTS predicts.contest_slate_header_default_header;
/* 25. */ DROP TABLE IF EXISTS predicts.contest_slate_entry;
/* 24. */ DROP TABLE IF EXISTS predicts.contest_slate_header;
/* 23. */ DROP TABLE IF EXISTS predicts.default_slate_entry;
/* 22. */ DROP TABLE IF EXISTS predicts.default_slate_header;
/* 21. */ DROP TABLE IF EXISTS predicts.fixture_header;
/* 20. */ DROP TABLE IF EXISTS predicts.event;
/* 19. */ DROP TABLE IF EXISTS predicts.season;
/* 18. */ DROP TABLE IF EXISTS predicts.team;
/* 17. */ DROP TABLE IF EXISTS predicts.contest_invite_application;
/* 16. */ DROP TABLE IF EXISTS predicts.contest_invite_type;
/* 15. */ DROP TABLE IF EXISTS predicts.contest_user;
/* 14. */ DROP TABLE IF EXISTS predicts.participant_type;
/* 13. */ DROP TABLE IF EXISTS predicts.successful_invite_user;
/* 12. */ DROP TABLE IF EXISTS predicts.user_invite;
/* 11. */ DROP TABLE IF EXISTS predicts.scoring_system_detail;
/* 10. */ DROP TABLE IF EXISTS predicts.scoring_system_header;
/* 9.  */ DROP TABLE IF EXISTS predicts.default_scoring_system_detail;
/* 8.  */ DROP TABLE IF EXISTS predicts.default_scoring_system_header;
/* 7.  */ DROP TABLE IF EXISTS predicts.scoring_type;
/* 6.  */ DROP TABLE IF EXISTS predicts.contest_header;
/* 5.  */ DROP TABLE IF EXISTS predicts.contest_type;
/* 4.  */ DROP TABLE IF EXISTS predicts.user_connection;
/* 3.  */ DROP TABLE IF EXISTS predicts.user_assigned_role;
/* 2.  */ DROP TABLE IF EXISTS predicts.user_role;
/* 1.  */ DROP TABLE IF EXISTS predicts.user_header;

CREATE SCHEMA IF NOT EXISTS predicts AUTHORIZATION "%1$s";

GRANT USAGE ON SCHEMA predicts TO "%2$s";
GRANT USAGE ON SCHEMA predicts TO "%3$s";

/**********************************************
 * 1. CREATE user_header Table                 *
 *                                            *
 **********************************************/
CREATE TABLE predicts.user_header
(
  "id" SERIAL PRIMARY KEY,
  "email" VARCHAR,
  "first_name" VARCHAR,
  "last_name" VARCHAR,
  "country_code" VARCHAR,
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
);
-- assign ownership to main db user
ALTER TABLE predicts.user_header
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.user_header TO "%1$s";
-- Give necessary instructions to write user
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.user_header TO "%2$s";
GRANT USAGE ON predicts.user_header_id_seq TO "%2$s";
-- Give necessary instructions to read user
GRANT SELECT ON TABLE predicts.user_header TO "%3$s";

/**********************************************
 * 2. CREATE user_role Table                *
 *                                            *
 **********************************************/
CREATE TABLE predicts.user_role
(
  "id" SERIAL PRIMARY KEY,
  "name" VARCHAR,
  "description" VARCHAR,
  "date_created" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  "date_modified" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);
-- assign ownership to main db user
ALTER TABLE predicts.user_role
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.user_role TO "%1$s";
-- Give necessary instructions to write user
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.user_role TO "%2$s";
GRANT USAGE ON predicts.user_role_id_seq TO "%2$s";
-- Give necessary instructions to read user
GRANT SELECT ON TABLE predicts.user_role TO "%3$s";

/**********************************************
 * 3. CREATE user_assigned_role Table         *
 *                                            *
 **********************************************/
CREATE TABLE predicts.user_assigned_role
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
);
ALTER TABLE predicts.user_assigned_role
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.user_assigned_role TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.user_assigned_role TO "%2$s";
GRANT USAGE ON predicts.user_assigned_role_id_seq TO "%2$s";
GRANT SELECT ON TABLE predicts.user_assigned_role TO "%3$s";

/**********************************************
 * 4. CREATE user_connection Table            *
 *                                            *
 **********************************************/
CREATE TABLE predicts.user_connection
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
);
ALTER TABLE predicts.user_connection
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.user_connection TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.user_connection TO "%2$s";
GRANT USAGE ON predicts.user_connection_id_seq TO "%2$s";
GRANT SELECT ON TABLE predicts.user_connection TO "%3$s";

/**********************************************
 * 5. CREATE contest_type Table               *
 *                                            *
 **********************************************/
CREATE TABLE predicts.contest_type
(
  "id" SERIAL PRIMARY KEY,
  "name" VARCHAR,
  "description" VARCHAR,
  "date_created" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  "date_modified" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);
-- assign ownership to main db user
ALTER TABLE predicts.contest_type
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.contest_type TO "%1$s";
-- Give necessary instructions to write user
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.contest_type TO "%2$s";
GRANT USAGE ON predicts.contest_type_id_seq TO "%2$s";
-- Give necessary instructions to read user
GRANT SELECT ON TABLE predicts.contest_type TO "%3$s";

/**********************************************
 * 6. CREATE contest_header Table             *
 *                                            *
 **********************************************/
CREATE TABLE predicts.contest_header
(
  "id" SERIAL PRIMARY KEY,
  "contest_name" VARCHAR,
  "is_active" BOOLEAN,
  "is_default" BOOLEAN,
  "created_by" INTEGER, -- FK CONSTRAINT
  "current_owner" INTEGER, -- FK CONSTRAINT
  "contest_type_id" INTEGER, -- FK CONSTRAINT
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
  -- contest_type_id
  CONSTRAINT contest_header_contest_type_id FOREIGN KEY (contest_type_id)
    REFERENCES predicts.contest_type (id),
  -- last_modified_by
  CONSTRAINT contest_header_last_modified_by FOREIGN KEY (last_modified_by)
    REFERENCES predicts.user_header (id)
);
ALTER TABLE predicts.contest_header
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.contest_header TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.contest_header TO "%2$s";
GRANT USAGE ON predicts.contest_header_id_seq TO "%2$s";
GRANT SELECT ON TABLE predicts.contest_header TO "%3$s";

/**********************************************
 * 7. CREATE scoring_type Table               *
 *                                            *
 **********************************************/
CREATE TABLE predicts.scoring_type
(
  "id" SERIAL PRIMARY KEY,
  "name" VARCHAR,
  "description" VARCHAR,
  "date_created" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  "date_modified" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);
-- assign ownership to main db user
ALTER TABLE predicts.scoring_type
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.scoring_type TO "%1$s";
-- Give necessary instructions to write user
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.scoring_type TO "%2$s";
GRANT USAGE ON predicts.scoring_type_id_seq TO "%2$s";
-- Give necessary instructions to read user
GRANT SELECT ON TABLE predicts.scoring_type TO "%3$s";

/*************************************************
 * 8. CREATE default_scoring_system_header Table *
 *                                               *
 *************************************************/
CREATE TABLE predicts.default_scoring_system_header
(
  "id" SERIAL PRIMARY KEY,
  "is_custom" INTEGER,
  "name" VARCHAR,
  "description" VARCHAR,
  "date_created" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  "date_modified" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);
ALTER TABLE predicts.default_scoring_system_header
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.default_scoring_system_header TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.default_scoring_system_header TO "%2$s";
GRANT USAGE ON predicts.default_scoring_system_header_id_seq TO "%2$s";
GRANT SELECT ON TABLE predicts.default_scoring_system_header TO "%3$s";

/*************************************************
 * 9. CREATE default_scoring_system_detail Table *
 *                                               *
 *************************************************/
CREATE TABLE predicts.default_scoring_system_detail
(
  "id" SERIAL PRIMARY KEY,
  "default_scoring_system_header_id" INTEGER,  -- FK CONSTRAINT
  "scoring_type_id" INTEGER, -- FK CONSTRAINT
  "is_active" INTEGER,
  "is_default" INTEGER,
  "start_date" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  "end_date" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  "points" SMALLINT,
  "date_created" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  "date_modified" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  /* constraint */
  -- default_scoring_system_header_id
  CONSTRAINT default_scoring_system_detail_default_scoring_system_header_id FOREIGN KEY (default_scoring_system_header_id)
    REFERENCES predicts.default_scoring_system_header (id),
  -- scoring_type_id
  CONSTRAINT default_scoring_system_detail_scoring_type_id FOREIGN KEY (scoring_type_id)
    REFERENCES predicts.scoring_type (id)
);
ALTER TABLE predicts.default_scoring_system_detail
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.default_scoring_system_detail TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.default_scoring_system_detail TO "%2$s";
GRANT USAGE ON predicts.default_scoring_system_detail_id_seq TO "%2$s";
GRANT SELECT ON TABLE predicts.default_scoring_system_detail TO "%3$s";

/**********************************************
 * 10. CREATE scoring_system_header Table     *
 *                                            *
 **********************************************/
CREATE TABLE predicts.scoring_system_header
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
);
ALTER TABLE predicts.scoring_system_header
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.scoring_system_header TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.scoring_system_header TO "%2$s";
GRANT USAGE ON predicts.scoring_system_header_id_seq TO "%2$s";
GRANT SELECT ON TABLE predicts.scoring_system_header TO "%3$s";

/**********************************************
 * 11. CREATE scoring_system_detail Table     *
 *                                            *
 **********************************************/
CREATE TABLE predicts.scoring_system_detail
(
  "id" SERIAL PRIMARY KEY,
  "scoring_system_header_id" INTEGER, -- FK CONSTRAINT
  "scoring_type_id" INTEGER, -- FK CONSTRAINT
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
  -- scoring_type_id
  CONSTRAINT scoring_system_detail_scoring_type_id FOREIGN KEY (scoring_type_id)
    REFERENCES predicts.scoring_type (id),
  -- created_by
  CONSTRAINT scoring_system_detail_created_by FOREIGN KEY (created_by)
    REFERENCES predicts.user_header (id),
  -- last_modified_by
  CONSTRAINT scoring_system_detail_last_modified_by FOREIGN KEY (last_modified_by)
    REFERENCES predicts.user_header (id)
);
ALTER TABLE predicts.scoring_system_detail
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.scoring_system_detail TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.scoring_system_detail TO "%2$s";
GRANT USAGE ON predicts.scoring_system_detail_id_seq TO "%2$s";
GRANT SELECT ON TABLE predicts.scoring_system_detail TO "%3$s";

/**********************************************
 * 12. CREATE user_invite Table               *
 *                                            *
 **********************************************/
CREATE TABLE predicts.user_invite
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
);
ALTER TABLE predicts.user_invite
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.user_invite TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.user_invite TO "%2$s";
GRANT USAGE ON predicts.user_invite_id_seq TO "%2$s";
GRANT SELECT ON TABLE predicts.user_invite TO "%3$s";

/**********************************************
 * 13. CREATE successful_invite_user Table    *
 *                                            *
 **********************************************/
CREATE TABLE predicts.successful_invite_user
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
);
ALTER TABLE predicts.successful_invite_user
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.successful_invite_user TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.successful_invite_user TO "%2$s";
GRANT USAGE ON predicts.successful_invite_user_id_seq TO "%2$s";
GRANT SELECT ON TABLE predicts.successful_invite_user TO "%3$s";

/**********************************************
 * 14. CREATE participant_type Table          *
 *                                            *
 **********************************************/
CREATE TABLE predicts.participant_type
(
  "id" SERIAL PRIMARY KEY,
  "participant_type_name" VARCHAR,
  "participant_description" VARCHAR,
  "date_created" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  "date_modified" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);
ALTER TABLE predicts.participant_type
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.participant_type TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.participant_type TO "%2$s";
GRANT USAGE ON predicts.participant_type_id_seq TO "%2$s";
GRANT SELECT ON TABLE predicts.participant_type TO "%3$s";

/**********************************************
 * 15. CREATE contest_user Table              *
 *                                            *
 **********************************************/
CREATE TABLE predicts.contest_user
(
  "id" SERIAL PRIMARY KEY,
  "contest_header_id" INTEGER, -- FK CONSTRAINT
  "participant_type_id" INTEGER, -- FK CONSTRAINT
  "user_id" INTEGER, -- FK CONSTRAINT
  "is_invited" BOOLEAN,
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
    REFERENCES predicts.contest_header (id),
  -- participant_type_id
  CONSTRAINT contest_user_participant_type_id FOREIGN KEY (participant_type_id)
    REFERENCES predicts.participant_type (id),
  -- user_id
  CONSTRAINT contest_user_user_id FOREIGN KEY (user_id)
    REFERENCES predicts.user_header (id),
  -- created_by
  CONSTRAINT contest_user_created_by FOREIGN KEY (created_by)
    REFERENCES predicts.user_header (id),
  -- invited_by
  CONSTRAINT contest_user_invited_by FOREIGN KEY (invited_by)
    REFERENCES predicts.user_header (id)
);
ALTER TABLE predicts.contest_user
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.contest_user TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.contest_user TO "%2$s";
GRANT USAGE ON predicts.contest_user_id_seq TO "%2$s";
GRANT SELECT ON TABLE predicts.contest_user TO "%3$s";

/**********************************************
 * 16. CREATE contest_invite_type Table       *
 *                                            *
 **********************************************/
CREATE TABLE predicts.contest_invite_type
(
  "id" SERIAL PRIMARY KEY,
  "name" VARCHAR,
  "date_created" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  "date_modified" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);
-- assign ownership to main db user
ALTER TABLE predicts.contest_invite_type
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.contest_invite_type TO "%1$s";
-- Give necessary instructions to write user
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.contest_invite_type TO "%2$s";
GRANT USAGE ON predicts.contest_invite_type_id_seq TO "%2$s";
-- Give necessary instructions to read user
GRANT SELECT ON TABLE predicts.contest_invite_type TO "%3$s";

/************************************************
 * 17. CREATE contest_invite_application Table  *
 *                                              *
 ************************************************/
CREATE TABLE predicts.contest_invite_application
(
  "id" SERIAL PRIMARY KEY,
  "contest_header_id" INTEGER,
  "contest_invite_type_id" INTEGER,
  "user_id" INTEGER,
  "is_confirmed" BOOLEAN,
  "is_outstanding" BOOLEAN,
  "responded_by" INTEGER,
  "date_created" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  "date_modified" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  /* Constraints */
  -- contest_header_id
  CONSTRAINT contest_invite_application_contest_header_id FOREIGN KEY (contest_header_id)
    REFERENCES predicts.contest_header (id),
  -- contest_invite_type_id
  CONSTRAINT contest_invite_application_contest_invite_type_id FOREIGN KEY (contest_invite_type_id)
    REFERENCES predicts.contest_invite_type (id),
  -- user_id
  CONSTRAINT contest_invite_application_user_id FOREIGN KEY (user_id)
    REFERENCES predicts.user_header (id),
  -- responded_by
  CONSTRAINT contest_invite_application_responded_by FOREIGN KEY (responded_by)
    REFERENCES predicts.user_header (id)
);
-- assign ownership to main db user
ALTER TABLE predicts.contest_invite_application
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.contest_invite_application TO "%1$s";
-- Give necessary instructions to write user
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.contest_invite_application TO "%2$s";
GRANT USAGE ON predicts.contest_invite_application_id_seq TO "%2$s";
-- Give necessary instructions to read user
GRANT SELECT ON TABLE predicts.contest_invite_application TO "%3$s";

/**********************************************
 * 18. CREATE team Table                      *
 *                                            *
 **********************************************/
CREATE TABLE predicts.team
(
  "code" INTEGER,
  "fpl_team_id" INTEGER UNIQUE,
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
);
ALTER TABLE predicts.team
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.team TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.team TO "%2$s";
GRANT SELECT ON TABLE predicts.team TO "%3$s";

/**********************************************
 * 19. CREATE season Table                    *
 *                                            *
 **********************************************/
CREATE TABLE predicts.season
(
  "id" SERIAL PRIMARY KEY,
  "competition" VARCHAR,
  "start_year" INTEGER,
  "end_year" INTEGER,
  "is_current" BOOLEAN,
  "is_previous" BOOLEAN,
  "is_next" BOOLEAN,
  "date_created" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  "date_modified" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);
ALTER TABLE predicts.season
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.season TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.season TO "%2$s";
GRANT USAGE ON predicts.season_id_seq TO "%2$s";
GRANT SELECT ON TABLE predicts.season TO "%3$s";

/**********************************************
 * 20. CREATE event Table                     *
 *                                            *
 **********************************************/
CREATE TABLE predicts.event
(
  "id" SERIAL PRIMARY KEY,
  "fpl_event_id" INTEGER,
  "season_id" INTEGER, -- FK CONSTRAINT
  "average_entry_score" INTEGER,
  "data_checked" BOOLEAN,
  "deadline_time" timestamp,
  "deadline_time_epoch" INTEGER,
  "deadline_time_formatted" VARCHAR,
  "deadline_time_game_offset" INTEGER,
  "finished" BOOLEAN,
  "highest_score" INTEGER,
  "highest_scoring_entry" INTEGER,
  "is_current" BOOLEAN,
  "is_next" BOOLEAN,
  "is_previous" BOOLEAN,
  "name" VARCHAR,
  "date_created" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  "date_modified" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  /* Constraint */
  -- season_id
  CONSTRAINT event_season_id FOREIGN KEY (season_id)
    REFERENCES predicts.season (id)
);
ALTER TABLE predicts.event
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.event TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.event TO "%2$s";
GRANT USAGE ON predicts.event_id_seq TO "%2$s";
GRANT SELECT ON TABLE predicts.event TO "%3$s";

/**********************************************
 * 21. CREATE fixture_header Table            *
 *                                            *
 **********************************************/
CREATE TABLE predicts.fixture_header
(
  "id" SERIAL PRIMARY KEY,
  "fpl_fixture_id" INTEGER,
  "season_id" INTEGER, -- FK CONSTRAINT
  "fantasy_id" INTEGER,
  "code" INTEGER,
  "deadline_time" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  "deadline_time_formatted" VARCHAR,
  "event_id" INTEGER, -- FK CONSTRAINT
  "event_day" SMALLINT,
  "finished" BOOLEAN,
  "finished_provisional" BOOLEAN,
  "kickoff_time" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  "kickoff_time_formatted" VARCHAR,
  "minutes" SMALLINT,
  "provisional_start_time" BOOLEAN,
  "started" BOOLEAN,
  "team_a" INTEGER, -- FK CONSTRAINT
  "team_a_score" SMALLINT,
  "team_h" INTEGER, -- FK CONSTRAINT
  "team_h_score" SMALLINT,
  "result" VARCHAR(2),
  "last_modified_by" INTEGER,
  "date_created" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  "date_modified" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  /* Constraint */
  -- season_id
  CONSTRAINT fixture_header_season_id FOREIGN KEY (season_id)
    REFERENCES predicts.season (id),
  -- event_id
  CONSTRAINT fixture_header_event_id FOREIGN KEY (event_id)
    REFERENCES predicts.event (id),
  -- team_a
  CONSTRAINT fixture_header_team_a FOREIGN KEY (team_a)
    REFERENCES predicts.team (fpl_team_id),
  -- team_h
  CONSTRAINT fixture_header_team_h FOREIGN KEY (team_h)
    REFERENCES predicts.team (fpl_team_id)
);
ALTER TABLE predicts.fixture_header
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.fixture_header TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.fixture_header TO "%2$s";
GRANT USAGE ON predicts.fixture_header_id_seq TO "%2$s";
GRANT SELECT ON TABLE predicts.fixture_header TO "%3$s";

/**********************************************
 * 22. CREATE default_slate_header Table      *
 *                                            *
 **********************************************/
CREATE TABLE predicts.default_slate_header
(
  "id" SERIAL PRIMARY KEY,
  "source" VARCHAR,
  "type" VARCHAR,
  "event_id" INTEGER, -- FK CONSTRAINT
  "date_created" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  "date_modified" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  /* Constraint */
  -- event_id
  CONSTRAINT default_slate_header_event_id FOREIGN KEY (event_id)
    REFERENCES predicts.event (id)
);
ALTER TABLE predicts.default_slate_header
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.default_slate_header TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.default_slate_header TO "%2$s";
GRANT USAGE ON predicts.default_slate_header_id_seq TO "%2$s";
GRANT SELECT ON TABLE predicts.default_slate_header TO "%3$s";

/**********************************************
 * 23. CREATE default_slate_entry Table     *
 *                                            *
 **********************************************/
CREATE TABLE predicts.default_slate_entry
(
  "id" SERIAL PRIMARY KEY,
  "default_slate_header_id" INTEGER, -- FK CONSTRAINT
  "fixture_id" INTEGER, -- FK CONSTRAINT
  "date_created" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  "date_modified" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  /* Constraint */
  -- default_slate_header_id
  CONSTRAINT default_slate_entry_default_slate_header_id FOREIGN KEY (default_slate_header_id)
    REFERENCES predicts.default_slate_header (id),
  -- fixture_id
  CONSTRAINT default_slate_entry_fixture_id FOREIGN KEY (fixture_id)
    REFERENCES predicts.fixture_header (id)
);
ALTER TABLE predicts.default_slate_entry
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.default_slate_entry TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.default_slate_entry TO "%2$s";
GRANT USAGE ON predicts.default_slate_entry_id_seq TO "%2$s";
GRANT SELECT ON TABLE predicts.default_slate_entry TO "%3$s";

/**********************************************
 * 24. CREATE contest_slate_header Table      *
 *                                            *
 **********************************************/
CREATE TABLE predicts.contest_slate_header
(
  "id" SERIAL PRIMARY KEY,
  "contest_header_id" INTEGER, -- FK CONSTRAINT
  "event_id" INTEGER, -- FK CONSTRAINT
  "from_default" BOOLEAN,
  "is_active" BOOLEAN,
  "start_date" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  "end_date" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  "has_started" BOOLEAN,
  "has_finished" BOOLEAN,
  "total_possible_entries" INTEGER,
  "total_entries" INTEGER,
  "date_created" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  "date_modified" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  /* Constraint */
  -- contest_header_id
  CONSTRAINT contest_slate_header_contest_header_id FOREIGN KEY (contest_header_id)
    REFERENCES predicts.contest_header (id),
  -- event_id
  CONSTRAINT contest_slate_header_event_id FOREIGN KEY (event_id)
    REFERENCES predicts.event (id)
);
ALTER TABLE predicts.contest_slate_header
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.contest_slate_header TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.contest_slate_header TO "%2$s";
GRANT USAGE ON predicts.contest_slate_header_id_seq TO "%2$s";
GRANT SELECT ON TABLE predicts.contest_slate_header TO "%3$s";

/**********************************************
 * 25. CREATE contest_slate_entry Table       *
 *                                            *
 **********************************************/
CREATE TABLE predicts.contest_slate_entry
(
  "id" SERIAL PRIMARY KEY,
  "contest_slate_header_id" INTEGER,
  "fixture_id" INTEGER,
  "date_created" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  "date_modified" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  /* Constraint */
  -- contest_slate_header_id
  CONSTRAINT contest_slate_entry_contest_slate_header_id  FOREIGN KEY (contest_slate_header_id)
    REFERENCES predicts.contest_slate_header (id),
  -- fixture_id
  CONSTRAINT contest_slate_entry_fixture_id FOREIGN KEY (fixture_id)
    REFERENCES predicts.fixture_header (id)
);
ALTER TABLE predicts.contest_slate_entry
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.contest_slate_entry TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.contest_slate_entry TO "%2$s";
GRANT USAGE ON predicts.contest_slate_entry_id_seq TO "%2$s";
GRANT SELECT ON TABLE predicts.contest_slate_entry TO "%3$s";

/*********************************************************
 * 26. CREATE contest_slate_header_default_header Table  *
 *                                                       *
 *********************************************************/
CREATE TABLE predicts.contest_slate_header_default_header
(
  "id" SERIAL PRIMARY KEY,
  "contest_slate_header_id" INTEGER,
  "default_slate_header_id" INTEGER,
  "date_created" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  "date_modified" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  /* Constraint */
  -- contest_slate_header_id
  CONSTRAINT contest_slate_header_default_header_contest_slate_header_id FOREIGN KEY (contest_slate_header_id)
    REFERENCES predicts.contest_slate_header (id),
  -- default_slate_header_id
  CONSTRAINT contest_slate_header_default_header_default_slate_header_id FOREIGN KEY (default_slate_header_id)
    REFERENCES predicts.default_slate_header (id)
);
ALTER TABLE predicts.contest_slate_header_default_header
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.contest_slate_header_default_header TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.contest_slate_header_default_header TO "%2$s";
GRANT USAGE ON predicts.contest_slate_header_default_header_id_seq TO "%2$s";
GRANT SELECT ON TABLE predicts.contest_slate_header_default_header TO "%3$s";

/**********************************************
 * 27. CREATE contest_result Table            *
 *                                            *
 **********************************************/
CREATE TABLE predicts.contest_result
(
  "id" SERIAL PRIMARY KEY,
  "contest_slate_entry_id" INTEGER, -- FK CONSTRAINT
  "contest_user_id" INTEGER, -- FK CONSTRAINT
  "home_score" INTEGER,
  "away_score" INTEGER,
  "expected_result" VARCHAR(2),
  "home_score_matches" BOOLEAN,
  "away_score_matches" BOOLEAN,
  "scores_matches" BOOLEAN,
  "result_matches" BOOLEAN,
  "is_banker" BOOLEAN,
  "has_started" BOOLEAN,
  "has_finished" BOOLEAN,
  "deadline_time" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  "date_created" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  "date_modified" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  /* Constraint */
  -- contest_slate_entry_id
  CONSTRAINT contest_result_contest_slate_entry_id FOREIGN KEY (contest_slate_entry_id)
    REFERENCES predicts.contest_slate_entry (id),
  -- contest_user_id
  CONSTRAINT contest_result_contest_user_id FOREIGN KEY (contest_user_id)
    REFERENCES predicts.contest_user (id)
);
ALTER TABLE predicts.contest_result
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.contest_result TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.contest_result TO "%2$s";
GRANT USAGE ON predicts.contest_result_id_seq TO "%2$s";
GRANT SELECT ON TABLE predicts.contest_result TO "%3$s";

/**********************************************
 * 28. CREATE contest_result_score Table      *
 *                                            *
 **********************************************/
CREATE TABLE predicts.contest_result_score
(
  "id" SERIAL PRIMARY KEY,
  "scoring_system_detail_id" INTEGER,
  "contest_result_id" INTEGER,
  "points_available" INTEGER,
  "points_scored" INTEGER,
  "date_created" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  "date_modified" TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  /* Constraint */
  -- scoring_system_detail_id
  CONSTRAINT contest_result_score_scoring_system_detail_id FOREIGN KEY (scoring_system_detail_id)
    REFERENCES predicts.scoring_system_detail (id),
  -- contest_result_id
  CONSTRAINT contest_result_contest_result_id FOREIGN KEY (contest_result_id)
    REFERENCES predicts.contest_result (id)
);
ALTER TABLE predicts.contest_result_score
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.contest_result_score TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.contest_result_score TO "%2$s";
GRANT USAGE ON predicts.contest_result_score_id_seq TO "%2$s";
GRANT SELECT ON TABLE predicts.contest_result_score TO "%3$s";
