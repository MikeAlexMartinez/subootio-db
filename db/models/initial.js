const contest_invite_type = [
  'id',
  'name',
];
const contest_type = [
  'id',
  'name',
  'description'
];
const default_scoring_system_header = [
  'id',
  'is_custom',
  'name',
  'description'
];
const default_scoring_system_detail = [
  'id',
  'default_scoring_system_header_id',
  'scoring_type_id',
  'is_active',
  'is_default',
  'points'
];
const participant_type = [
  'id',
  'participant_type_name',
  'participant_description'
];
const scoring_type = [
  'id',
  'name',
  'description'
];
const season = [
  'id',
  'competition',
  'start_year',
  'end_year',
  'is_current',
  'is_previous',
  'is_next'
];
const user_role = [
  'id',
  'name',
  'description'
];
const user_header = [
  'id',
  'email',
  'first_name',
  'last_name',
  'country_code',
  'phone_number',
  'favorite_team',
  'country',
  'display_name',
  'is_private',
  'is_premium',
  'password',
  'publickey'
];
const user_assigned_role = [
  'id',
  'user_header_id',
  'user_role_id'
];

module.exports = {
  contest_invite_type,
  contest_type,
  default_scoring_system_header,
  default_scoring_system_detail,
  participant_type,
  scoring_type,
  season,
  user_role,
  user_header,
  user_assigned_role,
};