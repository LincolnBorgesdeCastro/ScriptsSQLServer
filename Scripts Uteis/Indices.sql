--select name,* from sysindexes


SELECT 'Objeto' = SYSINDEXES.ID,
       'Tabela' = SYSOBJECTS.NAME,
       'Indice' = SYSINDEXES.NAME,
       CASE SYSINDEXES.INDID
            WHEN 1   THEN 'Clustered'
            WHEN 255 THEN 'Text/Image'
            ELSE 'NonClustered'
        END AS 'Tipo',
        'Campos'     = SYSINDEXES.KEYCNT,
        'FillFactor' = SYSINDEXES.ORIGFILLFACTOR,
        'Registros'  = SYSINDEXES.ROWS,
        'CampoIndice'= SYSCOLUMNS.NAME
FROM SYSINDEXES INNER JOIN SYSOBJECTS ON
     SYSINDEXES.ID = SYSOBJECTS.ID
LEFT JOIN SYSINDEXKEYS ON SYSINDEXKEYS.ID=SYSINDEXES.ID AND SYSINDEXKEYS.INDID=SYSINDEXES.INDID
LEFT JOIN SYSCOLUMNS ON SYSCOLUMNS.ID = SYSINDEXKEYS.ID AND SYSCOLUMNS.ColOrder = SYSINDEXKEYS.COLID
where sysobjects.xtype = 'u' and SYSINDEXES.NAME not like '_wa%' 
and SYSINDEXES.NAME not like 'pk%' and SYSOBJECTS.NAME not like 'log%'




set nocount on
select
case
when i.name like 'hind_c_%' then 'drop index ['
else 'drop statistics ['
end,object_name(i.id) + '].[' + i.name + ']' from sysindexes i join
sysobjects o on i.id = o.id
where
i.name like 'hind_%' and
(INDEXPROPERTY(i.id, i.name, 'IsHypothetical') = 1 OR
(INDEXPROPERTY(i.id, i.name, 'IsStatistics') = 1 AND INDEXPROPERTY(i.id,
i.name, 'IsAutoStatistics') = 0))
order by i.name

select
case
when i.name like 'hkhk' then 'drop index ['
else 'drop statistics ['
end,
object_name(i.id) + '].['+ i.name + ']' from sysindexes i join
sysobjects o on i.id = o.id
where
i.name like '_wa%' --and
--(INDEXPROPERTY(i.id, i.name, 'IsHypothetical') = 1 OR
--(INDEXPROPERTY(i.id, i.name, 'IsStatistics') = 1 AND INDEXPROPERTY(i.id,
--i.name, 'IsAutoStatistics') = 0))
order by i.name
set nocount off



--------- Apaga os indices Hipoteticos

-- DECLARE @strSQL nvarchar(1024) 
-- DECLARE @objid int 
-- DECLARE @indid tinyint 
-- DECLARE ITW_Stats CURSOR FOR SELECT id, indid FROM sysindexes WHERE name LIKE 'hind_%' ORDER BY name 
-- OPEN ITW_Stats 
-- FETCH NEXT FROM ITW_Stats INTO @objid, @indid 
-- WHILE (@@FETCH_STATUS <> -1) 
-- BEGIN 
-- SELECT @strSQL = (SELECT case when INDEXPROPERTY(i.id, i.name, 'IsStatistics') = 1 then 'drop statistics [' else 'drop index [' end + OBJECT_NAME(i.id) + '].[' + i.name + ']' 
-- FROM sysindexes i join sysobjects o on i.id = o.id 
-- WHERE i.id = @objid and i.indid = @indid AND 
-- (INDEXPROPERTY(i.id, i.name, 'IsHypothetical') = 1 OR
-- (INDEXPROPERTY(i.id, i.name, 'IsStatistics') = 1 AND 
-- INDEXPROPERTY(i.id, i.name, 'IsAutoStatistics') = 0))) 
-- print @strSQL
-- --EXEC(@strSQL)  ---<<<<<<
-- FETCH NEXT FROM ITW_Stats INTO @objid, @indid
-- END
-- CLOSE ITW_Stats 
-- DEALLOCATE ITW_Stats