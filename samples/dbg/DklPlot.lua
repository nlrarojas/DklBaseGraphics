--
-- DklPlot.lua
--
-- Döiköl Base Graphics Library
--
-- Copyright (c) 2017-2018 Armando Arce - armando.arce@gmail.com
--
-- This library is free software; you can redistribute it and/or modify
-- it under the terms of the MIT license. See LICENSE for details.
--

DklBaseGraphics = DklBaseGraphics or {}

require "dbg/DklAxis"

function DklBaseGraphics:plot(x,y,args)
	args = args or {}
	local xlim = xlim or range(x)
	local ylim = ylim or range(y)
	self:plot_new()
	self:plot_window(xlim,ylim,args)
	
	local axes = args.axes or true
	local ann = args.axes or self.plt.ann
	local bty = args.bty or "o"
	local type = args.type or "p"

	if (type=="p" or type=="o" or type=="b") then
		self:points(x,y,args)
	elseif (type=="l" or type=="o" or type=="b") then
		self:lines(x,y,args)
	elseif (type=="pop") then
		self:populationGraph(x, y, args)
	elseif(type=="bullet") then 
		self:bulletGraph(x, y, args)
	end
	if (axes) then
		self:axis(1,args)
		self:axis(2,args)
		self:box({which="plot",bty=bty})
	end
	if (ann) then
		self:title(args)
	end
end

function DklBaseGraphics:points(x,y,args)
	args = args or {}
	
	local pch = args.pch or self.plt.pch
	local tpch = type(pch) == "table"
	local _pch = pch

	local cex = args.cex or self.plt.cex
	local tcex = type(cex) == "table"
	local _cex = cex
	
	local col = args.col or self.plt.col
	local tcol = type(col) == "table"
	
	local bg = args.bg or self.plt.bg
	local tbg = type(bg) == "table"

	local lwd = args.lwd or self.plt.lwd
	local tlwd = type(lwd) == "table"
	local _tmp
		
	pushMatrix()
	translate(self.fig.xoff,self.fig.yoff)
	translate(self.plt.xoff,self.plt.yoff)
	translate(-self.plt.usr[1]*self.plt.xscl,self.plt.usr[3]*self.plt.yscl)
	
	noFill()
	_tmp = not tcol and stroke(col)
	_tmp = not tbg and pch > 14 and fill(bg)
	_tmp = not tlwd and strokeWeight(lwd)
	
	for i=1,#x do
		_cex = tcex and cex[(i-1)%#cex+1] or _cex
		_pch = tpch and pch[(i-1)%#pch+1] or _pch
		_tmp = tcol and stroke(col[(i-1)%#col+1])
		_tmp = tbg and _pch > 14 and fill(bg[(i-1)%#bg+1])
		_tmp = tlwd and strokeWeight(lwd[(i-1)%#tlwd+1])
		shape(_pch,x[i]*self.plt.xscl,-y[i]*self.plt.yscl,
				_cex*self.dev.cra[1],_cex*self.dev.cra[1])
	end
	popMatrix()
end

function DklBaseGraphics:lines(x,y,args)
	args = args or {}
	
	local col = args.col or self.plt.col
	local _col = type(col) == "table" and col[1] or col
	stroke(_col)

	local lwd = args.lwd or self.plt.lwd
	local _lwd = type(lwd) == "table" and lwd[1] or lwd
	strokeWeight(_lwd)
	
	pushMatrix()
	translate(self.fig.xoff,self.fig.yoff)
	translate(self.plt.xoff,self.plt.yoff)
	translate(-self.plt.usr[1]*self.plt.xscl,self.plt.usr[3]*self.plt.yscl)
	
	beginShape()
	for i=1,#x do
		vertex(x[i]*self.plt.xscl,-y[i]*self.plt.yscl)
	end
	endShape()
	
	popMatrix()
end

function DklBaseGraphics:text(x,y,labels,args)
	args = args or {}
	
	local col = args.col or self.plt.col
	local tcol = type(col) == "table"
	
	local cex = args.cex or self.plt.cex
	local tcex = type(cex) == "table"
	local _tmp
	
	local pos = args.pos or 1
	local offset = args.offset or 1
	local offX=0
	local offY=0
	if (pos==1) then
		offY = offset*self.dev.cra[1]
	elseif (pos==2) then
		offX = -offset*self.dev.cra[1]
	elseif (pos==3) then
		offY = -offset*self.dev.cra[1]
	elseif (pos==4) then
		offX = offset*self.dev.cra[1]
	end

	pushMatrix()
	translate(self.fig.xoff,self.fig.yoff)
	translate(self.plt.xoff,self.plt.yoff)
	translate(-self.plt.usr[1]*self.plt.xscl,self.plt.usr[3]*self.plt.yscl)
	
	_tmp = not tcol and stroke(col)
--	_tmp = not tcex and textSize(cex)
	
	for i=1,#x do
		_tmp = tcol and stroke(col[(i-1)%#col+1])
--		_tmp = tcex and textSize(cex[(i-1)%#cex+1])
		text(labels[i],x[i]*self.plt.xscl+offX,-y[i]*self.plt.yscl-offY)
	end
	
	popMatrix()
end

function DklBaseGraphics:identify(x,y,args)
	args = args or {}
	
	local tlrnc = args.tolerance or 0.1
	local offset = args.offset or 1
	local labels = args.labels or nil
	offset = offset * self.dev.cra[1]
	
	event(PRESSED)
	rectMode(CENTER)
	stroke(0,0)
	pushMatrix()
	translate(self.fig.xoff,self.fig.yoff)
	translate(self.plt.xoff,self.plt.yoff)
	translate(-self.plt.usr[1]*self.plt.xscl,self.plt.usr[3]*self.plt.yscl)
	local evt = nil
	for i=1,#x do
		evt = rect(x[i]*self.plt.xscl,-y[i]*self.plt.yscl,
				tlrnc*self.dev.res,tlrnc*self.dev.res)
		if (evt) then
			table.insert(self.fig.selection,i)
		end
	end
	if (labels) then
		for j,i in pairs(self.fig.selection) do
			text(labels[i],x[i]*self.plt.xscl+offset,-y[i]*self.plt.yscl-offset)
		end
	end
	popMatrix()
	noEvent()
	return self.fig.selection
end

function DklBaseGraphics:populationGraph(x, y, args)
	args = args or {}
	
	local col = args.col or self.plt.col
	local _col = type(col) == "table" and col[1] or col
	stroke(_col)

	local lwd = args.lwd or self.plt.lwd
	local _lwd = type(lwd) == "table" and lwd[1] or lwd
	strokeWeight(_lwd)
	
	pushMatrix()
	translate(self.fig.xoff,self.fig.yoff)
	translate(self.plt.xoff,self.plt.yoff)
	translate(-self.plt.usr[1]*self.plt.xscl,self.plt.usr[3]*self.plt.yscl)	
	beginShape()
	noStroke()
	for i=1,#x do
		fill("#0000AE")	
		rect((self.fig.xoff/2.55)-maleData[i],-((i*self.plt.yscl*4)*self.plt.yscl+self.plt.yscl*(#maleData+self.plt.yscl*4)),maleData[i], self.plt.yscl*4)
		fill("#FF3B5D")		
		rect(self.fig.xoff/2.5,-((i*self.plt.yscl*4)*self.plt.yscl+self.plt.yscl*(#maleData+self.plt.yscl*4)),femaleData[i], self.plt.yscl*4)
	end
	endShape()
	
	popMatrix()
end

function DklBaseGraphics:bulletGraph(x, y, args)
	args = args or {}
	
	local col = args.col or self.plt.col
	local _col = type(col) == "table" and col[1] or col
	stroke(_col)

	local lwd = args.lwd or self.plt.lwd
	local _lwd = type(lwd) == "table" and lwd[1] or lwd
	strokeWeight(_lwd)
	
	pushMatrix()
	translate(self.fig.xoff,self.fig.yoff)
	translate(self.plt.xoff,self.plt.yoff)
	translate(-self.plt.usr[1]*self.plt.xscl,self.plt.usr[3]*self.plt.yscl)	
	
	if (self.fig.xoff == 0) then
		xPosition = self.fig.xoff + 25
	end
	
	beginShape()
	noStroke()
	max = getMaximumValue(x)
	grayScale = getGrayScale(x, max)
	table.sort(x)
	for i=#x, 1, -1 do
		fill(grayScale[i])	
		rect(xPosition,-self.fig.yoff/3,x[i]*2, self.plt.yscl*20)		
	end
	fill(0)
	rect(xPosition,-((self.fig.yoff/3) - (self.plt.yscl*7.5)),args.barLength*2, self.plt.yscl*5)	
	rect(xPosition+(args.target*2),-((self.fig.yoff/2.7) - (self.plt.yscl*7.5)),2, self.plt.yscl*15)	
	endShape()
	
	popMatrix()
end

function getMaximumValue(values)
	temp = 0
	for i=1, #values do
		if (temp < values[i]) then
			temp = values[i]
		end
	end
	return temp
end

function getGrayScale(values, max)
	col = 0
	grayScale = {}
	for	i=1, #values do
		col = (values[i] / max) * 170
		col = col + 50
		table.insert(grayScale, col)
	end
	return grayScale
end

