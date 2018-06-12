select e.*
, CONVERT(datetime, es.start_time) AS start_time
, CONVERT(datetime, es.end_time) AS end_time
, es.execution_duration , es.statistics_id
, es.execution_result
, case es.execution_result
 when 0 then 'Success'
 when 1 then 'Failure'
    when 2 then 'Completion'
    when 3 then 'Cancelled'
 end  as execution_result_description

from catalog.executables e join catalog.executable_statistics es on  e.executable_id = es.executable_id
                                                                 and e.execution_id = es.execution_id
where package_path  =  '\Package'
--and  e.execution_id = 10275