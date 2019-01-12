/**
 * Build DB
 **/

/* 15. */ DROP TABLE IF EXISTS predicts.contestdetail;
/* 14. */ DROP TABLE IF EXISTS predicts.contestscoring;
/* 13. */ DROP TABLE IF EXISTS predicts.contestcost;
/* 12. */ DROP TABLE IF EXISTS predicts.contestledger;
/* 11. */ DROP TABLE IF EXISTS predicts.contestuser;
/* 10. */ DROP TABLE IF EXISTS predicts.contestresult;
/* 9.  */ DROP TABLE IF EXISTS predicts.contestslateentries;
/* 9.  */ DROP TABLE IF EXISTS predicts.contestslateheader;
/* 8.  */ DROP TABLE IF EXISTS predicts.contestheader;
/*   */ DROP TABLE IF EXISTS predicts.defaultslateentries;
/* 5.  */ DROP TABLE IF EXISTS predicts.defaultslateheader;
/* 4.  */ DROP TABLE IF EXISTS predicts.fixturestats;
/* 4.  */ DROP TABLE IF EXISTS predicts.availablestats;
/* 3.  */ DROP TABLE IF EXISTS predicts.fixtureheader;
/*   */ DROP TABLE IF EXISTS predicts.team;
/* 2.  */ DROP TABLE IF EXISTS predicts.particpanttype;
/* 1.  */ DROP TABLE IF EXISTS predicts.scoringsystemdetail;
/* 1.  */ DROP TABLE IF EXISTS predicts.scoringsystemheader;
/* 7.  */ DROP TABLE IF EXISTS predicts.userconnections;
/* 6.  */ DROP TABLE IF EXISTS predicts.userheader;
/* 7.  */ DROP TABLE IF EXISTS predicts.useradmin;

CREATE SCHEMA IF NOT EXISTS predicts AUTHORIZATION "%1$s";

GRANT USAGE ON SCHEMA predicts TO predictsapiwrite;
GRANT USAGE ON SCHEMA predicts TO predictsapiread;

/**********************************************
 * 6. CREATE UserAdmin Table                  *
 *                                            *
 **********************************************/
CREATE TABLE predicts.useradmin
(
  id SERIAL PRIMARY KEY,
  email VARCHAR NOT NULL,
  password VARCHAR NOT NULL,
  role BOOLEAN NOT NULL,
  date_created TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  date_modified TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
)
ALTER TABLE predicts.useradmin
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.useradmin TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.useradmin TO predictsapiwrite;
GRANT USAGE ON predicts.useradmin_id_seq TO predictsapiwrite;
GRANT SELECT ON TABLE predicts.useradmin TO predictsapiread;

/**********************************************
 * 6. CREATE UserHeader Table                 *
 *                                            *
 **********************************************/
CREATE TABLE predicts.userheader
(
  id SERIAL PRIMARY KEY,
  email VARCHAR NOT NULL,
  password VARCHAR NOT NULL,
  is_premium BOOLEAN NOT NULL,
  date_created TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  date_modified TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
)
ALTER TABLE predicts.userheader
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.userheader TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.userheader TO predictsapiwrite;
GRANT USAGE ON predicts.userheader_id_seq TO predictsapiwrite;
GRANT SELECT ON TABLE predicts.userheader TO predictsapiread;

/**********************************************
 * 7. CREATE UserConnections Table            *
 *                                            *
 **********************************************/
CREATE TABLE predicts.userconnections
(
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL, -- FK CONSTRAINT
  follower_id INTEGER NOT NULL, -- FK CONSTRAINT
  awaiting_response BOOLEAN NOT NULL,
  is_active BOOLEAN NOT NULL,
  is_blocked BOOLEAN NOT NULL,
  date_created TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  date_modified TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
  /* Constraint */
  -- user_id
  CONSTRAINT userconnections_user_id FOREIGN KEY (user_id)
    REFERENCES predicts.userheader (id),
  -- follower_id
  CONSTRAINT userconnections_follower_id FOREIGN KEY (follower_id)
    REFERENCES predicts.userheader (id),

)
ALTER TABLE predicts.userconnections
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.userconnections TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.userconnections TO predictsapiwrite;
GRANT USAGE ON predicts.userconnections_id_seq TO predictsapiwrite;
GRANT SELECT ON TABLE predicts.userconnections TO predictsapiread;

/**********************************************
 * 1. CREATE ScoringSystem Table              *
 *                                            *
 **********************************************/
CREATE TABLE predicts.scoringsystemheader
(
  id SERIAL PRIMARY KEY,
  name VARCHAR NOT NULL,
  is_default BOOLEAN NOT NULL,
  is_custom BOOLEAN NOT NULL,
  created_by INTEGER NOT NULL, -- FK CONSTRAINT USERS
  date_created TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  date_modified TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
)
ALTER TABLE predicts.scoringsystemheader
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.scoringsystemheader TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.scoringsystemheader TO predictsapiwrite;
GRANT USAGE ON predicts.scoringsystemheader_id_seq TO predictsapiwrite;
GRANT SELECT ON TABLE predicts.scoringsystemheader TO predictsapiread;

/**********************************************
 * 2. CREATE ParticipantType Table            *
 *                                            *
 **********************************************/
CREATE TABLE predicts.particpanttype
(
  id SERIAL PRIMARY KEY,
  name VARCHAR(20) NOT NULL
)
ALTER TABLE predicts.particpanttype
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.particpanttype TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.particpanttype TO predictsapiwrite;
GRANT USAGE ON predicts.particpanttype_id_seq TO predictsapiwrite;
GRANT SELECT ON TABLE predicts.particpanttype TO predictsapiread;

/**********************************************
 * 3. CREATE Team Table                       *
 *                                            *
 **********************************************/
CREATE TABLE predicts.team
(
  id SERIAL PRIMARY KEY,
  season_id INTEGER NOT NULL,
  season INTEGER NOT NULL,
  date_created TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  date_modified TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
)
ALTER TABLE predicts.team
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.team TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.team TO predictsapiwrite;
GRANT USAGE ON predicts.team_id_seq TO predictsapiwrite;
GRANT SELECT ON TABLE predicts.team TO predictsapiread;

/**********************************************
 * 3. CREATE FixtureHeader Table               *
 *                                            *
 **********************************************/
CREATE TABLE predicts.fixtureheader
(
  id SERIAL PRIMARY KEY,
  fantasyid INTEGER,
  code INTEGER,
  deadline_time TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()),
  deadline_time_formatted VARCHAR(30),
  event SMALLINT,
  event_day SMALLINT,
  finished BOOLEAN NOT NULL,
  finished_provisional BOOLEAN NOT NULL,
  kickoff_time TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()),
  kickoff_time_formatted VARCHAR(30),
  minutes SMALLINT NOT NULL,
  provisional_start_time BOOLEAN NOT NULL,
  started BOOLEAN NOT NULL,
  team_a INTEGER NOT NULL, -- FK constraint team id
  team_a_score SMALLINT
  teah_h INTEGER NOT NULL, -- FK constraint team id
  team_h_score SMALLINT,
  result VARCHAR(2),
  last_modified_by INTEGER, -- FK constraint user admin
  date_created TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  date_modified TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  /* Constraints */
  -- a team id
  CONSTRAINT fixtureheader_team_a FOREIGN KEY (team_a)
    REFERENCES predicts.team (season_id),
  -- h team id
  CONSTRAINT fixtureheader_team_h FOREIGN KEY (team_h)
    REFERENCES predicts.team (season_id),
  -- last_modified_by
  CONSTRAINT fixtureheader_last_modified_by FOREIGN KEY (last_modified_by)
    REFERENCES predicts.useradmin (id)
)
ALTER TABLE predicts.fixtureheader
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.fixtureheader TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.fixtureheader TO predictsapiwrite;
GRANT USAGE ON predicts.fixtureheader_id_seq TO predictsapiwrite;
GRANT SELECT ON TABLE predicts.fixtureheader TO predictsapiread;

/**********************************************
 * 4. CREATE Available Stats Table            *
 *                                            *
 **********************************************/ 
CREATE TABLE predicts.availablestats
(
  id SERIAL PRIMARY KEY,
  name VARCHAR NOT NULL,
  description VARCHAR NOT NULL,
  last_modified_by INTEGER NOT NULL,
  date_created TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  date_modified TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  /* Constraints */
  -- last_modified_by
  CONSTRAINT fixtureheader_last_modified_by FOREIGN KEY (last_modified_by)
    REFERENCES predicts.useradmin (id)
)
ALTER TABLE predicts.availablestats
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.availablestats TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.availablestats TO predictsapiwrite;
GRANT USAGE ON predicts.availablestats_id_seq TO predictsapiwrite;
GRANT SELECT ON TABLE predicts.availablestats TO predictsapiread;

/**********************************************
 * 4. CREATE FixtureStats Table               *
 *                                            *
 **********************************************/
CREATE TABLE predicts.fixturestats
(
  id SERIAL PRIMARY KEY,
  fixture_id INTEGER NOT NULL, -- FK CONSTRAINT
  team_id INTEGER NOT NULL, -- FK CONSTRAINT
  home_away VARCHAR(1) NOT NULL,
  statistic_id INTEGER NOT NULL, -- FK CONSTRAINT
  score FLOAT, -- CHECK THIS TYPE
  last_modified_by INTEGER NOT NULL,
  date_created TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  date_modified TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  /* Constraints */
  -- fixture_id
  CONSTRAINT fixturestats_fixture_id FOREIGN KEY (fixture_id)
    REFERENCES predicts.fixturestats (id)
  -- team_id
  CONSTRAINT fixturestats_team_id FOREIGN KEY (team_id)
    REFERENCES predicts.team (id)
  -- statistic_id
  CONSTRAINT fixturestats_statistic_id FOREIGN KEY (statistic_id)
    REFERENCES predicts.availablestats (id)
  -- last_modified_by
  CONSTRAINT fixturestats_last_modified_by FOREIGN KEY (last_modified_by)
    REFERENCES predicts.useradmin (id)
)
ALTER TABLE predicts.fixturestats
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.fixturestats TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.fixturestats TO predictsapiwrite;
GRANT USAGE ON predicts.fixturestats_id_seq TO predictsapiwrite;
GRANT SELECT ON TABLE predicts.fixturestats TO predictsapiread;


/**********************************************
 * 5. CREATE DefaultSlateHeader Table         *
 *                                            *
 **********************************************/
CREATE TABLE predicts.defaultslateheader
(
  id SERIAL PRIMARY KEY,
  count INTEGER NOT NULL,
  name VARCHAR(20) NOT NULL,
  event SMALLINT NOT NULL, -- FK CONSTRAINT
  source VARCHAR(20) NOT NULL,
  created_by INTEGER NOT NULL,
  last_modified_by INTEGER NOT NULL,
  date_created TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  date_modified TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  /* Constraints */
  -- event
  CONSTRAINT defaultslateheader_event FOREIGN KEY (event)
    REFERENCES predicts.fixtureheader (event)

)
ALTER TABLE predicts.defaultslateheader
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.defaultslateheader TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.defaultslateheader TO predictsapiwrite;
GRANT USAGE ON predicts.defaultslateheader_id_seq TO predictsapiwrite;
GRANT SELECT ON TABLE predicts.defaultslateheader TO predictsapiread;

/**********************************************
 * 5. CREATE DefaultSlateEntries Table        *
 *                                            *
 **********************************************/
CREATE TABLE predicts.defaultslateentries
(
  id SERIAL PRIMARY KEY,
  slate_header_id INTEGER NOT NULL, -- FK CONSTRAINT 
  fixture_id INTEGER NOT NULL,
  last_modified_by INTEGER NOT NULL, -- FK CONSTRAINT -- only admin users can alter this table
  date_created TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  date_modified TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  /* Constraints */
  -- slate_header_id
  CONSTRAINT defaultslateentries_slate_header_id FOREIGN KEY (slate_header_id)
    REFERENCES predicts.defaultslateheader (id)
  -- last_modified_by
  CONSTRAINT defaultslateentries_last_modified_by FOREIGN KEY (last_modified_by)
    REFERENCES predicts.useradmin (id)
)
ALTER TABLE predicts.defaultslateentries
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.defaultslateentries TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.defaultslateentries TO predictsapiwrite;
GRANT USAGE ON predicts.defaultslateentries_id_seq TO predictsapiwrite;
GRANT SELECT ON TABLE predicts.defaultslateentries TO predictsapiread;


/**********************************************
 * 8. CREATE ContestHeader Table              *
 *                                            *
 **********************************************/
CREATE TABLE predicts.contestheader
(
  id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  is_public BOOLEAN NOT NULL,
  is_paid_for BOOLEAN NOT NULL,
  is_active BOOLEAN NOT NULL,
  is_default BOOLEAN NOT NULL,
  inherited_from INTEGER, -- 
  created_by INTEGER NOT NULL, -- FK CONSTRAINT - users
  last_modified_by INTEGER NOT NULL, -- FK CONSTRAINT - users
  date_created TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  date_modified TIMESTAMP WITHOUT TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    /* Constraints */
  -- slate_header_id
  CONSTRAINT contestheader_slate_header_id FOREIGN KEY (slate_header_id)
    REFERENCES predicts.defaultslateheader (id)
  -- last_modified_by
  CONSTRAINT defaultslateentries_last_modified_by FOREIGN KEY (last_modified_by)
    REFERENCES predicts.userheader (id)
)
ALTER TABLE predicts.contestheader
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.contestheader TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.contestheader TO predictsapiwrite;
GRANT USAGE ON predicts.contestheader_id_seq TO predictsapiwrite;
GRANT SELECT ON TABLE predicts.contestheader TO predictsapiread;

/**********************************************
 * 9. CREATE ContestSlateHeader Table         *
 *                                            *
 **********************************************/
CREATE TABLE predicts.contestslateheader
(
  id SERIAL PRIMARY KEY,
)
ALTER TABLE predicts.contestslateheader
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.contestslateheader TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.contestslateheader TO predictsapiwrite;
GRANT USAGE ON predicts.contestslateheader_id_seq TO predictsapiwrite;
GRANT SELECT ON TABLE predicts.contestslateheader TO predictsapiread;

/**********************************************
 * 9. CREATE ContestSlateEntries Table         *
 *                                            *
 **********************************************/
CREATE TABLE predicts.contestslateentries
(
  id SERIAL PRIMARY KEY,
)
ALTER TABLE predicts.contestslateentries
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.contestslateentries TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.contestslateentries TO predictsapiwrite;
GRANT USAGE ON predicts.contestslateentries_id_seq TO predictsapiwrite;
GRANT SELECT ON TABLE predicts.contestslateentries TO predictsapiread;

/**********************************************
 * 10. CREATE ContestResult Table             *
 *                                            *
 **********************************************/
CREATE TABLE predicts.contestresult
(
  id SERIAL PRIMARY KEY,
)
ALTER TABLE predicts.contestresult
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.contestresult TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.contestresult TO predictsapiwrite;
GRANT USAGE ON predicts.contestresult_id_seq TO predictsapiwrite;
GRANT SELECT ON TABLE predicts.contestresult TO predictsapiread;

/**********************************************
 * 11. CREATE ContestUser Table               *
 *                                            *
 **********************************************/
CREATE TABLE predicts.contestuser
(
  id SERIAL PRIMARY KEY,
)
ALTER TABLE predicts.contestuser
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.contestuser TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.contestuser TO predictsapiwrite;
GRANT USAGE ON predicts.contestuser_id_seq TO predictsapiwrite;
GRANT SELECT ON TABLE predicts.contestuser TO predictsapiread;

/**********************************************
 * 12. CREATE ContestLedger Table               *
 *                                            *
 **********************************************/
CREATE TABLE predicts.contestledger
(
  id SERIAL PRIMARY KEY,
)
ALTER TABLE predicts.contestledger
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.contestledger TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.contestledger TO predictsapiwrite;
GRANT USAGE ON predicts.contestledger_id_seq TO predictsapiwrite;
GRANT SELECT ON TABLE predicts.contestledger TO predictsapiread;

/**********************************************
 * 13. CREATE ContestCost Table               *
 *                                            *
 **********************************************/
CREATE TABLE predicts.contestcost
(
  id SERIAL PRIMARY KEY,
)
ALTER TABLE predicts.contestcost
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.contestcost TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.contestcost TO predictsapiwrite;
GRANT USAGE ON predicts.contestcost_id_seq TO predictsapiwrite;
GRANT SELECT ON TABLE predicts.contestcost TO predictsapiread;

/**********************************************
 * 14. CREATE ContestScoring Table               *
 *                                            *
 **********************************************/
CREATE TABLE predicts.contestscoring
(
  id SERIAL PRIMARY KEY,
)
ALTER TABLE predicts.contestscoring
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.contestscoring TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.contestscoring TO predictsapiwrite;
GRANT USAGE ON predicts.contestscoring_id_seq TO predictsapiwrite;
GRANT SELECT ON TABLE predicts.contestscoring TO predictsapiread;

/**********************************************
 * 15. CREATE ContestDetail Table            *
 *                                            *
 **********************************************/
CREATE TABLE predicts.contestdetail
(
  id SERIAL PRIMARY KEY,
)
ALTER TABLE predicts.contestdetail
    OWNER to "%1$s";
GRANT ALL ON TABLE predicts.contestdetail TO "%1$s";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE predicts.contestdetail TO predictsapiwrite;
GRANT USAGE ON predicts.contestdetail_id_seq TO predictsapiwrite;
GRANT SELECT ON TABLE predicts.contestdetail TO predictsapiread;
