--
-- Example2_1.lua
--
-- Döiköl Base Graphics Library
--
-- Copyright (c) 2017-2018 Armando Arce - armando.arce@gmail.com
--
-- This library is free software; you can redistribute it and/or modify
-- it under the terms of the MIT license. See LICENSE for details.
--

require "dbg/DklBaseGraphics"

local bg
local x
local y
local col

function setup()
	size(500,350)
	local f = loadFont("data/Karla.ttf",12)
	textFont(f)
	bg = DklBaseGraphics:new(width(),height())
	x = {10,40,20,70,50}
	maleData = {10,40,20,70,50}	
	y = {20,70,50,30,10}
	femaleData = {20,70,50,30,10}
	col = {"#00FF00","#FF0000"}
end

function draw()
	background(255)
	
	bg:par({mfrow={2,2}})
	bg:plot(x,x,{type="p",col=col,bty="n",main="PLOT 1",sub="subplot 1",xlab="X axis",ylab="Y axis"})
	bg:identify(x,x,{labels=x})
	bg:box({which="figure"})
	bg:plot(y,y,{type="p",bty="n",main="PLOT 2",sub="subplot 2",xlab="X axis",ylab="Y axis"})
	bg:text(y,y,y)
	bg:box({which="figure"})
	bg:plot(x,y,{type="bullet",col=col,bty="n",main="PLOT 3",sub="subplot 3",xlab="X axis",ylab="Y axis", barLength=45, target=55})
	bg:box({which="figure"})
	bg:plot(y,x,{type="pop",col=col,bty="n",main="PLOT 4",sub="subplot 4",xlab="X axis",ylab="Y axis", femaleData= femaleData, maleData=maleData})
	bg:box({which="figure"})
end

function windowResized(w,h)
	bg:resize_window(w,h)
end
