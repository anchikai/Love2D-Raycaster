local cachedImageData = {}

-- creates a grayscale decoded image
return function(filename)
	local result = cachedImageData[filename]
	if result ~= nil then
		return result
	end

	result = {}
	local imageData = love.image.newImageData(filename)
	result.X, result.Y = imageData:getDimensions()
	for x = 0, result.X - 1 do
		local column = {}
		result[x] = column
		for y = 0, result.Y - 1 do
			local red, green, blue = imageData:getPixel(x, y)
			column[y] = {
				r = red,
				g = green,
				b = blue
			}
		end
	end
	cachedImageData[filename] = result
	return result
end