--
-- DklBaseGraphics.lua
--
-- Döiköl Base Graphics Library
--
-- Copyright (c) 2017-2018 Armando Arce - armando.arce@gmail.com
--
-- This library is free software; you can redistribute it and/or modify it
-- under the terms of the MIT license. See LICENSE for details.
--

require "dbg/DklUtilities"
require "dbg/DklPlot"

DklBaseGraphics = DklBaseGraphics or {}

function DklBaseGraphics:new(w,h)
	d = {}
   setmetatable(d, self)
   self.__index = self
   self.dev = {size={w,h},cra={10.8,14.4},cin={0.15,0.20},csi=0.166, 
		cxy={0.02604167,0.03875969},din={0,0},res=96,init=true
	}
	self.dev.din = {w/self.dev.res,h/self.dev.res}
   self.def = {
		adj=0.5,ann=true,bg="transparent",bty="o",cex=0.83,cex_axis=1,
		cex_lab=1,cex_main=1.2,cex_sub=1,col="black",
		col_axis="black",col_lab="black",col_main="black",col_sub="black",
		fg="black",font=1,font_axis=1,font_lab=1,font_main=1, font_sub=1,
		gamma=nil, lab={5,5,7}, las=0, lty="solid", lwd=1, mgp={3,1,0},
		pch=2,srt=0, tck=0.03, tcl=-0.5, tmag=0, type=0, xaxp={0,1,5}, 
		xaxs="r", xaxt="s", xpd=false, yaxp={0,1,5},yaxs="r", yaxt="s"
	}
	self.fig = {ask=false, family="", fin=nil, lend="round", 
		lheight=1, ljoin = "round", lmitre = 10, mai={0.5,0.5,0.5,0.5},
		mar={5.1,4.1,4.1,2.1}, mex=1, mfcol={1,1}, mfg={1,1,1,1}, 
		mfrow={1,1}, new=false, oma={0,0,0,0}, omd={0,1,0,1}, 
		omi={0,0,0,0},pin=nil, ps=12, pty="m", usr={0,1,0,1}, 
		xlog=false, ylog=false, col=-1, row=0, selection = {}}
	self.plt = {}
	self:resize()
	self:make_symbols()
   return d
end

function DklBaseGraphics:make_symbols()
	local c = 0.275957512247
	beginShape()
	vertex(-0.5,0.5)
	vertex(0.5,0.5)
	vertex(0.5,-0.5)
	vertex(-0.5,-0.5)
	vertex(-0.5,0.5)
	saveShape()
	beginShape()
	vertex(0,0.5)
	bezierVertex(c,0.5,0.5,c,0.5,0)
	vertex(0.5,0)
	bezierVertex(0.5,-c,c,-0.5,0,-0.5)
	vertex(0,-0.5)
	bezierVertex(-c,-0.5,-0.5,-c,-0.5,0)
	vertex(-0.5,0)
	bezierVertex(-0.5,c,-c,0.5,0,0.5)
	saveShape()
end

function DklBaseGraphics:plot_new()
	self.plt = tableCopy(self.def)
	if (self.dev.init) then 
		self.dev.init=false
		self:resize()
	end
	if (self.fig.mfrow[1]==1 and self.fig.mfrow[2]==1) then
		self.fig.col = 0
		self.fig.row = 0
	elseif (self.fig.col < self.fig.mfrow[1]-1) then
		self.fig.col = self.fig.col + 1
	else
		self.fig.col = 0
		self.fig.row = self.fig.row + 1
	end
	self.fig.xoff = 
		(self.fig.omi[1]*(self.fig.col+1)+
		 (self.fig.omi[3]+self.fig.fin[1])*self.fig.col)*
		self.dev.res
	self.fig.yoff = 
		(self.fig.omi[2]*(self.fig.row+1)+
		 (self.fig.omi[4]+self.fig.fin[2])*self.fig.row)*
		self.dev.res
	self.plt.xoff = self.dev.res*self.fig.mai[1]
	self.plt.yoff = self.dev.res*(self.fig.mai[2]+self.fig.pin[2])
end

function DklBaseGraphics:resize()

	self.fig.fin = {
		self.dev.din[1]/self.fig.mfrow[1]-self.fig.omi[1]-self.fig.omi[3],
		self.dev.din[2]/self.fig.mfrow[2]-self.fig.omi[2]-self.fig.omi[4]}
						
	self.fig.pin = {
		self.fig.fin[1]-self.fig.mai[1]-self.fig.mai[3],
		self.fig.fin[2]-self.fig.mai[2]-self.fig.mai[4]}

end

function DklBaseGraphics:extent(args)
	args = args or {}
	self.fig.xlim =  args.xlim or self.fig.xlim
	self.fig.ylim =  args.ylim or self.fig.ylim
	local xlim = self.fig.xlim
	local ylim = self.fig.ylim

	self.plt.usr = {xlim[1],xlim[2]-xlim[1],ylim[1],ylim[2]-ylim[1]}
	self.plt.xaxp = seq(xlim[1],xlim[2],10/(xlim[2]-xlim[1]))
	self.plt.yaxp = seq(ylim[1],ylim[2],10/(ylim[2]-ylim[1]))
	
	self.plt.xscl = self.fig.pin[1]/self.plt.usr[2]*self.dev.res
	self.plt.yscl = self.fig.pin[2]/self.plt.usr[4]*self.dev.res
end

function DklBaseGraphics:resume(args)
	self.fig.col = -1
	self.fig.row = 0
	self:resize()
end

function DklBaseGraphics:plot_window(xlim,ylim,args)
	args = args or {}
	args.xlim = xlim
	args.ylim = ylim
	self:extent(args)
end

function DklBaseGraphics:resize_window(w,h)
	self.dev.size = {w,h}
   self.dev.din = {w/self.dev.res,h/self.dev.res}
   self:resize()
end

function DklBaseGraphics:mtext(text,args)
end

function DklBaseGraphics:title(args)
	args = args or {}
	local main = args.main
	local sub = args.sub
	local xlab = args.xlab
	local ylab = args.ylab
	pushMatrix()
	translate(self.fig.xoff,self.fig.yoff)
	if (main) then
		textAlign(CENTER,CENTER)
		text(main,self.fig.fin[1]/2*self.dev.res,10)
	end
	if (sub) then
		textAlign(CENTER,CENTER)
		text(sub,self.fig.fin[1]/2*self.dev.res,20)
	end
	if (xlab) then
		textAlign(CENTER,CENTER)
		text(xlab,self.fig.fin[1]/2*self.dev.res,self.fig.fin[2]*self.dev.res-10)
	end
	if (ylab) then
		textAlign(CENTER,CENTER)
		translate(15,self.fig.fin[2]/2*self.dev.res)
		rotate(-PI/2)
		text(ylab,0,0)
	end
	popMatrix()
end

function DklBaseGraphics:box(args)
	args = args or {}
	local which = args.which or "plot"
	local bty = args.bty or "o"
	if (bty=="n") then return end
	pushMatrix()
	translate(self.fig.xoff,self.fig.yoff)
	stroke(0)
	noFill()
	rectMode(CORNER)
	if (which=="plot") then
		translate(self.fig.mai[1]*self.dev.res,self.fig.mai[2]*self.dev.res)
		rect(0,0,self.fig.pin[1]*self.dev.res,self.fig.pin[2]*self.dev.res)
	elseif (which=="figure") then
		rect(0,0,self.fig.fin[1]*self.dev.res,self.fig.fin[2]*self.dev.res)
	end
	popMatrix()
end

function DklBaseGraphics:rect(xleft,ybottom,xright,ytop,args)
end

function DklBaseGraphics:segments(x0,y0,x1,y1,args)
end

function DklBaseGraphics:par(args)
	args = args or {}
	local dim_func = {mai=true,mar=true,pin=true,plt=true,usr=true,
		fig=true,fin=true,oma=true,omd=true,omi=true}
	local grid_func = {mfrow=true,mfcol=true}
	for key,value in pairs(args) do
		if (self.plt[key]) then
			self.plt[key] = value
		elseif (self.fig[key]) then
			self.fig[key] = value
		end
		if dim_func[key] then
			self:resize(args)
		elseif grid_func[key] then
			self:resume(args)
		end
   end
end
