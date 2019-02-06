
exec dbo.CheckExists 'dbo.GetJsonValues', 'FT'
go

alter function dbo.GetJsonValues
  (@json varchar(max),
   @properties varchar(1000))

/*
  Authors:      AV
  Version:      v1-0
  Modify date:  2019-02-06
  Description: For SQL server 2005 - 2014. Find string value in JSON blob
  Examples: select *
  from dbo.GetJsonValues('{"service":"cdb","minion_ip":"10.1.1.1","host":"tesu","state":"RUNNING","minion":"srvdr$3"}', '"service","host","state","minion","test"')
*/

returns table
as
return
  (select
      p.value as Property,
      replace(replace(replace(replace(replace(j.value, p.value + ':', ''), '{', ''), '[', ''), '}', ''), ']', '') as Value
    from string_split(@properties, ',') p
      left join
        (select s.value from string_split(@json, ',') s) j
          on j.value like '%' + p.value + ':%'
  )
go