CREATE TABLE "user_header" (
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
  "date_created" timestamp,
  "date_modified" timestamp
);

CREATE TABLE "user_role" (
  "id" integer,
  "name" varchar,
  "description" varchar,
  "date_created" timestamp,
  "date_modified" timestamp
);

CREATE TABLE "user_assigned_role" (
  "id" integer,
  "user_header_id" integer,
  "user_role_id" integer,
  "date_created" timestamp,
  "date_modified" timestamp
);

CREATE TABLE "user_connection" (
  "id" integer,
  "user_id" integer,
  "follower_id" integer,
  "awaiting_response" boolean,
  "is_active" boolean,
  "is_blocked" boolean,
  "date_created" timestamp,
  "date_modified" timestamp
);

CREATE TABLE "contest_header" (
  "id" integer,
  "contest_name" varchar,
  "is_active" boolean,
  "is_default" boolean,
  "created_by" integer,
  "current_owner" integer,
  "is_public" boolean,
  "is_private" boolean,
  "invitation_code" varchar,
  "start_date" timestamp,
  "end_date" timestamp,
  "current_event" smallint,
  "total_events" smallint,
  "is_premium" boolean,
  "player_limit" integer,
  "last_modified_by" integer,
  "date_created" timestamp,
  "date_modified" timestamp
);

CREATE TABLE "scoring_system_header" (
  "id" integer,
  "contest_header_id" integer,
  "is_custom" integer,
  "created_by" integer,
  "last_modified_by" integer,
  "date_created" timestamp,
  "date_modified" timestamp
);

CREATE TABLE "scoring_system_detail" (
  "id" integer,
  "scoring_system_header_id" integer,
  "name" varchar,
  "description" varchar,
  "type" varchar,
  "is_active" boolean,
  "is_default" boolean,
  "created_by" integer,
  "start_date" timestamp,
  "end_date" timestamp,
  "points" smallint,
  "last_modified_by" integer,
  "date_created" timestamp,
  "date_modified" timestamp
);

CREATE TABLE "user_invite" (
  "id" integer,
  "invite_code" varchar,
  "email" varchar,
  "invite_creator" integer,
  "accepted" boolean,
  "date_created" timestamp,
  "date_modified" timestamp
);

CREATE TABLE "successful_invite_user" (
  "id" integer,
  "userinvite_id" integer,
  "new_user_id" integer,
  "date_created" timestamp,
  "date_modified" timestamp
);

CREATE TABLE "participant_type" (
  "id" integer,
  "participant_type_name" varchar,
  "participant_description" varchar,
  "date_created" timestamp,
  "date_modified" timestamp
);

CREATE TABLE "contest_user" (
  "id" integer,
  "contest_header_id" integer,
  "participant_type_id" integer,
  "user_id" integer,
  "is_invited" boolean,
  "invite_status_id" smallint,
  "is_active" boolean,
  "is_blocked" boolean,
  "balance" float,
  "created_by" integer,
  "invited_by" integer,
  "date_created" timestamp,
  "date_modified" timestamp
);

CREATE TABLE "team" (
  "code" integer,
  "fpl_team_id" integer,
  "fantasy_id" integer,
  "name" varchar,
  "short_name" varchar(3),
  "strength" smallint,
  "strength_attack_away" integer,
  "strength_attack_home" integer,
  "strength_defence_away" integer,
  "strength_defence_home" integer,
  "strength_overall_away" integer,
  "strength_overall_home" integer,
  "team_division" integer,
  "date_created" timestamp,
  "date_modified" timestamp
);

CREATE TABLE "season" (
  "id" integer,
  "competition" varchar,
  "start_year" integer,
  "end_year" integer,
  "is_current" boolean,
  "is_previous" boolean,
  "is_next" boolean,
  "date_created" timestamp,
  "date_modified" timestamp
);

CREATE TABLE "event" (
  "id" integer,
  "fpl_event_id" integer,
  "season_id" integer,
  "average_entry_score" integer,
  "data_checked" boolean,
  "deadline_time" timestamp,
  "deadline_time_epoch" integer,
  "deadline_time_formatted" varchar,
  "deadline_time_game_offset" integer,
  "finished" boolean,
  "highest_score" integer,
  "highest_scoring_entry" integer,
  "is_current" boolean,
  "is_next" boolean,
  "is_previous" boolean,
  "name" varchar
);

CREATE TABLE "fixture_header" (
  "id" integer,
  "fpl_fixture_id" integer,
  "season_id" integer,
  "fantasy_id" integer,
  "code" integer,
  "deadline_time" timestamp,
  "deadline_time_formatted" varchar,
  "event" integer,
  "event_day" smallint,
  "finished" boolean,
  "finished_provisional" boolean,
  "kickoff_time" timestamp,
  "kickoff_time_formatted" varchar,
  "minutes" smallint,
  "provisional_start_time" boolean,
  "started" boolean,
  "team_a" integer,
  "team_a_score" smallint,
  "team_h" integer,
  "team_h_score" smallint,
  "result" varchar(2),
  "last_modified_by" integer,
  "date_created" timestamp,
  "date_modified" timestamp
);

CREATE TABLE "default_slate_header" (
  "id" integer,
  "source" varchar,
  "type" varchar,
  "event_id" integer,
  "date_created" timestamp,
  "date_modified" timestamp
);

CREATE TABLE "default_slate_entries" (
  "id" integer,
  "default_slate_header_id" integer,
  "fixture_id" integer,
  "date_created" timestamp,
  "date_modified" timestamp
);

CREATE TABLE "contest_slate_header" (
  "id" integer,
  "contest_header_id" integer,
  "event_id" integer,
  "from_default" boolean,
  "is_active" boolean,
  "start_date" timestamp,
  "end_date" timestamp,
  "has_started" boolean,
  "has_finished" boolean,
  "total_possible_entries" integer,
  "total_entries" integer,
  "date_created" timestamp,
  "date_modified" timestamp
);

CREATE TABLE "contest_slate_entry" (
  "id" integer,
  "contest_slate_header_id" integer,
  "fixture_id" integer,
  "date_created" timestamp,
  "date_modified" timestamp
);

CREATE TABLE "content_slate_header_default_header" (
  "id" integer,
  "contest_slate_header_id" integer,
  "default_slate_header_id" integer,
  "date_created" timestamp,
  "date_modified" timestamp
);

CREATE TABLE "contest_result" (
  "id" integer,
  "contest_slate_entry_id" integer,
  "contest_user_id" integer,
  "home_score" integer,
  "away_score" integer,
  "expected_result" varchar(2),
  "home_score_matches" boolean,
  "away_score_matches" boolean,
  "scores_matches" boolean,
  "result_matches" boolean,
  "is_banker" boolean,
  "has_started" boolean,
  "has_finished" boolean,
  "deadline_time" timestamp,
  "date_created" timestamp,
  "date_modified" timestamp
);

CREATE TABLE "contest_result_scoring" (
  "id" integer,
  "scoring_system_detail_id" integer,
  "contest_result_id" integer,
  "points_available" integer,
  "points_scored" integer,
  "date_created" timestamp,
  "date_modified" timestamp
);

ALTER TABLE "user_assigned_role" ADD FOREIGN KEY ("user_header_id") REFERENCES "user_header" ("id");

ALTER TABLE "user_assigned_role" ADD FOREIGN KEY ("user_role_id") REFERENCES "user_role" ("id");

ALTER TABLE "user_connection" ADD FOREIGN KEY ("user_id") REFERENCES "user_header" ("id");

ALTER TABLE "user_connection" ADD FOREIGN KEY ("follower_id") REFERENCES "user_header" ("id");

ALTER TABLE "contest_header" ADD FOREIGN KEY ("created_by") REFERENCES "user_header" ("id");

ALTER TABLE "contest_header" ADD FOREIGN KEY ("current_owner") REFERENCES "user_header" ("id");

ALTER TABLE "contest_header" ADD FOREIGN KEY ("last_modified_by") REFERENCES "user_header" ("id");

ALTER TABLE "scoring_system_header" ADD FOREIGN KEY ("created_by") REFERENCES "user_header" ("id");

ALTER TABLE "scoring_system_header" ADD FOREIGN KEY ("last_modified_by") REFERENCES "user_header" ("id");

ALTER TABLE "contest_header" ADD FOREIGN KEY ("id") REFERENCES "scoring_system_header" ("contest_header_id");

ALTER TABLE "scoring_system_detail" ADD FOREIGN KEY ("scoring_system_header_id") REFERENCES "scoring_system_header" ("id");

ALTER TABLE "scoring_system_detail" ADD FOREIGN KEY ("last_modified_by") REFERENCES "user_header" ("id");

ALTER TABLE "scoring_system_detail" ADD FOREIGN KEY ("created_by") REFERENCES "user_header" ("id");

ALTER TABLE "user_invite" ADD FOREIGN KEY ("invite_creator") REFERENCES "user_header" ("id");

ALTER TABLE "user_header" ADD FOREIGN KEY ("id") REFERENCES "successful_invite_user" ("new_user_id");

ALTER TABLE "user_invite" ADD FOREIGN KEY ("id") REFERENCES "successful_invite_user" ("userinvite_id");

ALTER TABLE "contest_user" ADD FOREIGN KEY ("contest_header_id") REFERENCES "contest_header" ("id");

ALTER TABLE "contest_user" ADD FOREIGN KEY ("participant_type_id") REFERENCES "participant_type" ("id");

ALTER TABLE "contest_user" ADD FOREIGN KEY ("user_id") REFERENCES "user_header" ("id");

ALTER TABLE "contest_user" ADD FOREIGN KEY ("created_by") REFERENCES "user_header" ("id");

ALTER TABLE "contest_user" ADD FOREIGN KEY ("invited_by") REFERENCES "user_header" ("id");

ALTER TABLE "event" ADD FOREIGN KEY ("season_id") REFERENCES "season" ("id");

ALTER TABLE "fixture_header" ADD FOREIGN KEY ("season_id") REFERENCES "season" ("id");

ALTER TABLE "fixture_header" ADD FOREIGN KEY ("team_a") REFERENCES "team" ("fpl_team_id");

ALTER TABLE "fixture_header" ADD FOREIGN KEY ("team_h") REFERENCES "team" ("fpl_team_id");

ALTER TABLE "fixture_header" ADD FOREIGN KEY ("event") REFERENCES "event" ("id");

ALTER TABLE "event" ADD FOREIGN KEY ("id") REFERENCES "default_slate_header" ("event_id");

ALTER TABLE "default_slate_entries" ADD FOREIGN KEY ("default_slate_header_id") REFERENCES "default_slate_header" ("id");

ALTER TABLE "fixture_header" ADD FOREIGN KEY ("id") REFERENCES "default_slate_entries" ("fixture_id");

ALTER TABLE "contest_slate_header" ADD FOREIGN KEY ("contest_header_id") REFERENCES "contest_header" ("id");

ALTER TABLE "contest_slate_entry" ADD FOREIGN KEY ("contest_slate_header_id") REFERENCES "contest_slate_header" ("id");

ALTER TABLE "contest_slate_entry" ADD FOREIGN KEY ("fixture_id") REFERENCES "fixture_header" ("id");

ALTER TABLE "content_slate_header_default_header" ADD FOREIGN KEY ("default_slate_header_id") REFERENCES "default_slate_header" ("id");

ALTER TABLE "content_slate_header_default_header" ADD FOREIGN KEY ("contest_slate_header_id") REFERENCES "contest_slate_header" ("id");

ALTER TABLE "contest_result" ADD FOREIGN KEY ("contest_slate_entry_id") REFERENCES "contest_slate_entry" ("id");

ALTER TABLE "contest_result" ADD FOREIGN KEY ("contest_user_id") REFERENCES "contest_user" ("id");

ALTER TABLE "contest_result_scoring" ADD FOREIGN KEY ("contest_result_id") REFERENCES "contest_result" ("id");

ALTER TABLE "contest_result_scoring" ADD FOREIGN KEY ("scoring_system_detail_id") REFERENCES "scoring_system_detail" ("id");