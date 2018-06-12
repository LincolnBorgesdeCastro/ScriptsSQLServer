use OSMTDLAB
go

BEGIN TRY

declare @sql varchar(8000)
declare @filtro varchar(200)
declare @filtro_www varchar(200)

-- inicia a declaração do sql
set @sql = ''
set @filtro = '%OSIDX_OSUSR_3MB_ENVIONOTIFICACAO1_8PESSOAID%'



IF OBJECT_ID('TEMPDB..#result') IS NOT NULL DROP TABLE #result

select
   tabelas.name   as Tabela 
  ,colunas.name   as Coluna
  ,tipos.name     as Tipo
  ,colunas.length as Tamanho
into
  #result
from 
  sysobjects tabelas
  inner join syscolumns colunas
  on colunas.id = tabelas.id
  --
  inner join systypes tipos
  on tipos.xtype = colunas.xtype
where 
  tabelas.xtype = 'u'
    and
  -- colocar aqui os tipos de coluna que serão buscados
  tipos.name in('text', 'ntext', 'varchar', 'nvarchar')


-- cursor para varrer as tabelas
declare cTabelas cursor local fast_forward for
select distinct Tabela from #result

declare @nomeTabela varchar(255)

open cTabelas

fetch next from cTabelas into @nomeTabela

while @@fetch_status = 0
begin
  
  -- cursor para varrer as colunas da tabela corrente
  declare cColunas cursor local fast_forward for
  select '['+Coluna+']', Tipo, Tamanho from #result where Tabela = @nomeTabela

  declare @nomeColuna varchar(255)
  declare @tipoColuna varchar(255)
  declare @tamanhoColuna varchar(255)

  open cColunas

  -- monta as colunas da cláusula select 
  fetch next from cColunas into @nomeColuna, @tipoColuna, @tamanhoColuna
  
  while @@fetch_status = 0
  begin
    -- cria a declaração da variável
    set @sql = 'declare @hasresults bit' + char(13) + char(10) + char(13) + char(10)
    -- cria o select
    set @sql = @sql + 'select' + char(13) + char(10)
    set @sql = @sql + char(9) + '''' + @nomeTabela + ''' AS NomeTabela'
    set @sql = @sql + char(9) + ',' + @nomeColuna + char(13) + char(10)
    -- adiciona uma coluna com o tipo e o tamanho do campo
    set @sql = @sql  + char(9) + ',' + '''' + @tipoColuna + ''' AS ''' + @nomeColuna + '_Tipo''' + char(13) + char(10)
    set @sql = @sql  + char(9) + ',' + 'DATALENGTH(' + @nomeColuna + ') AS ''' + @nomeColuna + '_Tamanho_Ocupado''' + char(13) + char(10)    
    set @sql = @sql  + char(9) + ',' + '''' + @tamanhoColuna + ''' AS ''' + @nomeColuna + '_Tamanho_Maximo''' + char(13) + char(10)

    -- define a tabela temporária (#result)
    set @sql = @sql + 'into' + char(13) + char(10) + char(9) + '#result_' + @nomeTabela + char(13) + char(10)
    -- adiciona a cláusula from
    set @sql = @sql +  'from' + char(13) + char(10) + char(9) + @nomeTabela + char(13) + char(10)
    -- inicia a montagem do where
    set @sql = @sql + 'where' + char(13) + char(10)
    set @sql = @sql + char(9) + @nomeColuna + ' like ''' + @filtro + '''' + char(13) + char(10)
    
    set @sql = @sql + char(13) + char(10) + 'select @hasresults = count(*) from #result_' + @nomeTabela + char(13) + char(10)
    set @sql = @sql + char(13) + char(10) + 'if @hasresults > 0'
    set @sql = @sql + char(13) + char(10) + 'begin'
    set @sql = @sql + char(13) + char(10) + char(9) + 'select * from #result_' + @nomeTabela
    set @sql = @sql + char(13) + char(10) + 'end' + char(13) + char(10)
    set @sql = @sql + char(13) + char(10) + 'drop table #result_' + @nomeTabela
    set @sql = @sql + char(13) + char(10)

    fetch next from cColunas into @nomeColuna, @tipoColuna, @tamanhoColuna
	-- descomente a linha abaixo para ver o SQL produzido no janela de Messages
    --print @sql
    exec(@sql)
    set @sql = ''
  end
  
  close cColunas
  deallocate cColunas
  
  fetch next from cTabelas into @nomeTabela
end

close cTabelas
deallocate cTabelas

drop table #result

END TRY

BEGIN CATCH
   IF @@TRANCOUNT > 0
   BEGIN
      ROLLBACK TRANSACTION
   END

  print @sql
  declare @DESC_Mensagem  varchar(8000)

  SET @DESC_Mensagem = ISNULL(@DESC_Mensagem, '') + CHAR(13)
                        + 'Detalhes:' + CHAR(13)
                        + '- Número: ' + LTRIM(RTRIM(CONVERT(VARCHAR(950),ERROR_NUMBER()))) + '.' + CHAR(13)
                        + '- Descrição: ' + LTRIM(RTRIM(CONVERT(VARCHAR(950),ERROR_MESSAGE()))) + CHAR(13)
                        + '- Linha: ' + LTRIM(RTRIM(CONVERT(VARCHAR(950),ERROR_LINE()))) + '.' + CHAR(13)
  RAISERROR (@DESC_Mensagem, 16, 1 )

END CATCH


