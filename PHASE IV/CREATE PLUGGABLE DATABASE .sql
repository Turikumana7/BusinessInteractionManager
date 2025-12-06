 CREATE PLUGGABLE DATABASE Mon_26989_Claude_BusinessInteractionManager_DB
  2  ADMIN USER Claude_Admin IDENTIFIED BY Claude
  3  FILE_NAME_CONVERT = (
  4    'C:\APP\BELLO\PRODUCT\21C\ORADATA\XE\PDBSEED\',
  5    'C:\APP\BELLO\PRODUCT\21C\ORADATA\XE\Mon_26989_Claude_BusinessInteractionManager_DB\'
  6  );
  
   ALTER PLUGGABLE DATABASE Mon_26989_Claude_BusinessInteractionManager_DB OPEN;
   ALTER PLUGGABLE DATABASE Mon_26989_Claude_BusinessInteractionManager_DB SAVE STATE;