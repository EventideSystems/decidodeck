select
  id,
  'Scorecard' as artifact_type,
  name,
  description,
  workspace_id,
  created_at,
  updated_at,
  deleted_at
from
  scorecards

union 

select
  initiatives.id,
  'Initiative' as artifact_type,
  initiatives.name,
  initiatives.description,
  workspace_id,
  initiatives.created_at,
  initiatives.updated_at,
  initiatives.deleted_at
from
  initiatives
inner join scorecards on initiatives.scorecard_id = scorecards.id;
