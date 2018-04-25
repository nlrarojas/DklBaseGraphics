--
-- DklUtilities.lua
--
-- Döiköl Base Graphics Library
--
-- Copyright (c) 2017-2018 Armando Arce - armando.arce@gmail.com
--
-- This library is free software; you can redistribute it and/or modify it
-- under the terms of the MIT license. See LICENSE for details.
--

function tableCopy(orig)
   local orig_type = type(orig)
   local copy
   if orig_type == 'table' then
      copy = {}
      for orig_key, orig_value in pairs(orig) do
         copy[orig_key] = orig_value
      end
   else -- number, string, boolean, etc
      copy = orig
   end
   return copy
end

function seq(from,to,by)
	local _seq = {}
	for i=from,to,by do
		table.insert(_seq,i)
	end
	return _seq
end

function reverse(tbl)
	local len = #tbl
	local ret = {}
	for i = len, 1, -1 do
		ret[ len - i + 1 ] = tbl[ i ]
	end
	return ret
end

function range(data)
	local maxv = data[1]
	local minv = data[1]
	for i=2,#data do
		if (maxv<tonumber(data[i])) then
			maxv = tonumber(data[i])
		end
		if (minv>tonumber(data[i])) then
			minv = tonumber(data[i])
		end
	end
	return {minv,maxv}
end
