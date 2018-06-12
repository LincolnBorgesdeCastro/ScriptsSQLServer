use distribution


select distinct
      M.article , 
      M.publication_id, 
      S.publication,
      X.publisher_db 
from MSarticles M 
inner join MSpublications  S on M.publication_id =S.publication_id 
inner join MSsubscriptions X on X.publication_id =S.publication_id
where M.article not in (
select distinct
      N.article 
from dbreports.dbreports.dbo.MSreplication_objects N)
