create function dbo.UrlEncode(@str varchar(max))
returns varchar(max)
as
begin
	with replacements
		as
		(select ' ' as f, '%20' as t
		union select '!', '%21'
		union select '"', '%22'
		union select '#', '%23'
		union select '$', '%24'
		union select '&', '%26'
		union select '''', '%27'
		union select '(', '%28'
		union select ')', '%29'
		union select '*', '%2A'
		union select '+', '%2B'
		union select ',', '%2C'
		union select '-', '%2D'
		union select '.', '%2E'
		union select '/', '%2F'
		union select ':', '%3A'
		union select ';', '%3B'
		union select '<', '%3C'
		union select '=', '%3D'
		union select '>', '%3E'
		union select '?', '%3F'
		union select '@', '%40'
		union select '[', '%5B'
		union select '\', '%5C'
		union select ']', '%5D'
		union select '^', '%5E'
		union select '_', '%5F'
		union select '`', '%60'
		union select '{', '%7B'
		union select '|', '%7C'
		union select '}', '%7D'
		union select '~', '%7E')

	select @str = replace(@str, r.f, r.t)
		from replacements r;

	return @str;
end
go