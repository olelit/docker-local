select "vehicles".*
from "vehicles"
         inner join "appraisal_studio_filter_vehicle" as "asfv" on "vehicles"."id" = "asfv"."vehicle_id"
         inner join "appraisal_studio_filters" as "asf" on "asfv"."appraisal_studio_filter_id" = "asf"."id"
         inner join "appraisal_connections" as "ac" on "ac"."appraisal_studio_filter_id" = "asf"."id"
         inner join "appraisal_connection_settings" as "acs" on "vehicles"."location_id" = "acs"."location_id"
         left join "purchase_offers" as "po"
                   on "vehicles"."id" = "po"."vehicle_id" and "vehicles"."created_at" < "po"."created_at"
         inner join (select MIN(asf_inner.priority) AS min_priority, asfv_inner.vehicle_id
                     from "appraisal_studio_filter_vehicle" as "asfv_inner"
                              inner join "appraisal_studio_filters" as "asf_inner"
                                         on "asfv_inner"."appraisal_studio_filter_id" = "asf_inner"."id"
                              inner join "vehicles" as "v_inner" on "v_inner"."id" = "asfv_inner"."vehicle_id"
                     where "asf_inner"."location_id" = "v_inner"."location_id"
                     group by "asfv_inner"."vehicle_id") as "min_priority_subquery"
                    on "asfv"."vehicle_id" = "min_priority_subquery"."vehicle_id" and
                       "asf"."priority" = "min_priority_subquery"."min_priority"
         inner join "scheduled_hybrid_offers" as "sho" on "vehicles"."id" = "sho"."vehicle_id"
where not exists (select *
                  from "locations"
                  where "vehicles"."location_id" = "locations"."id"
                    and "slug" in ('victory-lane-imports', 'victory-lane-imports-2')
                    and "locations"."deleted_at" is null)
  and "asf"."deleted_at" is null
  and "sho"."status" = 0
  and (("vehicles"."form_type" != 'widget' and "acs"."driveo_wholesale_type" = 'Hybrid' and
        "asf"."vehicle_type" = 'wholesale' and "acs"."driveo_wholesale_time_condition_enabled" = true and
        date_trunc('minute', sho.scheduled_on) <= date_trunc('minute', NOW() AT TIME ZONE 'UTC')) or
       ("vehicles"."form_type" = 'widget' and "acs"."widget_wholesale_type" = 'Hybrid' and
        "asf"."vehicle_type" = 'wholesale' and "acs"."widget_wholesale_time_condition_enabled" = true and
        date_trunc('minute', sho.scheduled_on) <= date_trunc('minute', NOW() AT TIME ZONE 'UTC')) or
       ("vehicles"."form_type" != 'widget' and "acs"."driveo_retail_type" = 'Hybrid' and
        "asf"."vehicle_type" = 'retail' and "acs"."driveo_retail_time_condition_enabled" = true and
        date_trunc('minute', sho.scheduled_on) <= date_trunc('minute', NOW() AT TIME ZONE 'UTC')) or
       ("vehicles"."form_type" = 'widget' and "acs"."widget_retail_type" = 'Hybrid' and
        "asf"."vehicle_type" = 'retail' and "acs"."widget_retail_time_condition_enabled" = true and
        date_trunc('minute', sho.scheduled_on) <= date_trunc('minute', NOW() AT TIME ZONE 'UTC')) or
       ("acs"."catch_all_type" = 'Hybrid' and "asf"."is_catch_all" = true and
        "acs"."catch_all_time_condition_enabled" = true and
        date_trunc('minute', sho.scheduled_on) <= date_trunc('minute', NOW() AT TIME ZONE 'UTC')))
  and "vehicles"."status" in ('finished', 'uploaded')
  and "po"."id" is null
group by "vehicles"."id"