require "csv"
require "dbg/DklBaseGraphics"

local bg
local data

function setup()
	size(500,350)
	local f = loadFont("data/Karla.ttf",18)
	textFont(f)
	bg = DklBaseGraphics:new(width(),height())
	data = readCSV("data/pressure.csv",true,',')
end

function draw()
	background(255)
	bg:plot(data['temperature'],data['pressure'],{main="Pressure (mm Hg)",xlab="temperature",ylab="pressure"})
end

function windowResized(w,h)
	bg:resize_window(w,h)
end
