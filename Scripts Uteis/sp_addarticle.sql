exec sp_addarticle @publication = N'IPASGO - Polimed', @article = N'POLIMED_procedimentos', @source_owner = N'dbo'
        , @source_object = N'POLIMED_procedimentos', @type = N'logbased', @description = N'', @creation_script = N''
        , @pre_creation_cmd = N'drop', @schema_option = 0x000000000803509F, @identityrangemanagementoption = N'manual' 
        , @destination_table = N'POLIMED_procedimentos', @destination_owner = N'dbo', @status = 8
        , @vertical_partition = N'false', @ins_cmd = N'CALL [sp_MSins_dboPOLIMED_procedimentos]'
        , @del_cmd = N'CALL [sp_MSdel_dboPOLIMED_procedimentos]', @upd_cmd = N'SCALL [sp_MSupd_dboPOLIMED_procedimentos]',@force_invalidate_snapshot=1