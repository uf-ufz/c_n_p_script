insert into cnpaction ("action",action_de,action_en,action_id,unit_intensity,def_intensity,def_intensity_en,def_intensity_de) values ('cutting grasland              ','Mahd Grasland','cutting grasland',6,'dt/ha               ','yield (DM)          ','yield (DM)','Ertrag (DM)');
insert into cnpaction ("action",action_de,action_en,action_id,unit_intensity,def_intensity,def_intensity_en,def_intensity_de) values ('start grassland               ','Start Grasland','start grassland',12,'dt/ha               ','-                   ','-','-');
insert into cnpaction ("action",action_de,action_en,action_id,unit_intensity,def_intensity,def_intensity_en,def_intensity_de) values ('grazing                ','Weide','grazing',10,'#/ha              ','cattle units                  ','cattle units','GVE');

insert into cnporam (oram,item_ix,"name",name_en,name_de,dm,c_dm,cnr,cnr_alt,mor,cpr,k,eta,ros_ix,"comment",pmor ) 
values (true,-64,'grass 1 cut                   ',NULL,NULL,0.22,41.5,27.5,25.0,0.1,147.0,0.15,0.5,21,NULL,0.0 );
insert into cnporam (oram,item_ix,"name",name_en,name_de,dm,c_dm,cnr,cnr_alt,mor,cpr,k,eta,ros_ix,"comment",pmor ) 
values (true,-88,'grass cutting                 ',NULL,NULL,0.22,41.5,25.0,25.0,0.0,108.0,0.15,0.5,21,NULL,0.0 );
insert into cnporam (oram,item_ix,"name",name_en,name_de,dm,c_dm,cnr,cnr_alt,mor,cpr,k,eta,ros_ix,"comment",pmor )
values (false,-99,'Grass_roots                   ',NULL,NULL,1.0,1.0,80.0,80.0,0.0,470.0,0.2,0.45,21,NULL,0.0 );
insert into cnporam (oram,item_ix,"name",name_en,name_de,dm,c_dm,cnr,cnr_alt,mor,cpr,k,eta,ros_ix,"comment",pmor )
values (true,-47,'feces','feces','feces',0.14,32.0,17.5,7.0,1.5,70.6,0.1,0.6708333333333325,7,NULL,0.0 );

update cnporam set 
item_ix=(select max(item_ix)+1 from cnporam) where name='feces';

update cnporam set 
item_ix=(select max(item_ix)+1 from cnporam) where name='Grass_roots';

update cnporam set 
item_ix=(select max(item_ix)+1 from cnporam) where name='grass 1 cut';

update cnporam set 
item_ix=(select max(item_ix)+1 from cnporam) where name='grass cutting';


insert into cnpplant (item_ix,"name",name_en,name_de,c_mp,stix,rix,fix_s,fix_r,bix,n_mp,p_mp,dm_mp,leg_ix,seed_ix,ros_ix,rt_ix,gm_ix,sh_ix,"comment") values (-99,'permGrassland              ',NULL,'Gruenland             ',45.0,1.0,0.0,1.36,56.88,0.0,2.6,0.99,1.0,1010,-99,8,4,88,64,NULL);

update cnpplant set item_ix=(select max(item_ix+1) from cnpplant) where name='permGrassland';

update cnpplant set 
rt_ix= (select item_ix from cnporam where name='Grass_roots') where name ='permGrassland';

update cnpplant set 
sh_ix= (select item_ix from cnporam where name='grass cutting') where name ='permGrassland';

update cnpplant set 
gm_ix= (select item_ix from cnporam where name='grass 1 cut') where name ='permGrassland';

drop table if exists cnpgrazing;

CREATE TABLE public.cnpgrazing (
	item_ix int4 NULL,
	"name" text NULL,
	c_excr float8 NULL,
	oram_id int4 NULL,
	n_offt float8 NULL,    
	p_offt float8 NULL,
	c_offt float8 NULL,
    "comment" text NULL
);

insert into public.cnpgrazing (item_ix,"name",n_offt,c_excr,oram_id,"comment",p_offt,c_offt) values (0,'cattle unit',0.308,1.74,-99,'from candy as daily prms',0.117,5.33);

update cnpgrazing set oram_id= (select item_ix from cnporam where name='feces');

drop view if exists public.cnp_objects;

CREATE OR REPLACE VIEW public.cnp_objects
AS SELECT 0 AS macode,
    cnpaction.action,
    cnpplant.name,
    btrim("left"(cnpplant.name::text, 25)) AS item,
    cnpplant.item_ix,
    cnpaction.unit_intensity,
    cnpaction.def_intensity,
    100000 * 0 + cnpplant.item_ix AS ix
   FROM cnpplant,
    cnpaction
  WHERE cnpaction.action_id = 0
UNION
 SELECT 1 AS macode,
    cnpaction.action,
    cnpplant.name,
    btrim("left"(cnpplant.name::text, 25)) AS item,
    cnpplant.item_ix,
    cnpaction.unit_intensity,
    cnpaction.def_intensity,
    100000 * 1 + cnpplant.item_ix AS ix
   FROM cnpplant,
    cnpaction
  WHERE cnpaction.action_id = 1 and not( left(cnpplant.name,5)='permG' )
UNION
 SELECT 2 AS macode,
    cnpaction.action,
    cnpplant.name,
    btrim("left"(cnpplant.name::text, 25)) AS item,
    cnpplant.item_ix,
    cnpaction.unit_intensity,
    cnpaction.def_intensity,
    100000 * 2 + cnpplant.item_ix AS ix
   FROM cnpplant,
    cnpaction
  WHERE cnpaction.action_id = 2 and not( left(cnpplant.name,5)='permG' )
UNION
 SELECT 9 AS macode,
    cnpaction.action,
    cnpplant.name,
    btrim("left"(cnpplant.name::text, 25)) AS item,
    cnpplant.item_ix,
    cnpaction.unit_intensity,
    cnpaction.def_intensity,
    100000 * 9 + cnpplant.item_ix AS ix
   FROM cnpplant,
    cnpaction
  WHERE cnpaction.action_id = 9 and not( left(cnpplant.name,5)='permG' )
UNION
 SELECT 3 AS macode,
    cnpaction.action,
    cnporam.name,
    btrim("left"(cnporam.name::text, 25)) AS item,
    cnporam.item_ix,
    cnpaction.unit_intensity,
    cnpaction.def_intensity,
    100000 * 3 + cnporam.item_ix AS ix
   FROM cnporam,
    cnpaction
  WHERE cnpaction.action_id = 3 AND cnporam.oram
UNION
 SELECT 4 AS macode,
    cnpaction.action,
    cnpminfrt.name,
    btrim("left"(cnpminfrt.name::text, 25)) AS item,
    cnpminfrt.item_ix,
    cnpaction.unit_intensity,
    cnpaction.def_intensity,
    100000 * 4 + cnpminfrt.item_ix AS ix
   FROM cnpminfrt,
    cnpaction
  WHERE cnpaction.action_id = 4
UNION
 SELECT 5 AS macode,
    'tillage'::character varying AS action,
    'ploughing'::character varying AS name,
    'ploughing'::text AS item,
    0 AS item_ix,
    cnpaction.unit_intensity,
    cnpaction.def_intensity,
    100000 * 5 + 0 AS ix
   FROM cnpaction
  WHERE cnpaction.action_id = 5
UNION
 SELECT 14 AS macode,
    'cons.till.'::character varying AS action,
    'unknown'::character varying AS name,
    '?'::text AS item,
    0 AS item_ix,
    cnpaction.unit_intensity,
    cnpaction.def_intensity,
    100000 * 14 + 0 AS ix
   FROM cnpaction
  WHERE cnpaction.action_id = 14
UNION
 SELECT 6 AS macode,
    cnpaction.action,
    cnpplant.name,
    btrim("left"(cnpplant.name::text, 25)) AS item,
    cnpplant.item_ix,
    cnpaction.unit_intensity,
    cnpaction.def_intensity,
    100000 * 6 + cnpplant.item_ix AS ix
   FROM cnpplant,
    cnpaction
  WHERE cnpaction.action_id = 6 and  left(cnpplant.name,5)='permG'
UNION
 SELECT 12 AS macode,
    cnpaction.action,
    cnpplant.name,
    btrim("left"(cnpplant.name::text, 25)) AS item,
    cnpplant.item_ix,
    cnpaction.unit_intensity,
    cnpaction.def_intensity,
    100000 * 12 + cnpplant.item_ix AS ix
   FROM cnpplant,
    cnpaction
  WHERE cnpaction.action_id = 12 and  left(cnpplant.name,5)='permG'
UNION
 SELECT 7 AS macode,
    'irrigation'::character varying AS action,
    'unknown'::character varying AS name,
    '?'::text AS item,
    0 AS item_ix,
    cnpaction.unit_intensity,
    cnpaction.def_intensity,
    100000 * 7 + 0 AS ix
   FROM cnpaction
  WHERE cnpaction.action_id = 7
UNION
 SELECT 10 AS macode,
    cnpaction.action,
    cnpgrazing.name,
    btrim("left"(cnpgrazing.name::text, 25)) AS item,
    cnpgrazing.item_ix,
    cnpaction.unit_intensity,
    cnpaction.def_intensity,
    100000 * 10 + 0 AS ix
   FROM cnpaction,cnpgrazing
  WHERE cnpaction.action_id = 10
  ORDER BY 8;