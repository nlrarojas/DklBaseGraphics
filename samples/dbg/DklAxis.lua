--
-- DklAxis.lua
--
-- Döiköl Base Graphics Library
--
-- Copyright (c) 2017-2018 Armando Arce - armando.arce@gmail.com
--
-- This library is free software; you can redistribute it and/or modify it
-- under the terms of the MIT license. See LICENSE for details.
--

DklBaseGraphics = DklBaseGraphics or {}

function DklBaseGraphics:axis(side,args)
	args = args or {}
	
	local axisMode = ((side == 2) or (side == 3)) and -1 or 1
	local labels = args.labels
	local at = args.at or (labels and seq(0,#labels,1))
	
	local xlim = self.fig.xlim
	local ylim = self.fig.ylim
	
	if (at==nil) then
		if (side==1 or side==3) then
			at = seq(xlim[1],xlim[2],math.floor(100/self.dev.size[1]*self.plt.usr[2]))
		elseif (side == 2 or side==4) then
			at = seq(ylim[1],ylim[2],math.floor(100/self.dev.size[2]*self.plt.usr[4]))
		end
	end
	
	labels = labels or at
	
	stroke(0)
	textAlign(CENTER,CENTER)
	
	pushMatrix()
	translate(self.fig.xoff,self.fig.yoff)
	translate(self.plt.xoff,self.plt.yoff)

	local _x,_y
	local _tck = self.plt.tck*self.fig.pin[1]*axisMode*self.dev.res

	if ((side == 1) or (side == 3)) then
		line(0, 0, self.fig.pin[1]*self.dev.res, 0)
		for i=1,#at do
			_x = (at[i]-xlim[1])*self.plt.xscl
			line(_x,0,_x,_tck)
			text(labels[i],_x,_tck*3)
		end
	elseif ((side == 2) or (side == 4)) then
		line(0, 0, 0, -self.fig.pin[2]*self.dev.res)
		for i=1,#at do
			_y = -(at[i]-ylim[1])*self.plt.yscl
			line(0,_y,_tck,_y)
			text(labels[i],_tck*3,_y)
		end
	end
	popMatrix()
end
