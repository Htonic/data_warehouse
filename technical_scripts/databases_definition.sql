CREATE DATABASE bl_dm
ON
( NAME = bl_dm_dat,
    FILENAME = 'D:\sql_server_databases\bl_dm_dat.mdf'
	)
LOG ON
( NAME = bl_dm_log,
    FILENAME = 'D:\sql_server_databases\bl_dm_log.ldf') ;

CREATE DATABASE bl_3nf
ON
( NAME = bl_3nf_dat,
    FILENAME = 'D:\sql_server_databases\bl_3nf_dat.mdf'
	)
LOG ON
( NAME = bl_3nf_log,
    FILENAME = 'D:\sql_server_databases\bl_3nf_log.ldf' ) ;

CREATE DATABASE bl_cl
ON
( NAME = bl_cl_dat,
    FILENAME = 'D:\sql_server_databases\bl_cl_dat.mdf'
	)
LOG ON
( NAME = bl_cl_log,
    FILENAME = 'D:\sql_server_databases\bl_cl_log.ldf') ;

CREATE DATABASE sa_src
ON
( NAME = sa_src_dat,
    FILENAME = 'D:\sql_server_databases\sa_src_dat.mdf'
	)
LOG ON
( NAME = sa_src_log,
    FILENAME = 'D:\sql_server_databases\sa_src_log.ldf') ;

