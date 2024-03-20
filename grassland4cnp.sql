insert into cdyaktion ("action",action_de,action_en,action_id,unit_intensity,def_intensity,def_intensity_en,def_intensity_de) values ('cutting grasland              ','Mahd Grünland','cutting grasland',6,'dt/ha               ','yield (DM)          ','yield (DM)','Ertrag (DM)');
insert into cdyaktion ("action",action_de,action_en,action_id,unit_intensity,def_intensity,def_intensity_en,def_intensity_de) values ('start grassland               ','start grassland','start grassland',12,'dt/ha               ','-                   ','-','-');
insert into cdyaktion ("action",action_de,action_en,action_id,unit_intensity,def_intensity,def_intensity_en,def_intensity_de) values ('cattle upforce                ','Auftrieb','cattle upforce',10,'GVE/ha              ','-                   ','-','-');
insert into cdyaktion ("action",action_de,action_en,action_id,unit_intensity,def_intensity,def_intensity_en,def_intensity_de) values ('cattle downforce              ','Abtrieb','cattle downforce',11,'GVE/ha              ','-                   ','-','-');


insert into cdyopspa (oram,item_ix,"name",name_en,name_de,dm,c_dm,cnr,cnr_alt,mor,cpr,k,eta,ros_ix,"comment",pmor ) 
values (true,-64,'grass 1 cut                   ',NULL,NULL,0.22,41.5,27.5,25.0,0.1,147.0,0.15,0.5,21,NULL,0.0 );
insert into cdyopspa (oram,item_ix,"name",name_en,name_de,dm,c_dm,cnr,cnr_alt,mor,cpr,k,eta,ros_ix,"comment",pmor ) 
values (true,-88,'grass cutting                 ',NULL,NULL,0.22,41.5,25.0,25.0,0.0,108.0,0.15,0.5,21,NULL,0.0 );
insert into cdyopspa (oram,item_ix,"name",name_en,name_de,dm,c_dm,cnr,cnr_alt,mor,cpr,k,eta,ros_ix,"comment",pmor )
values (false,-99,'Grass_roots                   ',NULL,NULL,1.0,1.0,80.0,80.0,0.0,470.0,0.2,0.45,21,NULL,0.0 );
insert into cdyopspa (oram,item_ix,"name",name_en,name_de,dm,c_dm,cnr,cnr_alt,mor,cpr,k,eta,ros_ix,"comment",pmor )
values (true,-47,'feces                         ','feces','feces',0.14,32.0,17.5,7.0,1.5,70.6,0.1,0.6708333333333325,7,NULL,0.0 );

update cdyopspa set 
item_ix=(select max(item_ix)+1 from cdyopspa) where name='feces';

update cdyopspa set 
item_ix=(select max(item_ix)+1 from cdyopspa) where name='Grass_roots';

update cdyopspa set 
item_ix=(select max(item_ix)+1 from cdyopspa) where name='grass 1 cut';

update cdyopspa set 
item_ix=(select max(item_ix)+1 from cdyopspa) where name='grass cutting';


insert into cdypflan (item_ix,"name",name_en,name_de,c_mp,stix,rix,fix_s,fix_r,bix,n_mp,p_mp,dm_mp,leg_ix,seed_ix,ros_ix,rt_ix,gm_ix,sh_ix,"comment") values (-99,'permGrassland              ',NULL,'Gruenland             ',45.0,1.0,0.0,1.36,56.88,0.0,2.6,0.99,1.0,1010,-99,8,4,88,64,NULL);

update cdypflan set item_ix=(select max(item_ix+1) from cdypflan) where name='permGrassland';

update cdypflan set 
rt_ix= (select item_ix from cdyopspa where name='Grass_roots') where name ='permGrassland';

update cdypflan set 
sh_ix= (select item_ix from cdyopspa where name='grass cutting') where name ='permGrassland';

update cdypflan set 
gm_ix= (select item_ix from cdyopspa where name='grass 1 cut') where name ='permGrassland';


CREATE OR REPLACE VIEW public.cnp_objects
AS SELECT 0 AS macode,
    cdyaktion.action,
    cdypflan.name,
    btrim("left"(cdypflan.name::text, 25)) AS item,
    cdypflan.item_ix,
    cdyaktion.unit_intensity,
    cdyaktion.def_intensity,
    100000 * 0 + cdypflan.item_ix AS ix
   FROM cdypflan,
    cdyaktion
  WHERE cdyaktion.action_id = 0
UNION
 SELECT 1 AS macode,
    cdyaktion.action,
    cdypflan.name,
    btrim("left"(cdypflan.name::text, 25)) AS item,
    cdypflan.item_ix,
    cdyaktion.unit_intensity,
    cdyaktion.def_intensity,
    100000 * 1 + cdypflan.item_ix AS ix
   FROM cdypflan,
    cdyaktion
  WHERE cdyaktion.action_id = 1
UNION
 SELECT 2 AS macode,
    cdyaktion.action,
    cdypflan.name,
    btrim("left"(cdypflan.name::text, 25)) AS item,
    cdypflan.item_ix,
    cdyaktion.unit_intensity,
    cdyaktion.def_intensity,
    100000 * 2 + cdypflan.item_ix AS ix
   FROM cdypflan,
    cdyaktion
  WHERE cdyaktion.action_id = 2
UNION
 SELECT 9 AS macode,
    cdyaktion.action,
    cdypflan.name,
    btrim("left"(cdypflan.name::text, 25)) AS item,
    cdypflan.item_ix,
    cdyaktion.unit_intensity,
    cdyaktion.def_intensity,
    100000 * 9 + cdypflan.item_ix AS ix
   FROM cdypflan,
    cdyaktion
  WHERE cdyaktion.action_id = 9
UNION
 SELECT 3 AS macode,
    cdyaktion.action,
    cdyopspa.name,
    btrim("left"(cdyopspa.name::text, 25)) AS item,
    cdyopspa.item_ix,
    cdyaktion.unit_intensity,
    cdyaktion.def_intensity,
    100000 * 3 + cdyopspa.item_ix AS ix
   FROM cdyopspa,
    cdyaktion
  WHERE cdyaktion.action_id = 3 AND cdyopspa.oram
UNION
 SELECT 4 AS macode,
    cdyaktion.action,
    cdymindg.name,
    btrim("left"(cdymindg.name::text, 25)) AS item,
    cdymindg.item_ix,
    cdyaktion.unit_intensity,
    cdyaktion.def_intensity,
    100000 * 4 + cdymindg.item_ix AS ix
   FROM cdymindg,
    cdyaktion
  WHERE cdyaktion.action_id = 4
UNION
 SELECT 5 AS macode,
    'tillage'::character varying AS action,
    'ploughing'::character varying AS name,
    'ploughing'::text AS item,
    0 AS item_ix,
    cdyaktion.unit_intensity,
    cdyaktion.def_intensity,
    100000 * 5 + 0 AS ix
   FROM cdyaktion
  WHERE cdyaktion.action_id = 5
UNION
 SELECT 14 AS macode,
    'cons.till.'::character varying AS action,
    'unknown'::character varying AS name,
    '?'::text AS item,
    0 AS item_ix,
    cdyaktion.unit_intensity,
    cdyaktion.def_intensity,
    100000 * 14 + 0 AS ix
   FROM cdyaktion
  WHERE cdyaktion.action_id = 14
UNION
 SELECT 6 AS macode,
    cdyaktion.action,
    cdypflan.name,
    btrim("left"(cdypflan.name::text, 25)) AS item,
    cdypflan.item_ix,
    cdyaktion.unit_intensity,
    cdyaktion.def_intensity,
    100000 * 6 + cdypflan.item_ix AS ix
   FROM cdypflan,
    cdyaktion
  WHERE cdyaktion.action_id = 6
UNION
 SELECT 12 AS macode,
    cdyaktion.action,
    cdypflan.name,
    btrim("left"(cdypflan.name::text, 25)) AS item,
    cdypflan.item_ix,
    cdyaktion.unit_intensity,
    cdyaktion.def_intensity,
    100000 * 12 + cdypflan.item_ix AS ix
   FROM cdypflan,
    cdyaktion
  WHERE cdyaktion.action_id = 12
UNION
 SELECT 7 AS macode,
    'irrigation'::character varying AS action,
    'unknown'::character varying AS name,
    '?'::text AS item,
    0 AS item_ix,
    cdyaktion.unit_intensity,
    cdyaktion.def_intensity,
    100000 * 7 + 0 AS ix
   FROM cdyaktion
  WHERE cdyaktion.action_id = 7
UNION
 SELECT 10 AS macode,
    'up-force'::character varying AS action,
    'cattle unit'::character varying AS name,
    'cattle unit'::text AS item,
    0 AS item_ix,
    cdyaktion.unit_intensity,
    cdyaktion.def_intensity,
    100000 * 10 + 0 AS ix
   FROM cdyaktion
  WHERE cdyaktion.action_id = 10
UNION
 SELECT 11 AS macode,
    'down-force'::character varying AS action,
    'cattle unit'::character varying AS name,
    'cattle unit'::text AS item,
    0 AS item_ix,
    cdyaktion.unit_intensity,
    cdyaktion.def_intensity,
    100000 * 11 + 0 AS ix
   FROM cdyaktion
  WHERE cdyaktion.action_id = 11
  ORDER BY 8;