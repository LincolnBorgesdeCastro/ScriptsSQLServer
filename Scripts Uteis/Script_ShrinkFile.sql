-- Script para diminuir o tamanho de um arquivo.
-- Este exemplo diminui o arquivo para 24MB

use [pubs] DBCC SHRINKFILE (N'pubs_Data', 24)