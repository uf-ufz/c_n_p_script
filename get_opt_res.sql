drop  table  if exists opti.simresults;

create table opti.simresults as (
select obs.fl_id,obs.mm,obs.yr,obs.obsval, res.simval from
(select m.fl_id,mm,yr,meas_value as obsval
from measurements m join site_state s on s.fl_id=m.fl_id and s.status=1
where year_number>0 and m_ix=1) obs,
(select r.fl_id,mm,yr,pav as simval
from cnp_result r join site_state s on s.fl_id=r.fl_id and s.status=1 where year_num>0) res
where obs.fl_id=res.fl_id and obs.mm=res.mm and obs.yr=res.yr
);
